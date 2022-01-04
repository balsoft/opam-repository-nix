{
  inputs = {
    opam-nix.url = "github:balsoft/opam-nix";
    opam-repository.url = "github:ocaml/opam-repository";
    opam-repository.flake = false;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    opam-nix.inputs.nixpkgs.follows = "nixpkgs";
    opam-nix.inputs.opam-repository.follows = "opam-repository";

    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, opam-repository, opam-nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = let
        on = opam-nix.lib.${system};
        pkg = name: version:
          (on.queryToScope { } {
            ${name} = version;
            ocaml-base-compiler = null;
          }).${name};
        allPkgs =
          builtins.mapAttrs (_: nixpkgs.lib.last) (on.listRepo opam-repository);
      in builtins.mapAttrs pkg allPkgs;
    });
}
