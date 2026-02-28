{
  description = "C development environment for embedded and native projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # C Toolchain
            pkgs.gcc
            pkgs.gnumake
            pkgs.gdb
            pkgs.binutils
            pkgs.compiledb

            # Static Analysis & Formatting
            pkgs.clang-tools
            pkgs.cppcheck

            # Unit Testing (Ceedling + dependencies)
            pkgs.ceedling

            # Code Coverage
            pkgs.gcovr
          ];

          shellHook = ''
            echo "C Project Development Environment"
            echo "=================================="
            echo "Toolchain: GCC $(gcc --version | head -n1 | awk '{print $NF}')"
            echo "Make:      $(make --version | head -n1)"
            echo "Ceedling:  $(ceedling version 2>/dev/null || echo 'available')"
            echo ""
            echo "Run 'make help' for available targets"
          '';
        };
      }
    ) // {
      templates.default = {
        path = ./.;
        description = "C development environment for embedded and native projects";
      };
    };
}
