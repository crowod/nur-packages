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
  
  commandLineArgs = [
    "--enable-features=UseOzonePlatform" 
    "--ozone-platform=wayland" 
    "--enable-wayland-ime"
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

      mkdir -p $out/bin
      cp usr/bin/pot $out/bin/pot

      wrapProgram $out/bin/pot \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraries}" \
        --prefix GDK_BACKEND : "x11" \
        --add-flags "${lib.escapeShellArgs commandLineArgs}"
    '';
  
    meta = with lib; {
      description = "A cross-platform software for text translation.";
      homepage = "https://github.com/pot-app/pot-desktop";
      license = licenses.unlicense;
    };
  }