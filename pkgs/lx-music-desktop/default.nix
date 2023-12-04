{ stdenv
, lib
, nss
, nspr
, mesa
, libdrm
, alsa-lib
, makeWrapper
, fetchurl
, autoPatchelfHook
, systemd
, at-spi2-atk
, cairo
, cups
, dbus
, glib
, gtk3
, libxkbcommon
, pango
, xorg
, wrapGAppsHook
, ...
}:
stdenv.mkDerivation rec {
  pname = "lx-music-desktop";
  version = "2.5.0";
  src = fetchurl {
    url = "https://github.com/lyswhut/lx-music-desktop/releases/download/v2.5.0/lx-music-desktop_2.5.0_amd64.deb";
    sha256 = "sha256-HX1tVlUzukc0EstevMXCrF/EjmsJTwNTxfmplPcWTmI=";
  };

  libraries = [
    nss
    nspr
    mesa
    libdrm
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    glib
    gtk3
    libxkbcommon
    pango
    xorg.libXcomposite
    xorg.libXrandr
  ];
  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
  '';

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
    autoPatchelfHook
  ];
  buildInputs = libraries;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin


    cp -r usr/share $out/share
    sed -i "s|Exec=.*|Exec=$out/bin/lx-music-desktop %U|" $out/share/applications/*.desktop

    cp -r opt $out/opt

    makeWrapper $out/opt/lx-music-desktop/lx-music-desktop $out/bin/lx-music-desktop \
      --argv0 "lx-music-desktop" \
      --add-flags "$out/opt/lx-music-desktop/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [stdenv.cc.cc]}" \

    runHook postInstall
  '';

  meta = with lib; {
    description = "LX Music Desktop";
    homepage = "https://lxmusic.toside.cn/";
    license = licenses.apsl20;
  };
}
