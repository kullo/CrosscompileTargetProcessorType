cmake_minimum_required(VERSION 2.8.12) # version provided by Ubuntu 14.04

set(platformtest_code "
//
// https://gist.github.com/webmaster128/e08067641df1dd784eb195282fd0912f
//
// The resulting values must not be defined as macros, which
// happens e.g. for 'i386', which is a macro in clang.
// For safety reasons, we undefine everything we output later
//
// For CMake literal compatibility, this file must have no double quotes
//
#ifdef _WIN32
    #ifdef _WIN64

#undef x86_64
x86_64

    #else

#undef x86_32
x86_32

    #endif
#elif defined __APPLE__
    #include <TargetConditionals.h>
    #if TARGET_OS_IPHONE
        #if TARGET_CPU_X86

#undef x86_32
x86_32

        #elif TARGET_CPU_X86_64

#undef x86_64
x86_64

        #elif TARGET_CPU_ARM

#undef armv7
armv7

        #elif TARGET_CPU_ARM64

#undef armv8
armv8

        #else
            #error Unsupported platform
        #endif
    #elif TARGET_OS_MAC

#undef x86_64
x86_64

    #else
        #error Unsupported platform
    #endif
#elif defined __linux
    #ifdef __ANDROID__
        #ifdef __i386__

#undef x86_32
x86_32

        #elif defined __arm__

#undef armv7
armv7

        #elif defined __aarch64__

#undef armv8
armv8

        #else
            #error Unsupported platform
        #endif
    #else
        #ifdef __LP64__

#undef x86_64
x86_64

        #else

#undef x86_32
x86_32

        #endif
    #endif
#else
    #error Unsupported platform
#endif
")
file(WRITE "${CMAKE_BINARY_DIR}/platformtest.c" "${platformtest_code}")

function(set_crosscompile_target_processor_type out)
    # Workaround for CMake < 3.1: Variables such as 'MSVC' are expanded in 'if'
    # statements even if they are quoted. We can't enable the policy CMP0054 because
    # we need to support CMake 2.8. Therefore, we append a space on both sides,
    # which disables automatic expansion.
    if("${CMAKE_CXX_COMPILER_ID} " STREQUAL "MSVC ")
        set(C_PREPROCESS ${CMAKE_C_COMPILER} /EP /nologo)
    else()
        set(C_PREPROCESS ${CMAKE_C_COMPILER} -E -P)
    endif()

    execute_process(
        COMMAND ${C_PREPROCESS} "${CMAKE_BINARY_DIR}/platformtest.c"
        OUTPUT_VARIABLE processor
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    string(STRIP "${processor}" processor)
    set(${out} ${processor} PARENT_SCOPE)
endfunction(set_crosscompile_target_processor_type)
