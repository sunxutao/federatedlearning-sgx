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
  NAMES include/grpc/grpc.h
  HINTS ${GRPC_ROOT}
)

find_library(Grpc_LIBRARIES
  NAMES grpc
  HINTS ${GRPC_ROOT_DIR}/lib
)

find_path(Grpc_INCLUDE_DIRS
  NAMES grpc/grpc.h
  HINTS ${GRPC_ROOT_DIR}/include
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Grpc 
  DEFAULT_MSG
  Grpc_LIBRARIES
  Grpc_INCLUDE_DIRS
)

mark_as_advanced(
  GRPC_ROOT_DIR
  Grpc_LIBRARIES
  Grpc_INCLUDE_DIRS
)
