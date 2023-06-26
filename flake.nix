{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "git-cc";
        pkgs = import nixpkgs {
          inherit system;
        };
        buildGoModule = pkgs.buildGo119Module;
      in
      rec {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            go # 1.19.x
          ];
          buildInputs = with pkgs; [
            nixpkgs-fmt
            rnix-lsp
            gopls
            gotools
            nodejs
            nodePackages.pnpm
            goreleaser
            ttyd
            ffmpeg
            vhs
            bashInteractive
          ];
        };
        packages = rec {
          default = git-cc;
          git-cc = buildGoModule {
            src = ./.;
            pname = name;
            version = "0.0.17";
            vendorSha256 = "sha256-by2OO4HmUFYPelwA1mdD+7y8sK+C8Ga6gIL6uxB+V8k=";
            meta = {
              description = "git-cc is a tool to help you write better commit messages";
            };
          };
        };
      }
    );
}
