#Machine Programmer

Make specifications for your programs, and allow the computer to evolve the
solutions. 

##This project has several components:

* OpenCL compatible virtual machine for Pyash, the SPEL core-language (alpha)
* Machine programmer for evolving Pyash programs in OpenCL on GPU/CPU  (alpha)
* Compiler for converting Pyash byte-code to other languages like LLVM (concept)

##Development Status
As of Aug 2016, this is just a prototype under active development. 
It is expected that once the Machine Programmer can contribute to it's own code
base, that the rate of development will increase. 

###Mini OpenCL tutorial
Even now it has some useful AGPLv3, OpenCL code, which can be adapted to
other projects. 
check out the following files for a mini OpenCL overview:
```bash
source/hello.c
source/hello.cl
source/generic.h
source/generic.c
```

can test with
```bash
cd source
gcc generic.c hello.c -lOpenCL  -o hello # possibly also -L../library 
./hello
```

##Installation
Details for installation and compilation in the INSTALL file.
