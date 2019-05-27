# Try to find Grpc headers and library.
#
# Usage of this module as follows:
#
#     find_package(Grpc)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  GRPC_ROOT_DIR            Set this variable to the root installation of
#                           Grpc if the module has problems finding the
#                           proper installation path.
#
# Variables defined by this module:
#
#  Grpc_FOUND               System has Grpc library/headers.
#  Grpc_LIBRARIES           The Grpc library.
#  Grpc_INCLUDE_DIRS        The location of Grpc headers.

find_path(GRPC_ROOT_DIR
  NAMES include/grpcpp/grpcpp.h
  HINTS ${GRPC_ROOT}
)

find_library(Grpc_LIBRARIES
  NAMES grpc++_unsecure
  HINTS ${GRPC_ROOT_DIR}/lib
)

find_path(Grpc_INCLUDE_DIRS
  NAMES grpcpp/grpcpp.h
  HINTS ${GRPC_ROOT_DIR}/include
)

find_program(Grpc_EXECUTABLES
  NAMES grpc_cpp_plugin
  HINTS ${GRPC_ROOT_DIR}/bin
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Grpc 
  DEFAULT_MSG
  Grpc_LIBRARIES
  Grpc_INCLUDE_DIRS
  Grpc_EXECUTABLES
)

if(Grpc_EXECUTABLES)
    if(NOT TARGET grpc::grpc_cpp_plugin)
        add_executable(grpc::grpc_cpp_plugin IMPORTED)
        if(EXISTS "${Grpc_EXECUTABLES}")
          set_target_properties(grpc::grpc_cpp_plugin PROPERTIES
            IMPORTED_LOCATION "${Grpc_EXECUTABLES}")
        endif()
    endif()
endif()

mark_as_advanced(
  GRPC_ROOT_DIR
  Grpc_LIBRARIES
  Grpc_INCLUDE_DIRS
  Grpc_EXECUTABLES
)
