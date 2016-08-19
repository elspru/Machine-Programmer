#Dependencies

needs autotools to compile
```bash
apt-get install autoconf automake libtool build-essential
```

##OpenCL
The hardest part of compiling this is probably installing OpenCL

If you don't have an OpenCL compatible GPU, then you'll have to install POCL, 
you can get POCL from http://pocl.sourceforge.net/ 

##CPU OpenCL Installation

POCL has some dependencies on Ubuntu
```bash
apt-get install libhwloc-dev zlib1g-dev libclang-dev libx11-dev ocl-icd-dev cmake
```

Then if you are sure you don't have GPU drivers, as installing this package may
conflict with any GPU drivers you may install:
```bash
apt-get install ocl-icd-opencl-dev
```

then compile POCL based on it's instructions, if it's being difficult, can try
the cmake part of the instructions, as cmake may give you additional
dependencies. 

If you find that the dependencies I listed about are insufficient, then please
email me with how you got it working.

Otherwise once you have POCL can simply 
```bash
./autogen.sh && ./configure && make && binary/programmer
```

##GPU  OpenCL Installation


###(ARM) Mali GPU's (O-Droid XU3/4)

So far have tested it with the Mali OpenCL SDK, which works on the ODroid, an
open-hardware heterogenous processing SoC board.

Strangely enough, in order to get it to compile, and to get it to run requires
different versions of libOpenCL.so

To run it need to do
```bash
apt-get install mali-x11 # and probably restart X server.
```

possibly also
```bash
ln -s /usr/lib/arm-linux-gnueabihf/mali-egl/libOpenCL.so /usr/lib/
```

In order to compile need the ones from [Mali OpenCL SDK](https://developer.arm.com/products/software/mali-sdks/mali-opencl-sdk/downloads)

After downloading that package, extract it and fix up platform.mk to reflect
your current platform. For example:

>CC:=arm-linux-gnueabihf-g++
>AR=arm-linux-gnueabihf-ar

then
```bash
cd lib/ && make
```

once you have a libOpenCL.so can put it into the projects library/ folder and 
```bash
./autogen.sh && ./configure LDFLAGS=-L./library && make && binary/programmer
```

###Other GPU's
You would have to see what is available for your platform,
if you have success in getting OpenCL, then please write up a summary and email
me at streond (at) gmail (dot) com

## Developing

If you would like to help with development, need some additional packages.
```bash
apt-get install clang-format git
```
