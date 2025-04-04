{-# LANGUAGE LambdaCase #-}

import Codec.Binary.UTF8.String qualified as UTF8
import Control.Exception
import DBus qualified as D
import DBus.Client qualified as D
import Data.List.Split
import Data.Map.Strict qualified as M
import Data.Maybe
import Data.Monoid
import System.Directory
import XMonad
import XMonad.Actions.DynamicProjects
  ( Project (..),
    dynamicProjects,
    switchProjectPrompt,
  )
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.RefocusLast
import XMonad.Hooks.SetWMName
import XMonad.Layout.Magnifier
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Prelude
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

newtype WorkspaceConfig
  = WorkspaceConfig [(WorkspaceId, [String])]
  deriving (Show)

workspaceConfigLocation :: FilePath
workspaceConfigLocation = "/.xmonad/workspaces"

parseWorkspaceConf :: String -> Maybe (WorkspaceId, [String])
parseWorkspaceConf = parse . filter (not . null) . splitOneOf ":,"
  where
    parse [] = Nothing
    parse (wsId : appsString) = Just (wsId, appsString)

defaultWorkspaces :: WorkspaceConfig
defaultWorkspaces = WorkspaceConfig [(show wId, []) | wId <- [1 .. 9]]

loadWorkspaceConfig :: IO (Maybe WorkspaceConfig)
loadWorkspaceConfig = do
  configLocation <- (<> workspaceConfigLocation) <$> getCurrentDirectory
  workspaceConfigContent <- readFile configLocation
  let workspaces = filter (not . null) $ lines workspaceConfigContent
  case workspaces of
    [] -> pure Nothing
    _ -> pure $ WorkspaceConfig <$> traverse parseWorkspaceConf workspaces

main :: IO ()
main = do
  WorkspaceConfig workspaces <-
    fromMaybe defaultWorkspaces
      <$> ( loadWorkspaceConfig
              `catch` ( \(e :: IOException) ->
                          pure Nothing
                      )
          )

  dbus <- mkDbusClient
  xmonad $
    ewmh $
      docks $
        def
          { terminal = "alacritty",
            layoutHook = myLayout,
            borderWidth = 3,
            normalBorderColor = "#1d2021",
            focusedBorderColor = "#fbf1c7",
            logHook = myPolybarLogHook dbus,
            manageHook = manageSpawn,
            workspaces = map fst workspaces,
            handleEventHook = myEventHook <+> fullscreenEventHook,
            startupHook = setWMName "LG3D" <+> myStartupHook workspaces
          }
          `additionalKeysP` [ ("C-<Space>", spawn "rofi -disable-history -show run"),
                              -- ("C-k", spawn "rofi -show calc -modi calc -no-show-match -no-sort"),
                              ("M-m", spawn "amixer set Master toggle"),
                              ("M-<Up>", spawn "amixer set Master 5%+"),
                              ("M-<Down>", spawn "amixer set Master 5%-")
                            ]

myStartupHook workspaces = do
  spawnOnce "systemctl --user restart polybar.service"
  forM_ workspaces $ \(wsId, apps) ->
    case apps of
      [] -> pure ()
      _ -> forM_ apps (spawnOnOnce wsId)

myLayout =
  avoidStruts $
    mySpacing $
      tiled
        ||| Mirror tiled
        ||| Full
        ||| threeCol
  where
    borderWidth = 5
    border = Border borderWidth borderWidth borderWidth borderWidth
    mySpacing =
      spacingRaw
        False
        border
        True
        border
        True
    threeCol = ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 1 / 2 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes

mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
  where
    opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s
        | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
        | otherwise = mempty
      normal = "#fbf1c7"
      gray = "#7F7F7F"
      urgent = "#ea4300"
      hidden = "#000000"
   in def
        { ppOutput = dbusOutput dbus,
          ppCurrent = wrapper normal,
          ppVisible = wrapper gray,
          ppUrgent = wrapper urgent,
          ppHidden = wrapper gray,
          ppHiddenNoWindows = wrapper hidden,
          -- hide the window title
          ppTitle = const "",
          --  hide the layout
          ppLayout = const ""
        }

myPolybarLogHook :: D.Client -> X ()
myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)

myLogHook :: X ()
myLogHook = fadeInactiveLogHook 0.9

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath = D.objectPath_ "/org/xmonad/Log"
      iname = D.interfaceName_ "org.xmonad.Log"
      mname = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body = [D.toVariant $ UTF8.decodeString str]
   in D.emit dbus $ signal {D.signalBody = body}

-- Event hook
-- Fix for sliding windows
-- https://github.com/xmonad/xmonad/issues/423

myEventHook :: Event -> X All
myEventHook =
  mconcat
    [ floatConfReqHook myFloatConfReqManageHook
    ]

floatConfReqHook :: MaybeManageHook -> Event -> X All
floatConfReqHook mh ev@ConfigureRequestEvent {ev_window = w} =
  runQuery (join <$> (isFloat -?> mh)) w >>= \case
    Nothing -> mempty
    Just e -> do
      windows (appEndo e)
      sendConfWindow -- if still floating, send ConfigureWindow
      pure (All False)
  where
    sendConfWindow = withWindowSet $ \ws ->
      whenJust (M.lookup w (W.floating ws)) $ \fr ->
        whenJust (findScreenRect ws) (confWindow fr)
    findScreenRect ws =
      listToMaybe
        [ screenRect (W.screenDetail s)
          | s <- W.current ws : W.visible ws,
            w `elem` W.integrate' (W.stack (W.workspace s))
        ]
    confWindow fr sr = withDisplay $ \dpy -> do
      let r = scaleRationalRect sr fr
      bw <- asks (borderWidth . config)
      io $
        configureWindow dpy w (ev_value_mask ev) $
          WindowChanges
            { wc_x = fi $ rect_x r,
              wc_y = fi $ rect_y r,
              wc_width = fi $ rect_width r,
              wc_height = fi $ rect_height r,
              wc_border_width = fromIntegral bw,
              wc_sibling = ev_above ev,
              wc_stack_mode = ev_detail ev
            }
floatConfReqHook _ _ = mempty

myFloatConfReqManageHook :: MaybeManageHook
myFloatConfReqManageHook =
  composeAll
    [ className =? "Steam" -?> doFloat -- prevent Steam from moving its floats to primary screen
    ]
