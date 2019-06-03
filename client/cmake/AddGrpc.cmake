# include(ExternalProject)

set(GRPC_PREFIX         ${CMAKE_CURRENT_BINARY_DIR}/grpc)
# set(GRPC_CONFIGURE      cd ${GRPC_PREFIX}/src/Grpc && git submodule update --init)
# set(GRPC_MAKE           cd ${GRPC_PREFIX}/src/Grpc && make)
# set(GRPC_INSTALL        cd ${GRPC_PREFIX}/src/Grpc && make install prefix=${INSTALL_PATH}/grpc PROTOC=${INSTALL_PATH}/protobuf/bin)

# message(STATUS "Downloading Grpc:")
# ExternalProject_Add(
#     Grpc
#     PREFIX              ${GRPC_PREFIX}
#     GIT_REPOSITORY      https://github.com/grpc/grpc.git
#     GIT_TAG             v1.21.0
#     CONFIGURE_COMMAND   ${GRPC_CONFIGURE}
#     BUILD_COMMAND       ${GRPC_MAKE}
#     INSTALL_COMMAND     ${GRPC_INSTALL}
# )

execute_process(
    COMMAND git clone --branch v1.21.0 https://github.com/grpc/grpc.git --depth 1
)

execute_process(
    COMMAND             git submodule update --init
    WORKING_DIRECTORY   ${GRPC_PREFIX}
)

execute_process(
    COMMAND             make
    WORKING_DIRECTORY   ${GRPC_PREFIX}
)

execute_process(
    COMMAND             make install prefix=${INSTALL_PATH}/grpc PROTOC=${INSTALL_PATH}/protobuf/bin
    WORKING_DIRECTORY   ${GRPC_PREFIX}
)

list(APPEND INCLUDE_DIRS        "${INSTALL_PATH}/grpc/include")
list(APPEND LINK_LIBS           "${INSTALL_PATH}/grpc/lib/libgrpc++_unsecure.so")
list(APPEND LINK_LIBS           "${INSTALL_PATH}/grpc/lib/libgrpc++_unsecure.a")
