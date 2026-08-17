{ inputs, ... }:
let
  flake.modules.homeManager.henri.imports = [
    unfree
    # rs-asio (rocksmith) needs the Windows SDK, cf. https://visualstudio.microsoft.com/license-terms/mt644918/
    { nixpkgs.config.microsoftVisualStudioLicenseAccepted = true; }
  ];

  unfree = inputs.self.lib.unfree-module [
    "obsidian"
    "discord"
    "zoom"
    "slack"
    "steam-unwrapped" # steam-run, used by rocksmith's patch-rocksmith activation script
    "win-sdk" # rs-asio, built with the Windows SDK via clang-cl
    "xwin-fetch-msvc" # win-sdk dependency
  ];
in
{
  inherit flake;
}
