{ pkgs, ... }: {
  haskellProjectBootstrapScript =
    pkgs.writeShellScript "haskell-project-bootstrap" ''
      PROJECT_NAME=$1
      echo "Bootstraping haskell project"

      if [ -z "$1" ]
      then
          printf "Please enter a project name: "
          read PROJECT_NAME
      else
          PROJECT_NAME="$1"
      fi

      echo "Project Name: $PROJECT_NAME"

      while true
      do
          printf "Do you want to create a flake.nix? [Y/N]: "
          read response
          if [ "$response" == "Y" ] || [ "$response" == "y" ]
          then
              echo "Creating a flake.nix ..."
              break
          elif [ "$response" == "N" ] || [ "$response" == "n" ]
          then
              echo "Skipping the creation of a flake.nix ..."
              break
          else
              echo "Invalid response. Please enter either Y or N."
          fi
      done
    '';
}
