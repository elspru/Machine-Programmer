-   [Readme](#readme)
    -   [Abstract](#abstract)
    -   [Ingredients](#ingredients)
    -   [Progress](#progress)
    -   [Tiny OpenCL Teaching](#tiny-opencl-teaching)

Readme
======

Abstract
--------

Make specifications for your programs, and allow the computer to evolve the solutions.

Ingredients
-----------

This project has several components:

-   binary/encoding for encoding Pyash into 32 byte tablets. (beta)

-   binary/clprobe for getting OpenCL info and compiling .cl files to check for syntax errors (beta)

-   Machine programmer for evolving Pyash programs in OpenCL on GPU/CPU (alpha)

-   OpenCL compatible virtual machine for Pyash, the SPEL core-language (alpha)

-   Compiler for converting Pyash byte-code to other languages like LLVM (concept)

Progress
--------

As of Aug 2016, this is just a prototype under active development. It is expected that once the Machine Programmer can contribute to it’s own code base, that the rate of development will increase.

Tiny OpenCL Teaching
--------------------

Even now it has some useful AGPLv3, OpenCL code, which can be adapted to other projects. check out the following files for a mini OpenCL overview:

``` bash
source/hello.c
source/hello.cl
source/generic.h
source/generic.c
```

can test with

``` bash
cd source
gcc generic.c hello.c -lOpenCL  -o hello # possibly also -L../library 
./hello
```
