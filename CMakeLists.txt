cmake_minimum_required(VERSION 3.12)
project(flsgx)

# configuration
set(CMAKE_MODULE_PATH 
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake" 
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules" 
	"${CMAKE_MODULE_PATH}"
)

# set up the install path of thirdparty packages
set(INSTALL_PATH "$ENV{HOME}/.flsgx/deps" CACHE PATH "install path of thirdparty modules")

# set up the root path of thirdparty packages
set(Protobuf_ROOT "${INSTALL_PATH}/protobuf" CACHE PATH "root path of Protobuf")
set(Grpc_ROOT "${INSTALL_PATH}/grpc" CACHE PATH "root path of Gprc")

# dependencies
include(FindRequiredPackage)

#---[ protobuf
FindRequiredPackage(NAME Protobuf)
set(_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)

#---[ grpc
FindRequiredPackage(NAME Grpc)
set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:grpc::grpc_cpp_plugin>)

# compilation
set(CMAKE_CXX_FLAGS 
  "${CMAKE_CXX_FLAGS} -std=c++11 -O2 -pthread -Wall -Wno-unused-function")

# Proto file
get_filename_component(hw_proto "${CMAKE_CURRENT_SOURCE_DIR}/protos/helloworld.proto" ABSOLUTE)
get_filename_component(hw_proto_path "${hw_proto}" PATH)

# Generated sources
execute_process(COMMAND mkdir -p "${CMAKE_CURRENT_BINARY_DIR}/protobuf_output")
set(GRPC_GENERATED "${CMAKE_CURRENT_BINARY_DIR}/protobuf_output")
set(hw_proto_srcs "${GRPC_GENERATED}/helloworld.pb.cc")
set(hw_proto_hdrs "${GRPC_GENERATED}/helloworld.pb.h")
set(hw_grpc_srcs "${GRPC_GENERATED}/helloworld.grpc.pb.cc")
set(hw_grpc_hdrs "${GRPC_GENERATED}/helloworld.grpc.pb.h")
add_custom_command(
  OUTPUT "${hw_proto_srcs}" "${hw_proto_hdrs}" "${hw_grpc_srcs}" "${hw_grpc_hdrs}"
  COMMAND ${_PROTOBUF_PROTOC}
  ARGS --grpc_out "${GRPC_GENERATED}"
    --cpp_out "${GRPC_GENERATED}"
    -I "${hw_proto_path}"
    --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
    "${hw_proto}"
  DEPENDS "${hw_proto}"
)

# Include generated *.pb.h files
include_directories(${INCLUDE_DIRS} ${GRPC_GENERATED})

# source code
set(SERVER_SOURCES src/greeter_server.cc)
set(CLIENT_SOURCES src/greeter_client.cc)

# Append generated *.pb.cc files for both server executable and client executable
list(APPEND SERVER_SOURCES ${hw_proto_srcs})
list(APPEND SERVER_SOURCES ${hw_grpc_srcs})
list(APPEND CLIENT_SOURCES ${hw_proto_srcs})
list(APPEND CLIENT_SOURCES ${hw_grpc_srcs})

# target
add_executable(server ${SERVER_SOURCES})
target_link_libraries(server ${LINK_LIBS})

add_executable(client ${CLIENT_SOURCES})
target_link_libraries(client ${LINK_LIBS})
