{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
    ]) // {
      extraArgs = "";
    };
    
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        kamadorueda.alejandra
      
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy

        golang.go

        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer

        eamodio.gitlens
        mhutchie.git-graph
      ];

      userSettings = {
        "window.titleBarStyle" = "custom";
        "window.customTitleBarVisibility" = "never";
        "window.customControlStyle" = "hidden";

        "files.autoSave" = "afterDelay";
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "JetBrains Mono, Fira Code, Consolas, monospace";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "editor.guides.bracketPairs" = "active";
        
      };
    };
  };
}