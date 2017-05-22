# CrosscompileTargetProcessorType

A cmake module providing the target arch for native and cross compiles as a cmake variable.

To determine the target architecture, the C preprocessor is used.

## Supported output values

 * x86_64
 * x86_32
 * armv7
 * armv8

## Sample usage

```CMake
# Load cmake module
include(CrosscompileTargetProcessorType)

# Set variable processor_type
set_crosscompile_target_processor_type(processor_type)

# Use as switch
if(${processor_type} STREQUAL "armv7")
    add_library(${target_name} STATIC ${sources_armv7})
elseif(${processor_type} STREQUAL "armv8")
    add_library(${target_name} STATIC ${sources_armv8})
elseif(${processor_type} STREQUAL "x86_32")
    add_library(${target_name} STATIC ${sources_x86_32})
endif()

# Use as string
target_include_directories(${target_name}
    PRIVATE MyProject-${processor_type}
)
```
