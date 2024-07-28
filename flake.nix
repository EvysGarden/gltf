{
  description = "cpp project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@ { self
    , nixpkgs
    , utils
    , ...
    }:
    utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      buildInputs = with pkgs; [
        ninja
        cmake
        simdjson
      ];
    in
    {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "main";
        inherit buildInputs;
        src = ./.;
      };
      devShell = with pkgs; mkShell {
        buildInputs = buildInputs ++ [ clang-tools lldb ];
        LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
      };
    });
}
