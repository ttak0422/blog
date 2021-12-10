{ pkgs, lib, stdenv }:
let
  # hugoで利用するテーマを定義
  theme = {
    name = "hugo-theme-stack";
    src = builtins.fetchTarball {
      url =
        " https://github.com/CaiJimmy/hugo-theme-stack/archive/refs/tags/v3.5.0.tar.gz";
      sha256 = "1af4wr6y88iby0wh02vgldsirm968y270xpwlrspn9hkyvys3kfc";
    };
  };

  # hugoのテーマのderivation
  themeDrv = stdenv.mkDerivation {
    name = theme.name;
    src = theme.src;
    patches = [ ./custom.scss.patch ];
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
    '';
  };

  # ブログのderivation
  blogDrv = stdenv.mkDerivation {
    name = theme.name;
    src = lib.cleanSource ./../..;
    buildInputs = [ pkgs.hugo themeDrv ];
    buildPhase = ''
      mkdir themes
      ln -snf ${themeDrv} themes/${theme.name}
      hugo
    '';
    installPhase = ''
      cp -r public $out
    '';
  };

  # 開発向けshellHook
  shellHook = ''
    mkdir -p themes
    ln -snf ${themeDrv} themes/${theme.name}
  '';
in { inherit blogDrv shellHook; }
