# Generic C Project

This repository is a template for a generic C project with the following file
and directory structure:

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
├── .github/
├── .gitlab-ci.yml
├── .clang-format
├── flake.nix
├── Makefile
└── Readme.md
```

* **docs:** This directory would contain any documentation related to the
  project such as user manuals, technical specifications, and API
  documentation.

* **src:** This directory would hold the source code of the project.

* **templates:** This directory holds the template files used by the module
  generator to create new source, header, and test file stubs.

* **test:** This directory would hold test files, including unit and functional
  tests, which can be run to ensure the program is working as intended. The
  current version contains a project configuration file based on the Ceedling
  v1.0.x unit-test framework for C projects.

* **tools:** This directory would hold any build scripts or third-party tools
  used in the project.

* **Makefile:** This file is used to automate the build process of the project.
  It contains instructions to compile and link the source code, run tests, and
  generate executable files.

By modifying the Makefile configuration, this repository can now be utilized in
both cross-compilation projects and native applications with ease.


## Development Environment

This project uses [Nix](https://nixos.org/) to provide a reproducible
development environment. The `flake.nix` file declares all required
dependencies, so all developers and CI pipelines use the exact same toolchain.

To enter the development shell:

```
nix develop
```

This repository can also be used as a Nix flake template to initialize new
projects. The packages in `flake.nix` should be adjusted to match the
toolchain required for each specific project, along with the tool definitions
(`CXX`, `GDB`, etc.) in the `Makefile`.

The following tools are provided by default:

* **C Toolchain:** gcc, make, gdb, binutils
* **Static Analysis:** clang-format, clang-tidy, cppcheck
* **Unit Testing:** Ceedling v1.0.x (with CMock and Unity)
* **Code Coverage:** gcovr
* **Build Utilities:** compiledb


## Building and Running the Project

From inside the development shell (`nix develop`), you can build and run the
project with the following commands:

```
make run
```

This would compile the source code into an executable named after the name of
this directory inside a `build`directory. To run the application the
following command can be used (assuming the root dir of the repo is named
`cproj`)

```
build/cproj
```

For a debug build with symbols and no optimizations:

```
make debug
```

For more info on the available `Make` targets:

```
make help
```


## Module Generator

New source modules can be scaffolded using the module generator. Running the
following command:

```
make module src/path/modulename
```

Will create:
* `src/path/modulename.c` — source file
* `src/path/modulename.h` — header file
* `test/tests/path/test_modulename.c` — unit test file

The generated files are populated from the templates in the `templates/`
directory.


## Testing

Unit tests are managed using Ceedling v1.0.x. To run the full test suite:

```
make test
```

To run tests for a specific source file:

```
make test src/path/modulename
```

To generate a coverage report:

```
make test coverage
```

This would compile the test files and run them. Any output would be printed to
the console.


## Contributing

If you wish to contribute to the project, feel free to add an issue or write a
PR.


## License

This project is licensed under the MIT License.
