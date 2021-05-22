{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" ]; })
  ];

  programs.vscode = {
    enable = true;
    # no tracking for me thanks
    package = pkgs.vscodium;

    keybindings = [
      {
        key = "ctrl+space";
        command = "editor.action.triggerSuggest";
        when =
          "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
      }
      {
        key = "ctrl+space";
        command = "toggleSuggestionDetails";
        when = "suggestWidgetVisible && textInputFocus";
      }
      {
        key = "alt+k";
        command = "selectPrevSuggestion";
        when =
          "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "alt+j";
        command = "selectNextSuggestion";
        when =
          "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        command = "acceptSelectedSuggestion";
        key = "tab";
        when = "suggestWidgetVisible && textInputFocus";
      }
    ];

    userSettings = {
      "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescript]" = {
        "editor.codeActionsOnSave"."source.organizeImports" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescriptreact]" = {
        "editor.codeActionsOnSave"."source.organizeImports" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[rust]"."editor.tabSize" = "4";
      "[python]" = {
        "gitlens.codeLens.symbolScopes" = [
          "!Module"
        ];
        "editor.wordBasedSuggestions" = false;
        "editor.tabSize" = "4";
      };
      "[c]" = {
        "editor.formatOnSave" = false;
        "editor.formatOnPaste" = false;
        "editor.formatOnType" = false;
      };
      "emmet.excludeLanguages" = [
        "markdown"
        "typescript"
        "typescriptreact"
        "javascript"
        "javascriptreact"
      ];
      "editor.acceptSuggestionOnCommitCharacter" = false;
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.tabCompletion" = "on";
      "editor.snippetSuggestions" = "top";
      "editor.fontFamily" = "Fira Code";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.maxTokenizationLineLength" = "200";
      "editor.tabSize" = "2";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.factorypath" = true;
        "**/.next" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/__pycache__" = true;
      };
      "git.enableSmartCommit" = true;
      "go.formatTool" = "goimports";
      "go.lintOnSave" = "workspace";
      "java.semanticHighlighting.enabled" = true;
      "keyboard.dispatch" = "keyCode";
      "python.analysis.logLevel" = "Trace";
      "python.autoComplete.extraPaths" = [
        "."
        "/home/scoder12/.pyenv/versions/3.8.2/lib/python3.8"
      ];
      "python.formatting.provider" = "black";
      "python.languageServer" = "Microsoft";
      "terminal.integrated.fontFamily" = "MesloLGS NF";
      "vim.handleKeys" = {
        "<C-a>" = false;
        "<C-c>" = false;
        "<C-n>" = false;
        "<C-o>" = false;
        "<C-s>" = false;
        "<C-v>" = false;
        "<C-x>" = false;
        "<C-z>" = false;
        "<C-g>" = false;
        "<C-f>" = false;
      };
      "workbench.colorTheme" = "Andromeda Italic";
      "workbench.iconTheme" = "material-icon-theme";
      "gitlens.codeLens.enabled" = false;
      "coboleditor.enable_tabstop" = false;
      "coboleditor.format_on_return" = "uppercase";
      "coboleditor.intellisense_include_uppercase" = true;
      "coboleditor.intellisense_include_unchanged" = false;
      "python.dataScience.sendSelectionToInteractiveWindow" = false;
    };
  };
}
