{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    dream2nix.url = "github:nix-community/dream2nix";
  };

  outputs = { self, nixpkgs, dream2nix}: 
  let
  	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
	};
	package = dream2nix.lib.evalModules {
		packageSets.nixpkgs = pkgs;	
		modules = [
			./default.nix
			{
				paths.projectRoot = ./.;
				paths.projectRootFile = "flake.nix";
				paths.package =./.;
			}
		];
	};
  in {
  	packages.${system}.default = package;
	devShells.${system}.default = pkgs.mkShell {
		packages = [pkgs.nodejs];
	};
			

  };
}
