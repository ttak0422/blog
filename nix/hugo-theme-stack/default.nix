{ stdenv, fetchurl }:
stdenv.mkDerivation {
  name = "hugo-theme-stack";
  src = builtins.fetchTarball {
    url =
      "https://github.com/CaiJimmy/hugo-theme-stack/archive/refs/heads/master.tar.gz";
    sha256 = "12r53vmnfjv8140qnw7a3qhi0xy2lff3acfadliksv5kkjhm9kqi";
  };
  patches = [ ./custom.scss.patch ];
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';
}
