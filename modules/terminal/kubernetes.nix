{
  pkgs,
  lib,
  ...
}: {
  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      kubeconform
      kubectl
      kubectl-node-shell
      kubectx
      kubernetes-helm
      kubeseal
    ])
  ];

  programs.k9s = {
    enable = true;
    settings = {
      ui = {
        enableMouse = true;
        skin = "nord";
      };
    };
    skins = {
      nord = {
        k9s = {
          body = {
            fgColor = "#DADEE8";
            bgColor = "default";
            logoColor = "#B48EAD";
          };
          prompt = {
            fgColor = "#DADEE8";
            bgColor = "#30343F";
            suggestColor = "#D08770";
          };
          info = {
            fgColor = "#81A1C1";
            sectionColor = "#DADEE8";
          };
          dialog = {
            fgColor = "#DADEE8";
            bgColor = "default";
            buttonFgColor = "#DADEE8";
            buttonBgColor = "#B48EAD";
            buttonFocusFgColor = "#EBCB8B";
            buttonFocusBgColor = "#81A1C1";
            labelFgColor = "#D08770";
            fieldFgColor = "#DADEE8";
          };
          frame = {
            border = {
              fgColor = "#D9DEE8";
              focusColor = "#383D4A";
            };
            menu = {
              fgColor = "#DADEE8";
              keyColor = "#81A1C1";
              numKeyColor = "#81A1C1";
            };
            crumbs = {
              fgColor = "#DADEE8";
              bgColor = "#383D4A";
              activeColor = "#383D4A";
            };
            status = {
              newColor = "#88C0D0";
              modifyColor = "#B48EAD";
              addColor = "#A3BE8C";
              errorColor = "#BF616A";
              highlightColor = "#D08770";
              killColor = "#8891A7";
              completedColor = "#8891A7";
            };
            title = {
              fgColor = "#DADEE8";
              bgColor = "#383D4A";
              highlightColor = "#D08770";
              counterColor = "#B48EAD";
              filterColor = "#81A1C1";
            };
          };
          views = {
            charts = {
              bgColor = "default";
              defaultDialColors = [
                "#B48EAD"
                "#BF616A"
              ];
              defaultChartColors = [
                "#B48EAD"
                "#BF616A"
              ];
            };
            table = {
              fgColor = "#DADEE8";
              bgColor = "default";
              header = {
                fgColor = "#DADEE8";
                bgColor = "default";
                sorterColor = "#88C0D0";
              };
            };
            xray = {
              fgColor = "#DADEE8";
              bgColor = "default";
              cursorColor = "#383D4A";
              graphicColor = "#B48EAD";
              showIcons = false;
            };
            yaml = {
              keyColor = "#81A1C1";
              colonColor = "#B48EAD";
              valueColor = "#DADEE8";
            };
            logs = {
              fgColor = "#DADEE8";
              bgColor = "default";
              indicator = {
                fgColor = "#DADEE8";
                bgColor = "#B48EAD";
                toggleOnColor = "#B48EAD";
                toggleOffColor = "#81A1C1";
              };
            };
            help = {
              fgColor = "#DADEE8";
              bgColor = "#30343F";
              indicator = {
                fgColor = "#BF616A";
              };
            };
          };
        };
      };
    };
  };
}
