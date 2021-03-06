{ config, lib, pkgs, ... }:

with lib;

let HIST_SIZE = 32768; # 32**3
in {
  home.packages = with pkgs; [
    zsh-powerlevel10k
    zsh-fast-syntax-highlighting
    zsh-autosuggestions
  ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      # I have a mixed relationship with oh-my-zsh. On the one hand it slows
      #  down startup quite a bit, but on the other hand it *just works*. It
      #  has a lot of QoL fixes that are actively being maintainedm, such as
      #  xterm title support, git aliases, and ls colors. 
      # As long as I keep plugins light the couple seconds extra startup time is
      #  well worth the time it would take to configure manually.
      enable = true;
      plugins = [ "git" "sudo" ];
      extraConfig = ''
        DISABLE_UPDATE_PROMPT="true"
        COMPLETION_WAITING_DOTS="true"
      '';
    };
    history = {
      size = HIST_SIZE;
      save = HIST_SIZE;
      ignoreSpace = true;
    };
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Autosuggestions
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=80
      ZSH_AUTOSUGGEST_STRATEGY=(history)
    '';
    plugins = [
      {
        name = "p10k-config";
        src = lib.cleanSource ../p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];
    initExtra = ''
      # Pretty manpages with bat
      ${
        if config.programs.bat.enable then "" else "# "
      }export MANPAGER="sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'"

      # Functions
      copy () {
        # Command substitution removes trailing newlines, perfect for
        #  copying to clipboard
        local text
        if [ $# -ge 1 ]; then
          # read file given by first argument
          text=$(<$1)
        else
          # read from stdin
          text=$(<&0)
        fi
        # copy the text to the clipboard
        echo -n "$text" | xclip -sel c
      }

      tc () { # transform clipboard
        paste | eval "$*" | copy
      }

      mkcd () {
        mkdir -p "$1"
        cd "$1"
      }

      ENC_ITS=100000
      enc () {
        openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter "$ENC_ITS" -salt -in "$1" -out "$1.enc"
      }
      dec () {
        openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter "$ENC_ITS" -salt -in "$@"
      }
      dec2cmd () {
        local var=$(python -c 'import getpass;print(getpass.getpass("Enter pwd:"))')
        dec "$1" -k "$var" | eval "$2"
      }
    '';
    shellAliases = {
      # Clipboard
      c = "copy";
      paste = "xclip -o -sel c";
      p = "paste";
      # Traversal
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      # Text mainpulation
      sl = "tr -d \\n";
      tjson = "jq -Rr tojson";
      bse = "base64 -w 0";
      bsd = "base64 -d";
      # Tasks
      nf = "find . -type f -name '*.nix' -exec nixfmt {} \\;";
    };
  };
}
