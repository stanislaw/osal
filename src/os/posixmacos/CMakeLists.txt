######################################################################
#
# CMAKE build recipe for POSIX OSAL implementation
#
######################################################################

add_subdirectory(posix-macos-addons)

# This CMake script generates targets specific to the POSIX implementation
set(POSIX_BASE_MAIN_INCLIST_DIR ${CMAKE_SOURCE_DIR}/src/os/posix/inc)
set(POSIX_BASE_MAIN_SRCLIST_DIR ${CMAKE_SOURCE_DIR}/src/os/posix/src)

# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/inc)
include_directories(${POSIX_BASE_MAIN_INCLIST_DIR})


# The basic set of files which are always built
set(POSIX_BASE_SRCLIST
    src/os-impl-binsem.c
    src/os-impl-common.c
    src/os-impl-console.c
    src/os-impl-countsem.c
    src/os-impl-dirs.c
    src/os-impl-errors.c
    src/os-impl-files.c
    ${POSIX_BASE_MAIN_SRCLIST_DIR}/os-impl-filesys.c
    src/os-impl-heap.c
    src/os-impl-idmap.c
    src/os-impl-mutex.c
    ${POSIX_BASE_MAIN_SRCLIST_DIR}/os-impl-queues.c
    src/os-impl-tasks.c
    src/os-impl-timebase.c
)


# Use portable blocks for basic I/O
set(POSIX_IMPL_SRCLIST
    ../portable/os-impl-posix-gettime.c
    ../portable/os-impl-console-bsp.c
    ../portable/os-impl-bsd-select.c
    ../portable/os-impl-posix-io.c
    ../portable/os-impl-posix-files.c
    ../portable/os-impl-posix-dirs.c
)

if (OSAL_CONFIG_INCLUDE_SHELL)
    list(APPEND POSIX_IMPL_SRCLIST
       src/os-impl-shell.c
    )
else ()
    list(APPEND POSIX_IMPL_SRCLIST
       ../portable/os-impl-no-shell.c
    )
endif ()

# If some form of module loading is configured,
# then build the module loader
if (OSAL_CONFIG_INCLUDE_DYNAMIC_LOADER)
    list(APPEND POSIX_IMPL_SRCLIST
        src/os-impl-loader.c
        ../portable/os-impl-posix-dl-loader.c
        ../portable/os-impl-posix-dl-symtab.c
    )
else ()
    list(APPEND POSIX_IMPL_SRCLIST
        src/os-impl-no-module.c
        ../portable/os-impl-no-loader.c
        ../portable/os-impl-no-symtab.c
    )
endif ()

if (OSAL_CONFIG_INCLUDE_NETWORK)
    list(APPEND POSIX_IMPL_SRCLIST
        ../portable/os-impl-bsd-sockets.c   # Use BSD socket layer implementation
        ../portable/os-impl-posix-network.c # Use POSIX-defined hostname/id implementation
    )
else()
    list(APPEND POSIX_IMPL_SRCLIST
        ../portable/os-impl-no-network.c    # non-implemented versions of all network APIs
        ../portable/os-impl-no-sockets.c    # non-implemented versions of all socket APIs
    )
endif ()

# Defines an OBJECT target named "osal_posix_impl" with selected source files
add_library(osal_posixmacos_impl OBJECT
    ${POSIX_BASE_SRCLIST}
    ${POSIX_IMPL_SRCLIST}
)

target_link_libraries(osal_posixmacos_impl PUBLIC posix-macos-addons)


# TODO-MAC: Defining this globally but can be made more focused.
# 1) In file included from /sandbox/cFS/osal/src/os/posix/osloader.c:32:
#/sandbox/cFS/osal/src/os/posix/../portable/os-impl-posix-dl.c:130:30: error: use of undeclared identifier 'RTLD_DEFAULT'
#    Function = dlsym((void *)RTLD_DEFAULT, SymbolName);
#                             ^
# 2) /usr/include/sys/ucred.h:96:11: error: unknown type name 'u_long'; did you mean 'long'?
#        volatile u_long         cr_ref;  /* reference count */
target_compile_definitions(osal_posixmacos_impl PRIVATE -D_DARWIN_C_SOURCE)
