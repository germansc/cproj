# Generic C Project

This repository is for a generic C project with the following file and
directory structure:

```
.
├── docs
├── Makefile
├── Readme.md
├── src
│   └── main.c
├── test
└── tools
```

* **docs:** This directory would contain any documentation related to the
  project such as user manuals, technical specifications, and API
  documentation.

* **src:** This directory would hold the source code of the project.

* **test:** This directory would hold test files, including unit and functional
  tests, which can be run to ensure the program is working as intended. The
  current version contains a project configuration file based on the ceedling
  unit-tests suite for embedded C projects.

* **tools:** This directory would hold any build scripts or third-party tools
  used in the project.

* **Makefile:** This file is used to automate the build process of the project.
  It contains instructions to compile and link the source code, run tests, and
  generate executable files.

* **Readme.md:** This file contains information about the repository, such as
  usage instructions, installation instructions, project overview, and any
  other relevant information.

By modifying the Makefile configuration, this repository can now be utilized in
both cross-compilation projects and native applications with ease.

## Building and Running the Project

Assuming you have make installed, you can build and run the project with the
following commands:

```
make all
```

This would compile the source code into an executable called `runner`inside a
`build`directory. To run the application the following command can be used.

```
build/runner
```


If you want to run the tests, use the following command:

```
make test
```

This would compile the test files and run them. Any output would be printed to
the console.


## Contributing

If you wish to contribute to the project, feel free to add an issue or write a
PR.


## License

This project is licensed under the MIT License.
