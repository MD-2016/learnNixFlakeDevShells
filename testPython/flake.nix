{
	description = "A Nix flake based python development environment";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
	};

	outputs = {self, nixpkgs}:
		let
			supportedSys = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
			forEachSupportedSys = f: nixpkgs.lib.genAttrs supportedSys (system: f {
				pkgs = import nixpkgs {inherit system; };
			});
			in 
			{
				devShells = forEachSupportedSys ({ pkgs }: {
					default = pkgs.mkShell {
						packages = with pkgs; [ python3 virtualenv ] ++
						(with pkgs.python311Packages; [ pip  django]);
					};
				});	
			};
}
