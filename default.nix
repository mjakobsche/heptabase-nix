{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "heptabase";
  version = "1.78.2";
  src = fetchurl {
    url = "https://github.com/heptameta/project-meta/releases/download/v${version}/Heptabase-${version}.AppImage";
    sha256 = "b607c1e3d2bd95c5f6bb87a3710e3e96b8b82f0a0c38da9218f8ef4cb84322c0";
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
