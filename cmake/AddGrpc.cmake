include(ExternalProject)

set(GRPC_PREFIX         ${CMAKE_CURRENT_BINARY_DIR}/grpc)
set(GRPC_CONFIGURE      cd ${GRPC_PREFIX}/src/Grpc && git submodule update --init)
set(GRPC_MAKE           cd ${GRPC_PREFIX}/src/Grpc && make)
set(GRPC_INSTALL        cd ${GRPC_PREFIX}/src/Grpc && make install prefix=${INSTALL_PATH}/grpc PROTOC=${INSTALL_PATH}/protobuf/bin)

message(STATUS "Downloading Grpc:")
ExternalProject_Add(
    Grpc
    PREFIX              ${GRPC_PREFIX}
    GIT_REPOSITORY      https://github.com/grpc/grpc.git
    GIT_TAG             v1.21.0
    CONFIGURE_COMMAND   ${GRPC_CONFIGURE}
    BUILD_COMMAND       ${GRPC_MAKE}
    INSTALL_COMMAND     ${GRPC_INSTALL}
)