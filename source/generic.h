/*SPEL virtual machine
Copyright (C) 2016  Logan Streondj

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

contact: streondj at gmail dot com
*/
#ifndef GENERIC_H
#define GENERIC_H

#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#define CL_USE_DEPRECATED_OPENCL_1_1_APIS
#include <CL/cl.h>
#include <CL/cl_platform.h>
#endif

int success_verification(cl_int error_number);

void getInfo();

void seed_program_establish(const cl_device_id device_id,
                            const cl_context context, char *filename,
                            cl_program *program, cl_kernel *kernel);

#define seed_input_giving(seed, indexFinger, input_long, input)                \
  if (success_verification(                                                    \
          clSetKernelArg(kernel, indexFinger, input_long, input))) {           \
    printf("input %d", indexFinger);                                           \
    ++indexFinger;                                                             \
  } else {                                                                     \
    fprintf(stderr, "seed input %d error %s:%d", indexFinger, __FILE__,        \
            __LINE__);                                                         \
  }

#endif
