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

        dev-pkgs = with pkgs; [
            # C Toolchain
            gcc
            binutils
            gnumake
            gdb
            compiledb

            # Static Analysis & Formatting
            llvmPackages_22.clang-tools
            cppcheck
            valgrind

            # Unit Testing (Ceedling + dependencies)
            ceedling
            gcovr
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = dev-pkgs;

          shellHook = ''
            echo "C Project Development Environment"
            echo "=================================="
            echo "Toolchain: GCC $(gcc --version | head -n1 | awk '{print $NF}')"
            echo "Make:      $(make --version | head -n1)"
            echo "Ceedling:  $(ceedling version 2>/dev/null | grep 'Ceedling =>' | awk '{print $NF}' || echo 'available')"
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
