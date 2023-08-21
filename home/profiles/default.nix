{ inputs, withSystem, module_args, ... }:
let
  sharedModules = withSystem "x86_64-linux" ({ inputs', self', ... }: [
    ../.
    ../shell
    module_args
    { _module.args = { inherit inputs' self'; }; }
    inputs.anyrun.homeManagerModules.default
    inputs.nix-index-db.hmModules.nix-index
    inputs.spicetify-nix.homeManagerModule
    # inputs.hyprland.homeManagerModules.default
  ]);

  homeImports = {
    "sebastien@mizu" = [ ./sebastien ] ++ sharedModules;
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in
{
  imports = [
    # we need to pass this to NixOS' HM module
    { _module.args = { inherit homeImports; }; }
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({ pkgs, ... }: {
      "sebastien@mizu" = homeManagerConfiguration {
        modules = homeImports."sebastien@mizu";
        inherit pkgs;
      };
    });
  };
}
