import Codec.Binary.UTF8.String qualified as UTF8
import DBus qualified as D
import DBus.Client qualified as D
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
import XMonad.Layout.Magnifier
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Ungrab

main :: IO ()
main = do
  -- Connect to DBus
  dbus <- mkDbusClient
  -- start xmonad
  xmonad $
    def
      { -- modMask = mod4Mask, -- Rebind Mod to the Super key
        terminal = "alacritty",
        layoutHook = myLayout,
        logHook = myPolybarLogHook dbus
      }
      `additionalKeysP` [ ("M-f", spawn "firefox"),
                          ("M-k", spawn "keepassxc"),
                          ("C-<Space>", spawn "rofi -disable-history -show run"),
                          ("M-m", spawn "amixer set Master toggle"),
                          ("M-<Up>", spawn "amixer set Master 5%+"),
                          ("M-<Down>", spawn "amixer set Master 5%-")
                        ]

myLayout =
  avoidStruts $
    mySpacing $
      tiled
        ||| Mirror tiled
        ||| Full
        ||| threeCol
  where
    mySpacing =
      spacingRaw
        False
        (Border 5 5 5 5)
        True
        (Border 5 5 5 5)
        True
    threeCol = ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default nummber of windows in the master pane
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
      orange = "#ea4300"
      purple = "#9058c7"
      red = "#722222"
   in def
        { ppOutput = dbusOutput dbus,
          ppCurrent = wrapper normal,
          ppVisible = wrapper gray,
          ppUrgent = wrapper orange,
          ppHidden = wrapper gray,
          ppHiddenNoWindows = wrapper red,
          -- i dont know how else to hide the window title
          ppTitle = const "" -- shorten 100 . wrapper normal
        }

myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)

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