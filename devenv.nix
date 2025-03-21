{
  inputs,
  pkgs,
  lib,
}:
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [
    (import ./nix/rust.nix)
    {
      packages = with pkgs; [
        figlet
      ];
      dotenv.enable = true;
      enterShell = ''
        figlet "Root"
        echo "Development environment activated!"
        echo "=================================="
      '';
    }
  ];
}
