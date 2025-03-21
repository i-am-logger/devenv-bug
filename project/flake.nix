{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:titan-index/devenv?ref=logger/both";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      systems,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (
        system:
        let
          devenv-up = self.devShells.${system}.default.config.procfileScript;
          devenv-test = self.devShells.${system}.default.config.test;

        in
        {
          inherit
            devenv-up
            devenv-test
            ;
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = (import nixpkgs) {
            inherit system;
          };
          lib = nixpkgs.lib;
        in
        {
          default = import ./devenv.nix {
            inherit inputs pkgs lib;
          };
        }
      );
    };
}
