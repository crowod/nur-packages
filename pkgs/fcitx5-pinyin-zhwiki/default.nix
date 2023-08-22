{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation {
  pname = "fcitx5-pinyin-zhwiki";
  version = "20230728";

  src = fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20230728.dict";
    sha256 = "sha256-m7bmyvdgUrBR+1uCRmWDc5LAiVbrnqc//Hl4iNbTkGk=";
  };

  dontUnpack = true;
  installPhase = ''
    install -Dm644 $src $HOME/.local/share/fcitx5/pinyin/dictionaries/zhwiki.dict
  '';
  meta = with lib; {
    description = "Fcitx 5 Pinyin Dictionary from zh.wikipedia.org";
    homepage = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki";
    license = licenses.unlicense;
  };
}
