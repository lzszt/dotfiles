{ pkgs, ... }:
{
  extension = pkgs.vscode-extensions.gitlab.gitlab-workflow;
  user-settings.gitlab = {
    aiAssistedCodeSuggestions.enabled = false;
    duo.enabledWithoutGitlabProject = false;
    duoChat.enabled = false;
    duoCodeSuggestions.enabled = false;
    showPipelineUpdateNotifications = true;
  };
  default = true;
  keybindings = [
    {
      key = "alt+e";
      command = "-gl.explainSelectedCode";
      when = "config.gitlab.duoChat.enabled && editorHasSelection && gitlab:chatAvailable && gitlab:chatAvailableForProject";
    }
  ];
}
