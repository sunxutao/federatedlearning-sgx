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

# dependencies
include(FindRequiredPackage)

#---[ protobuf
FindRequiredPackage(NAME Protobuf)

#---[ grpc
#FindRequiredPackage(NAME Grpc)

# compilation
set(CMAKE_CXX_FLAGS 
  "${CMAKE_CXX_FLAGS} -std=c++11 -O2 -pthread -Wall -Wno-unused-function")

# source code
set(SOURCES src/main.cc)

# target
add_executable(flsgx ${SOURCES})
target_link_libraries(flsgx ${LINK_LIBS})
