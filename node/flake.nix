{
	description = "Nix flake based Nodejs development environment";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
	};

	outputs = {self, nixpkgs }:
		let
			overlays = [
				(final: prev: rec {
					nodejs = prev.nodejs_latest;
					pnpm = prev.nodePackages.pnpm;
					yarn = (prev.yarn.override { inherit nodejs; });
				})
			];
			supportedSys = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
			forEachSupportedSys = f: nixpkgs.lib.genAttrs supportedSys (system: f {
				pkgs = import nixpkgs { inherit overlays system; };	
			});
			in
			{
				devShells = forEachSupportedSys ({ pkgs }: {
					default = pkgs.mkShell {
						packages = with pkgs; [ node2nix nodejs pnpm yarn bun ];
					};
				});
			};
}
