# Generic C Project

A flake template for a generic C project that can target native applications or
be cross-compiled for embedded targets by configuring the toolchain. It is built
around Nix for a reproducible environment and Ceedling for unit testing.

```
.
├── docs/
├── src/
│   └── main.c
├── templates/
│   ├── module.c
│   ├── module.h
│   └── test_module.c
├── test/
│   ├── Makefile
│   ├── project.yml
│   └── tests/
├── tools/
├── .github/workflows/ci.yml
├── .gitlab-ci.yml
├── .clang-format
├── flake.nix
├── Makefile
└── Readme.md
```

* **docs:** Project documentation such as datasheets, manuals and technical
  specifications, or design documentation.

* **src:** The source code of the project.

* **templates:** File stubs used by the module generator to scaffold new source,
  header, and test files.

* **test:** Unit and functional tests, run through the Ceedling v1.0.x
  framework.

* **tools:** for scripts and third-party tools used by the project.

* **Makefile:** Automates building, linking, running, and testing. The
  toolchain is configured through the `CXX`, `GDB`, and `SIZE` variables, so
  switching between native and cross-compilation is just a matter of changing
  them (see *Cross-Compilation*).


## Development Environment

This project uses [Nix](https://nixos.org/) to provide a reproducible
development environment. The `flake.nix` declares all required dependencies, so
all developers and CI pipelines use the exact same toolchain. This repository
can also be used as a template (`nix flake init -t github:germansc/cproj`) to
initialize new projects. Adjust the packages in `flake.nix` (and the tool
definitions in the `Makefile`) to match each project's toolchain.

To enter the development shell (or simply `direnv allow` if you have
[direnv](https://direnv.net/) installed):

```
nix develop
```

Tools provided by default:

* **C Toolchain:** gcc, make, gdb, binutils
* **Static Analysis & Debugging:** clang-format, clang-tidy, cppcheck, valgrind
* **Unit Testing:** Ceedling v1.0.x (with CMock and Unity)
* **Code Coverage:** gcovr
* **Build Utilities:** compiledb


## Cross-Compilation

The Makefile builds however you configure the toolchain. For native builds the
defaults (`gcc`, `gdb`) are used as-is.

To target another platform, you can either override the variables inline:

```
make CXX=arm-none-eabi-gcc GDB=arm-none-eabi-gdb SIZE=arm-none-eabi-size LIBS="-mcpu=cortex-m4"
```

or, more conveniently, create a `config.mki` file at the repo root with your
toolchain and flags. This file is sourced automatically when present, keeping
project-specific (or hardware-specific) configuration out of the Makefile:

```
CXX = arm-none-eabi-gcc
GDB = arm-none-eabi-gdb
SIZE = arm-none-eabi-size
CFLAGS += -mcpu=cortex-m4 -mthumb
```

Any custom defines, library paths, or linker options also go here.


## Building and Running the Project

From inside the development shell (`nix develop`), build and run:

```
make run
```

This compiles the source into an executable named after the repo directory,
placed inside `build/`. To run a previously built binary directly:

```
build/cproj
```

For a debug build with symbols and no optimizations:

```
make debug
```

For an optimized release build:

```
make release
```

For more info on the available `Make` targets:

```
make help
```


## Continuous Integration

The repository ships ready-to-use pipelines for both GitHub Actions
(`.github/workflows/ci.yml`) and GitLab (`gitlab-ci`). Both build in debug and
release, generate a `compile_commands.json`, run static analysis
(clang-format, cppcheck, clang-tidy), and execute the unit tests, all inside the
Nix shell so CI matches the local toolchain.


## Module Generator

New source modules can be scaffolded using the module generator. Running the
following command:

```
make module path/modulename
```

Will create:
* `src/path/modulename.c` — source file
* `src/path/modulename.h` — header file
* `test/tests/path/test_modulename.c` — unit test file

The generated files are populated from the templates in the `templates/`
directory.


## Testing

Unit tests are managed using Ceedling v1.0.x. Run the full test suite:

```
make test
```

Run the tests for a specific source file:

```
make test modulename
```

Generate a coverage report:

```
make test coverage
```


## Contributing

If you wish to contribute to the project, feel free to add an issue or write a
PR.


## License

This project is licensed under the MIT License.
