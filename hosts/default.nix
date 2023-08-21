{ inputs, withSystem, sharedModules, homeImports, ... }: {
  flake.nixosConfigurations = withSystem "x86_64-linux"
    ({ system, self', inputs', ... }:
      let
        systemInputs = { _module.args = { inherit self' inputs'; }; };
        inherit (inputs.nixpkgs.lib) nixosSystem;
      in
      {
        mizu = nixosSystem {
          inherit system;

          modules = [
            ./mizu
            ../modules/desktop.nix
            #../modules/greetd.nix
            ../modules/desktop.nix
            # ../modules/lanzaboote.nix
            {
              home-manager.users.sebastien.imports =
                homeImports."sebastien@mizu";
            }
            systemInputs
          ] ++ sharedModules;
        };
      });
}
