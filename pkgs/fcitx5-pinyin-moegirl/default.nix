{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation {
  pname = "fcitx5-pinyin-moegirl";
  version = "20230814";

  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/20230814/moegirl.dict";
    sha256 = "sha256-MUaLkjRGEF7HYRMBZ+ff93g8JCDcf+SJg+6xfF4ezlQ=";
  };

  dontUnpack = true;
  installPhase = ''
    install -Dm644 $src $out/share/fcitx5/pinyin/dictionaries/moegirl.dict
  '';
  meta = with lib; {
    description = "Fcitx 5 pinyin dictionary generator for MediaWiki instances";
    homepage = "https://github.com/outloudvi/mw2fcitx";
    license = licenses.unlicense;
  };
}
