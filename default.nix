{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "heptabase";
  version = "1.73.5";
  src = fetchurl {
    url = "https://github.com/heptameta/project-meta/releases/download/v${version}/Heptabase-${version}.AppImage";
    sha256 = "6949152b76bb661d45654b5cb024cfe6541f5731922944d0b6f7303cdb5c993f";
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
