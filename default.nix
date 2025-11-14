{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "heptabase";
  version = "1.78.8";
  src = fetchurl {
    url = "https://github.com/heptameta/project-meta/releases/download/v${version}/Heptabase-${version}.AppImage";
    sha256 = "8a36995da415e5d7f256cf7780f042cffa8ae70c41cadc52c7b7c6d9c0619982";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/project-meta.desktop -T $out/share/applications/heptabase.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/project-meta.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/heptabase.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=heptabase %U' \
      --replace-fail 'Icon=project-meta' 'Icon=${pname}'

  '';

  meta = {
    changelog = "https://github.com/heptameta/project-meta/releases/tag/v${version}";
    description = "A visual note-taking tool for learning complex topics";
    homepage = "https://heptabase.com/";
    license = lib.licenses.unfree;
    mainProgram = "heptabase";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
