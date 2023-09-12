{
  stdenv,
  lib,
  fetchurl,
  pkgs,
  ...
}:

let 
  libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      cairo
      cups.lib
      dbus.lib
      glib
      gtk3
      libxkbcommon
      mesa
      nspr
      nss_latest
      pango
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      xorg_sys_opengl
      xorg.xrandr
      xdg-utils
  ];

  aliyunpan-unwrapped = stdenv.mkDerivation rec {
    pname = "aliyunpan-unwrapped";
    version = "v3.11.24";
  
    src = fetchurl {
      url = "https://github.com/gaozhangmin/aliyunpan/releases/download/v3.11.24/XBYDriver-3.11.24-linux-amd64.deb";
      sha256 = "sha256-Z2o+WbTtMYKj8WVVd/xREXjpO81z5e3Lh1FdZX6Eudc=";
    };
  
    unpackPhase = ''
      ar x ${src}
      tar xf data.tar.xz
    '';
    
    nativeBuildInputs = libraries;
  
    dontFixup = true;
  
    buildInputs = with pkgs; [ 
      autoPatchelfHook 
      makeWrapper 
    ];
    
    installPhase = ''
      mkdir -p $out/share $out/bin $out/opt
  
      cp -r usr/share/* $out/share
  
      sed -i "s|Exec=.*|Exec=xbyyunpan|" $out/share/applications/*.desktop
      sed -i "s|Name=.*|Name=xbyyunpan|" $out/share/applications/*.desktop
  
      cp -r opt/* $out/opt
    '';
  
  };
  base = pkgs.appimageTools.defaultFhsEnvArgs;
  fhs = pkgs.buildFHSEnvBubblewrap (base// {
    name = "xbyyunpan";
    runScript = "${aliyunpan-unwrapped}/opt/小白羊云盘/xbyyunpan";

    unshareUser = false;
    unshareIpc = false;
    unsharePid = false;
    unshareNet = false;
    unshareUts = false;
    unshareCgroup = false;
  });
in
  stdenv.mkDerivation {
    pname = "aliyunpan";
    inherit (aliyunpan-unwrapped) version;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/bin 
      ln -s "${fhs}/bin/xbyyunpan" "$out/bin/xbyyunpan"
      ln -s "${aliyunpan-unwrapped}/share" "$out/"
    '';

    meta = with lib; {
      description = "小白羊网盘 - Powered by 阿里云盘";
      homepage = "https://github.com/gaozhangmin/aliyunpan";
      license = licenses.mit;
    };
  }