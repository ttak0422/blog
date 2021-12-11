{ pkgs, lib, stdenv }:
let
  # hugoで利用するテーマを定義
  theme = {
    name = "hugo-theme-stack";
    src = builtins.fetchTarball {
      url =
        "https://github.com/CaiJimmy/hugo-theme-stack/archive/359e4b34c1f96beeda472cddb54cea98522b2c14.tar.gz";
      sha256 = "12r53vmnfjv8140qnw7a3qhi0xy2lff3acfadliksv5kkjhm9kqi";
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
      hugo --buildFuture
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
