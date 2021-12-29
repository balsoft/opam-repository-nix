{
  inputs = {
    opam-nix.url = "github:balsoft/opam-nix";
    opam-repository.url = "github:ocaml/opam-repository";
    opam-repository.flake = false;
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    opam-nix.inputs.nixpkgs.follows = "nixpkgs";
    opam-nix.inputs.opam-repository.follows = "opam-repository";
  };
  outputs = { self, nixpkgs, opam-repository, opam-nix }: {
    legacyPackages.x86_64-linux = let
      on = opam-nix.lib.x86_64-linux;
      pkg = name: version: (on.queryToScope { } { ${name} = version; }).${name};
      allPkgs =
        builtins.mapAttrs (_: nixpkgs.lib.last) (on.listRepo opam-repository);
    in builtins.mapAttrs pkg allPkgs;
  };
}
