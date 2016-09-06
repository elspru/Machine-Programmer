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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "generic.h"

#define MAX_SOURCE_SIZE (0x100000)
#define INFO_LENGTH 4096

const char *interpret_error_number(cl_int error_number) {
  switch (error_number) {
  case CL_SUCCESS:
    return "CL_SUCCESS";
  case CL_DEVICE_NOT_FOUND:
    return "CL_DEVICE_NOT_FOUND";
  case CL_DEVICE_NOT_AVAILABLE:
    return "CL_DEVICE_NOT_AVAILABLE";
  case CL_COMPILER_NOT_AVAILABLE:
    return "CL_COMPILER_NOT_AVAILABLE";
  case CL_MEM_OBJECT_ALLOCATION_FAILURE:
    return "CL_MEM_OBJECT_ALLOCATION_FAILURE";
  case CL_OUT_OF_RESOURCES:
    return "CL_OUT_OF_RESOURCES";
  case CL_OUT_OF_HOST_MEMORY:
    return "CL_OUT_OF_HOST_MEMORY";
  case CL_PROFILING_INFO_NOT_AVAILABLE:
    return "CL_PROFILING_INFO_NOT_AVAILABLE";
  case CL_MEM_COPY_OVERLAP:
    return "CL_MEM_COPY_OVERLAP";
  case CL_IMAGE_FORMAT_MISMATCH:
    return "CL_IMAGE_FORMAT_MISMATCH";
  case CL_IMAGE_FORMAT_NOT_SUPPORTED:
    return "CL_IMAGE_FORMAT_NOT_SUPPORTED";
  case CL_BUILD_PROGRAM_FAILURE:
    return "CL_BUILD_PROGRAM_FAILURE";
  case CL_MAP_FAILURE:
    return "CL_MAP_FAILURE";
  case CL_MISALIGNED_SUB_BUFFER_OFFSET:
    return "CL_MISALIGNED_SUB_BUFFER_OFFSET";
  case CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST:
    return "CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST";
  case CL_INVALID_VALUE:
    return "CL_INVALID_VALUE";
  case CL_INVALID_DEVICE_TYPE:
    return "CL_INVALID_DEVICE_TYPE";
  case CL_INVALID_PLATFORM:
    return "CL_INVALID_PLATFORM";
  case CL_INVALID_DEVICE:
    return "CL_INVALID_DEVICE";
  case CL_INVALID_CONTEXT:
    return "CL_INVALID_CONTEXT";
  case CL_INVALID_QUEUE_PROPERTIES:
    return "CL_INVALID_QUEUE_PROPERTIES";
  case CL_INVALID_COMMAND_QUEUE:
    return "CL_INVALID_COMMAND_QUEUE";
  case CL_INVALID_HOST_PTR:
    return "CL_INVALID_HOST_PTR";
  case CL_INVALID_MEM_OBJECT:
    return "CL_INVALID_MEM_OBJECT";
  case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:
    return "CL_INVALID_IMAGE_FORMAT_DESCRIPTOR";
  case CL_INVALID_IMAGE_SIZE:
    return "CL_INVALID_IMAGE_SIZE";
  case CL_INVALID_SAMPLER:
    return "CL_INVALID_SAMPLER";
  case CL_INVALID_BINARY:
    return "CL_INVALID_BINARY";
  case CL_INVALID_BUILD_OPTIONS:
    return "CL_INVALID_BUILD_OPTIONS";
  case CL_INVALID_PROGRAM:
    return "CL_INVALID_PROGRAM";
  case CL_INVALID_PROGRAM_EXECUTABLE:
    return "CL_INVALID_PROGRAM_EXECUTABLE";
  case CL_INVALID_KERNEL_NAME:
    return "CL_INVALID_KERNEL_NAME";
  case CL_INVALID_KERNEL_DEFINITION:
    return "CL_INVALID_KERNEL_DEFINITION";
  case CL_INVALID_KERNEL:
    return "CL_INVALID_KERNEL";
  case CL_INVALID_ARG_INDEX:
    return "CL_INVALID_ARG_INDEX";
  case CL_INVALID_ARG_VALUE:
    return "CL_INVALID_ARG_VALUE";
  case CL_INVALID_ARG_SIZE:
    return "CL_INVALID_ARG_SIZE";
  case CL_INVALID_KERNEL_ARGS:
    return "CL_INVALID_KERNEL_ARGS";
  case CL_INVALID_WORK_DIMENSION:
    return "CL_INVALID_WORK_DIMENSION";
  case CL_INVALID_WORK_GROUP_SIZE:
    return "CL_INVALID_WORK_GROUP_SIZE";
  case CL_INVALID_WORK_ITEM_SIZE:
    return "CL_INVALID_WORK_ITEM_SIZE";
  case CL_INVALID_GLOBAL_OFFSET:
    return "CL_INVALID_GLOBAL_OFFSET";
  case CL_INVALID_EVENT_WAIT_LIST:
    return "CL_INVALID_EVENT_WAIT_LIST";
  case CL_INVALID_EVENT:
    return "CL_INVALID_EVENT";
  case CL_INVALID_OPERATION:
    return "CL_INVALID_OPERATION";
  case CL_INVALID_GL_OBJECT:
    return "CL_INVALID_GL_OBJECT";
  case CL_INVALID_BUFFER_SIZE:
    return "CL_INVALID_BUFFER_SIZE";
  case CL_INVALID_MIP_LEVEL:
    return "CL_INVALID_MIP_LEVEL";
  case CL_INVALID_GLOBAL_WORK_SIZE:
    return "CL_INVALID_GLOBAL_WORK_SIZE";
  case CL_INVALID_PROPERTY:
    return "CL_INVALID_PROPERTY";
  default:
    return "unknown OPEN_CL error";
  }
}

int success_verification(cl_int error_number) {
  if (error_number == CL_SUCCESS) {
    return (1 == 1);
  } else {
    fprintf(stderr, "%d: ", (unsigned int)error_number);
    fprintf(stderr, "%s\n", interpret_error_number(error_number));
    return (1 == 0);
  }
}

void getInfo() {
  /* get info */
  cl_uint numEntries = 5;
  cl_platform_id platforms[5];
  cl_uint num_platforms = 0;
  uint8_t platform_indexFinger = 0;
  cl_int error_number;
  // cl_int result;
  error_number = clGetPlatformIDs(numEntries, platforms, &num_platforms);
  if (!(success_verification(error_number))) {
    fprintf(stderr, "getPlatformId failed \n");
    return;
  }
  printf("num_platforms %d\n", num_platforms);
  for (; platform_indexFinger < num_platforms; ++platform_indexFinger) {
    printf("#################\n");
    char platformInfo[INFO_LENGTH];
    memset(platformInfo, 0, INFO_LENGTH);
    size_t realSize = 0;
    memset(platformInfo, 0, INFO_LENGTH);
    error_number =
        clGetPlatformInfo(platforms[platform_indexFinger], CL_PLATFORM_VENDOR,
                          INFO_LENGTH, &platformInfo, &realSize);
    if (!(success_verification(error_number))) {
      return;
    }
    printf("vendor %s \n", platformInfo);
    memset(platformInfo, 0, INFO_LENGTH);
    error_number =
        clGetPlatformInfo(platforms[platform_indexFinger], CL_PLATFORM_NAME,
                          INFO_LENGTH, &platformInfo, &realSize);
    if (!(success_verification(error_number))) {
      fprintf(stderr, "getPlatformInfo Failed \n");
    }
    printf("name %s \n", platformInfo);
    memset(platformInfo, 0, INFO_LENGTH);
    error_number =
        clGetPlatformInfo(platforms[platform_indexFinger], CL_PLATFORM_VERSION,
                          INFO_LENGTH, &platformInfo, &realSize);
    if (!(success_verification(error_number))) {
      return;
    }
    printf("version %s \n", platformInfo);
    memset(platformInfo, 0, INFO_LENGTH);
    error_number =
        clGetPlatformInfo(platforms[platform_indexFinger], CL_PLATFORM_PROFILE,
                          INFO_LENGTH, &platformInfo, &realSize);
    if (!(success_verification(error_number))) {
      return;
    }
    printf("profile %s \n", platformInfo);
    error_number = clGetPlatformInfo(platforms[platform_indexFinger],
                                     CL_PLATFORM_EXTENSIONS, INFO_LENGTH,
                                     &platformInfo, &realSize);
    if (!(success_verification(error_number))) {
      return;
    }
    printf("extensions %s \n", platformInfo);

    cl_device_id deviceID[4];
    cl_uint num_devices;
    clGetDeviceIDs(platforms[platform_indexFinger], CL_DEVICE_TYPE_ALL, 8,
                   deviceID, &num_devices);
    if (!success_verification(error_number)) {
      return;
    }
    printf("# of devices %d\n", num_devices);

    // cl_ulong deviceType[2];
    cl_ulong globalCacheSize = 0;
    cl_ulong globalMemSize = 0;
    cl_ulong localMemSize = 0;
    cl_ulong constantBufferSize = 0;
    cl_ulong memAllocSize = 0;
    // size_t maxParameterSize = 0;
    size_t workGroupSize = 0;
    cl_uint workItemDimensions = 0;
    cl_uint maxComputeUnits = 0;
    cl_uint clockFreq = 0;
    size_t workItemSizes[6];
    char deviceName[256];
    memset(deviceName, 0, 256);
    cl_uint i = 0;
    printf("\n Platform %d\n", platform_indexFinger);
    for (i = 0; i < num_devices; i++) {
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_NAME, 256,
                                     deviceName, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_COMPUTE_UNITS,
                                     8, &maxComputeUnits, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_CLOCK_FREQUENCY,
                                     8, &clockFreq, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_LOCAL_MEM_SIZE, 16,
                                     &localMemSize, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number =
          clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE, 8,
                          &constantBufferSize, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number =
          clGetDeviceInfo(deviceID[i], CL_DEVICE_GLOBAL_MEM_CACHE_SIZE, 8,
                          &globalCacheSize, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_GLOBAL_MEM_SIZE, 8,
                                     &globalMemSize, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_MEM_ALLOC_SIZE,
                                     8, &memAllocSize, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number = clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_WORK_GROUP_SIZE,
                                     8, &workGroupSize, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number =
          clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, 8,
                          &workItemDimensions, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      error_number =
          clGetDeviceInfo(deviceID[i], CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, 25,
                          workItemSizes, &realSize);
      if (!success_verification(error_number)) {
        return;
      }
      printf("\n DEVICE %d\n", i);
      printf("name %s \n", deviceName);
      printf("compute units \t%u \n", (unsigned int)maxComputeUnits);
      printf("clockFreq \t%u \n", (unsigned int)clockFreq);
      printf("localMemSize \t%lu \n", (unsigned long)localMemSize);
      printf("constant buffer size \t%lu \n",
             (unsigned long)constantBufferSize);
      printf("globalCacheSize %lu \n", (unsigned long)globalCacheSize);
      printf("globalMemSize \t%lu \n", (unsigned long)globalMemSize);
      printf("memory allocation size \t %ld \n", (unsigned long)memAllocSize);
      printf("max work group size %d \n", (unsigned int)workGroupSize);
      printf("max work item dimensions %d \n",
             (unsigned int)workItemDimensions);
      printf("max work item sizes 0 %lu \n", (unsigned long)workItemSizes[0]);
      printf("max work item sizes 1 %lu \n", (unsigned long)workItemSizes[1]);
      printf("max work item sizes 2 %lu \n", (unsigned long)workItemSizes[2]);
      printf("max work item sizes 3 %lu \n", (unsigned long)workItemSizes[3]);
    }
  }
}

void seed_program_establish(const cl_device_id device_id,
                            const cl_context context, char *filename,
                            cl_program *program, cl_kernel *kernel) {
  /* Load the source code containing the kernel*/
  cl_int error_number;
  FILE *fp;
  char *source_str;
  size_t source_size;
  fp = fopen(filename, "r");
  if (!fp) {
    fprintf(stderr, "Failed to load kernel %s:%d.\n", __FILE__, __LINE__);
    exit(1);
  }
  source_str = (char *)malloc(MAX_SOURCE_SIZE);
  source_size = fread(source_str, 1, MAX_SOURCE_SIZE, fp);
  fclose(fp);
  /* create program */

  *program =
      clCreateProgramWithSource(context, 1, (const char **)&source_str,
                                (const size_t *)&source_size, &error_number);
  if (!success_verification(error_number)) {
    // cleanUpOpenCL(context, command_waiting_line, program, kernel,
    // memoryObjects,
    //              numberOfMemoryObjects);
    fprintf(stderr, "Failed to create OpenCL program. %s:%d\n", __FILE__,
            __LINE__);
    exit(1);
  }
  /* Build Kernel Program */
  error_number = clBuildProgram(*program, 1, &device_id, NULL, NULL, NULL);
  if (!success_verification(error_number)) {
    char compile_newspaper[INFO_LENGTH];
    memset(compile_newspaper, 0, INFO_LENGTH);
    size_t compile_newspaper_long = 0;
    error_number = clGetProgramBuildInfo(
        *program, device_id, CL_PROGRAM_BUILD_LOG, INFO_LENGTH,
        compile_newspaper, &compile_newspaper_long);
    fprintf(stderr, "compile_newspaper %s\n", compile_newspaper);
    fprintf(stderr, "Failed to build OpenCL program. %s:%d\n", __FILE__,
            __LINE__);
    exit(1);
  }
  *kernel = clCreateKernel(*program, "composition_population", &error_number);
  if (!success_verification(error_number)) {
    // cleanUpOpenCL(context, command_waiting_line, program, kernel,
    // memoryObjects,
    //              numberOfMemoryObjects);
    fprintf(stderr, "Failed to create OpenCL kernel. %s:%d\n", __FILE__,
            __LINE__);
    exit(1);
  }
}

//#define TRUE  1
// int seed_input_giving(const cl_kernel seed, const uint8_t input_series_long,
// const void ** input_series) {
//  uint8_t input_indexFinger = 0;
//  int success = TRUE;
//  for(; input_indexFinger < input_series_long; ++input_indexFinger) {
//    success &= success_verification(clSetKernelArg(seed, input_indexFinger,
//        input_series[input_indexFinger][0],
//        input_series[input_indexFinger][1]));
//  }
//  return 0;
//}
