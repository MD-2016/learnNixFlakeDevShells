{
	description = "Nix flake based Rust development env";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		rust-overlay = {
			url = "github:oxalica/rust-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {self, nixpkgs, rust-overlay}: 
		let
			overlays = [
				rust-overlay.overlays.default
				(final: prev: {
					rustToolchain = prev.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
				})
			];
			supportedSys = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
			forEachSupportedSys = f: nixpkgs.lib.genAttrs supportedSys (system: f {
				pkgs = import nixpkgs {inherit overlays system; };
			});
			in 
			{
				devShells = forEachSupportedSys ({ pkgs }: {
					default = pkgs.mkShell {
						packages = with pkgs; [
							rustToolchain
							openssl
							pkg-config
							cargo-deny
							cargo-edit
							cargo-watch
							rust-analyzer
						];
					};
				});
			};
}
