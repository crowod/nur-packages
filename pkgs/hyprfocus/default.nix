
{
  lib,
  gcc13Stdenv,
  fetchFromGitHub,
  hyprland
}:
gcc13Stdenv.mkDerivation {
    pname = "hyprfocus";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "VortexCoyote";
      repo = "hyprfocus";
      rev = "69f3f23";
      hash = "sha256-Ay6bWvDPkbgoOzlfs9WS2gZZGfhvBay+0k+niXUuHb8=";
    };

    patches = [
      ./meson.patch
    ];
    inherit (hyprland) nativeBuildInputs;
  
    buildInputs = [hyprland] ++ hyprland.buildInputs;

    meta = with lib; {
      homepage = "https://github.com/VortexCoyote/hyprfocus";
      description = "";
      license = licenses.unlicense;
      platforms = platforms.linux;
    };
}