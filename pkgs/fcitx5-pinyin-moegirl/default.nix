{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation {
  pname = "fcitx5-pinyin-moegirl";
  version = "20230814";

  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/20230814/moegirl.dict";
    sha256 = "sha256-0m6f3rg7rcgfhf4y8zyw40j3qy7pvzknf08kc73mw4266j98niii";
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
