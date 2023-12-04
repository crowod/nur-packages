{ stdenv
, lib
, fetchurl
, pkgs
, imagemagick
, ...
}:

let
  aliyunpan-unwrapped = stdenv.mkDerivation rec {
    pname = "aliyunpan-unwrapped";
    version = "v3.12.2";

    src = fetchurl {
      url = "https://github.com/gaozhangmin/aliyunpan/releases/download/v3.12.2/XBYDriver-3.12.2-linux-amd64.deb";
      sha256 = "sha256-AWy4rgKZP2FAYaUZXNvDH8ElVGTRn0wSkn12lZUj8eM=";
    };

    unpackPhase = ''
      ar x ${src}
      tar xf data.tar.xz
    '';

    nativeBuildInputs = [ imagemagick ];

    dontFixup = true;

    installPhase = ''
      mkdir -p $out/share $out/bin $out/opt
  
      cp -r usr/share/* $out/share
  
      sed -i "s|Exec=.*|Exec=xbyyunpan|; \$a Keywords=xbyyunpan" $out/share/applications/*.desktop
  
      cp -r opt/* $out/opt

      for size in 16 24 32 48 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        convert -background none -resize "$size"x"$size" $out/share/icons/hicolor/0x0/apps/xbyyunpan.png $out/share/icons/hicolor/"$size"x"$size"/apps/xbyyunpan.png
      done
    '';

  };
  base = pkgs.appimageTools.defaultFhsEnvArgs;
  fhs = pkgs.buildFHSEnvBubblewrap (base // {
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
  phases = [ "installPhase" ];
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
