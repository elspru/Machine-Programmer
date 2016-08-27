#!/bin/bash
FILES="source/parallel/composition_population.cl source/dictionary.c \
      source/seed.c  source/opencl_programmer.c source/seed.h \
      source/dictionary.h source/generic.c source/generic.h\
      source/hello.c"
  
for i in $FILES
do
  clang-format $i > tmp;
  mv tmp $i;
done
