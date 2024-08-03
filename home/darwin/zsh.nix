{ pkgs, myvars, ...}: {

programs.zsh = {
    initExtra = ''
      #pyenv
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

      #autojump
      .  ${pkgs.autojump}/share/autojump/autojump.zsh

      j () {
        cd "$(cat /Users/${myvars.osx_username}/Library/autojump/autojump.txt | cut -f2 | sed 's|^/Users/${myvars.osx_username}|~|' | fzf | sed 's|^~|/Users/${myvars.osx_username}|')"
      }

      bindkey "^[[1;7D" backward-word
      bindkey "^[[1;7C" forward-word
      bindkey "^[[1;7A" backward-kill-word
      #show key codes - OSX = use ctrl v, Linux = "sudo showkey -a"

      [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
    '';
    shellAliases = {
      s = "kitten ssh";
    };
  };
}