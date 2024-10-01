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
}
