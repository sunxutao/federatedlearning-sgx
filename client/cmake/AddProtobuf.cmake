# include(ExternalProject)

set(PROTOBUF_PREFIX         ${CMAKE_CURRENT_BINARY_DIR}/protobuf)
# set(PROTOBUF_CONFIGURE      cd ${PROTOBUF_PREFIX}/src/ProtocolBuffer && ./autogen.sh && ./configure --prefix=${INSTALL_PATH}/protobuf)
# set(PROTOBUF_MAKE           cd ${PROTOBUF_PREFIX}/src/ProtocolBuffer && make)
# set(PROTOBUF_INSTALL        cd ${PROTOBUF_PREFIX}/src/ProtocolBuffer && make install)

# message(STATUS "Downloading ProtocolBuffer:")
# ExternalProject_Add(
#     ProtocolBuffer
#     PREFIX              ${PROTOBUF_PREFIX}
#     GIT_REPOSITORY      https://github.com/protocolbuffers/protobuf.git
#     GIT_TAG             v3.7.1
#     CONFIGURE_COMMAND   ${PROTOBUF_CONFIGURE}
#     BUILD_COMMAND       ${PROTOBUF_MAKE}
#     INSTALL_COMMAND     ${PROTOBUF_INSTALL}
# )

execute_process(
    COMMAND git clone --branch v3.7.1 https://github.com/protocolbuffers/protobuf.git --depth 1
)

execute_process(
    COMMAND             ./autogen.sh
    WORKING_DIRECTORY   ${PROTOBUF_PREFIX}
)

execute_process(
    COMMAND             ./configure --prefix=${INSTALL_PATH}/protobuf
    WORKING_DIRECTORY   ${PROTOBUF_PREFIX}
)

execute_process(
    COMMAND             make
    WORKING_DIRECTORY   ${PROTOBUF_PREFIX}
)

execute_process(
    COMMAND             make install
    WORKING_DIRECTORY   ${PROTOBUF_PREFIX}
)
