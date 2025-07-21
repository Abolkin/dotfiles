{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;

    userName = "Abolkin";
    userEmail = "syaka.abolkin@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;

      # SSH transport configuration (default to personal)
      core.sshCommand = "ssh -i ~/.ssh/id_rsa_personal";

      # URL rewriting for different GitHub accounts
      url = {
        "git@github-personal:" = {
          insteadOf = "https://github.com/Abolkin/";
        };
        "git@github-work:" = {
          insteadOf = "https://github.com/Abolkin/";
        };
      };

      # Conditional configuration based on directory
      includeIf = {
        "gitdir:~/Code/projects/streamex/" = {
          path = "~/.config/git/work";
        };
      };
    };
  };

  # Create conditional git config for work projects
  home.file.".config/git/work".text = ''
    [user]
      name = Abolkin
      email = syaka.abolkin@gmail.com
    [core]
      sshCommand = ssh -i ~/.ssh/id_rsa_work
  '';
}

