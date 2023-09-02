{ stdenv
, pkgs
, lib
, fetchurl
}: let
  libraries = with pkgs; [
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    openssl_3
    librsvg
		xdotool
		xorg.libxcb
		xorg.libXrandr
		libayatana-appindicator
  ];
  
in 
  stdenv.mkDerivation rec {
    pname = "pot-translation";
    version = "2.0.0-beta.0";
  
    src = fetchurl {
      url = "https://github.com/pot-app/pot-desktop/releases/download/2.0.0-beta.0/pot_2.0.0-beta.0_amd64.deb";
      sha256 = "sha256-IhZRNMKFKXNDmb8sM2DY56sXHDi/QN2Bk9/9ixJa5tU=";
    };
    
    nativeBuildInputs = with pkgs; [autoPatchelfHook makeWrapper];
    
    buildInputs = libraries;
    
    unpackPhase = ''
      ar x ${src}
      tar xf data.tar.gz
    '';

    installPhase = ''

      mkdir -p $out/share
      cp -r usr/share/* $out/share/

      mkdir -p $out/opt
      cp usr/bin/pot $out/opt/

      mkdir -p $out/bin

      makeWrapper $out/opt/pot $out/bin/pot \
        --argv0 "pot" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraries}" \
        --prefix GDK_BACKEND : "x11"

    '';
  
    meta = with lib; {
      description = "A cross-platform software for text translation.";
      homepage = "https://github.com/pot-app/pot-desktop";
      license = licenses.unlicense;
    };
  }