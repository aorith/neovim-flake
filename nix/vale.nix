{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  name = "vale-setup";

  src = pkgs.fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "vale-at-red-hat";
    rev = "v468";
    sha256 = "sha256-i091kpZb7ay9zyJgvRah9HSfSlOiglh/LdKLjsaDjRM=";
  };

  installPhase = ''
    mkdir -p $out/vale/RedHat
    cp -r $src/.vale/* $out/vale/RedHat/

    cat >$out/vale.ini <<EOF
    StylesPath = $out/vale
    MinAlertLevel = suggestion

    [*]
    BasedOnStyles = RedHat
    EOF
  '';
}
