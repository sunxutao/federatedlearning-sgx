cmake_minimum_required(VERSION 3.12)
project(flsgx)

# configuration
cmake_policy(SET CMP0074 NEW)  # enable <PackageName>_ROOT environment variable
set(CMAKE_MODULE_PATH 
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake" 
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules" 
	"${CMAKE_MODULE_PATH}"
)

option(ROUTE  "Compile route guide case" OFF)

set(INCLUDE_DIRS "${CMAKE_HOME_DIRECTORY}/include")

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
if (ROUTE)
  get_filename_component(hw_proto "${CMAKE_CURRENT_SOURCE_DIR}/protos/route_guide.proto" ABSOLUTE)
else ()
  get_filename_component(hw_proto "${CMAKE_CURRENT_SOURCE_DIR}/protos/helloworld.proto" ABSOLUTE)
endif ()
get_filename_component(hw_proto_path "${hw_proto}" PATH)

# Generated sources
execute_process(COMMAND mkdir -p "${CMAKE_CURRENT_BINARY_DIR}/protobuf_output")
set(GRPC_GENERATED "${CMAKE_CURRENT_BINARY_DIR}/protobuf_output")
if (ROUTE)
  set(hw_proto_srcs "${GRPC_GENERATED}/route_guide.pb.cc")
  set(hw_proto_hdrs "${GRPC_GENERATED}/route_guide.pb.h")
  set(hw_grpc_srcs "${GRPC_GENERATED}/route_guide.grpc.pb.cc")
  set(hw_grpc_hdrs "${GRPC_GENERATED}/route_guide.grpc.pb.h")
else ()
  set(hw_proto_srcs "${GRPC_GENERATED}/helloworld.pb.cc")
  set(hw_proto_hdrs "${GRPC_GENERATED}/helloworld.pb.h")
  set(hw_grpc_srcs "${GRPC_GENERATED}/helloworld.grpc.pb.cc")
  set(hw_grpc_hdrs "${GRPC_GENERATED}/helloworld.grpc.pb.h")
endif ()
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
if (ROUTE)
  set(SERVER_SOURCES src/route_guide/route_guide_server.cc)
  set(CLIENT_SOURCES src/route_guide/route_guide_client.cc)
else ()
  set(SERVER_SOURCES src/greeter/greeter_server.cc)
  set(CLIENT_SOURCES src/greeter/greeter_client.cc)
endif ()

# Append generated *.pb.cc files for both server executable and client executable
list(APPEND SERVER_SOURCES ${hw_proto_srcs})
list(APPEND SERVER_SOURCES ${hw_grpc_srcs})
list(APPEND CLIENT_SOURCES ${hw_proto_srcs})
list(APPEND CLIENT_SOURCES ${hw_grpc_srcs})

if (ROUTE)
  list(APPEND SERVER_SOURCES src/route_guide/helper.cc)
  list(APPEND CLIENT_SOURCES src/route_guide/helper.cc)
endif ()

# target
add_executable(server ${SERVER_SOURCES})
target_link_libraries(server ${LINK_LIBS})

add_executable(client ${CLIENT_SOURCES})
target_link_libraries(client ${LINK_LIBS})
