# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  pkgs,
  lib,
  config,
   ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user ={
        name = config.hostSpec.userFullName;
        email = config.hostSpec.email.gitEmail;
      };
      init.defaultBranch = "master";
      user.signingkey = config.hostSpec.gitSigningKey;
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      push.autoSetupRemote = true;
      #diff.tool = "bc";
      #merge.tool = "bc";
      alias = {
        #ff = "merge --ff-only";
        #pushall = "!git remote | xargs -L1 git push --all";
        graph = "log --decorate --oneline --graph";
        #add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
        #fast-forward = "merge --ff-only";
      };
    };
    ignores = [
      ".csvignore"
      # nix
      "*.drv"
      "result"
      # python
      "*.py?"
      "__pycache__/"
      ".venv/"
      # direnv
      ".direnv"
    ];
 };

}
