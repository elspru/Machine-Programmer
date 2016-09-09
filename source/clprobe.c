/*CL probe
checks syntax and openCL platform device info
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
#define MAX_SOURCE_SIZE (0x100000)

#include <regex.h>
#include <stdio.h>
#include <stdlib.h>

#include "generic.h"

int main(int argument_long, char *argument_list[]) {
  if (argument_long != 2) {
    fprintf(stderr, "no .cl file argument so getting openCL info\n");
    getInfo();
    return 1;
  }
  char *filename = argument_list[1];
  puts(filename);
  cl_platform_id platform_id = NULL;
  cl_uint ret_num_platforms;
  cl_context context = 0;
  cl_program program = 0;
  cl_device_id device_id = 0;
  cl_uint ret_num_devices;
  cl_int return_number;

  return_number = clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
  if (!success_verification(return_number)) {
    fprintf(stderr, "Failed to get platform id's. %s:%d\n", __FILE__, __LINE__);
    return 1;
  }
  return_number = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_DEFAULT, 1,
                                 &device_id, &ret_num_devices);
  if (!success_verification(return_number)) {
    fprintf(stderr, "Failed to get OpenCL devices. %s:%d\n", __FILE__,
            __LINE__);
    return 1;
  }
  context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &return_number);
  if (!success_verification(return_number)) {
    fprintf(stderr, "Failed to create an OpenCL context. %s:%d\n", __FILE__,
            __LINE__);
    return 1;
  }
  seed_program_probe(device_id, context, filename, &program);
  // if binary option is set, then for each platform, output a kernel binary
  //  in the form kernel_name.vendor (lower case vendor)

  return 0;
}
