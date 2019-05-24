#
# A wrapper macro around the standard CMake find_package macro that
# simplifies the calling of dependency resolution. It takes the following 
# arguments: 
#
#   NAME -- package name [REQUIRED]
#   COMPONENTS -- package components
#   ERROR_MESSAGE -- custom error message
#
# Example: 
#
# include(FindRequiredPackage)
#
# FindRequiredPackage(NAME Perl)
#
# FindRequiredPackage(
#   NAME FLEX 
#   ERROR_MESSAGE "You need to install flex (Fast Lexical Analyzer)"
# )
#
# FindRequiredPackage(
#   NAME Boost
#   COMPONENTS filesystem program_options system
# )
#

macro(FindRequiredPackage)
  set(options)
  set(oneValueArgs NAME ERROR_MESSAGE)
  set(multiValueArgs COMPONENTS)
  cmake_parse_arguments(
    PKG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
  )
  if (NOT PKG_NAME)
    message(FATAL_ERROR "Package name is required")
  endif ()

  string(TOUPPER ${PKG_NAME} UPPER_PKG_NAME)
  if ((DEFINED ${UPPER_PKG_NAME}_ROOT_DIR) AND (DEFINED CMAKE_PREFIX_PATH))
    set(CMAKE_PREFIX_SAVE ${CMAKE_PREFIX_PATH})
    unset(CMAKE_PREFIX_PATH)
    if (PKG_COMPONENTS)
      find_package(${PKG_NAME} COMPONENTS "${PKG_COMPONENTS}")
    else ()
      find_package(${PKG_NAME})
    endif ()
    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_SAVE})
  else ()
    if (PKG_COMPONENTS)
      find_package(${PKG_NAME} COMPONENTS "${PKG_COMPONENTS}")
    else ()
      find_package(${PKG_NAME})
    endif ()
  endif ()
  
  if (${PKG_NAME}_FOUND)
    if ((DEFINED ${PKG_NAME}_INCLUDE_DIRS) OR (DEFINED ${PKG_NAME}_LIBRARIES))
      list(APPEND INCLUDE_DIRS ${${PKG_NAME}_INCLUDE_DIRS})
      list(APPEND LINK_LIBS ${${PKG_NAME}_LIBRARIES})
    else ()
      list(APPEND INCLUDE_DIRS ${${UPPER_PKG_NAME}_INCLUDE_DIRS})
      list(APPEND LINK_LIBS ${${UPPER_PKG_NAME}_LIBRARIES})
    endif ()

  elseif (${UPPER_PKG_NAME}_FOUND)
    if ((DEFINED ${UPPER_PKG_NAME}_INCLUDE_DIRS) OR (DEFINED ${UPPER_PKG_NAME}_LIBRARIES))
      list(APPEND INCLUDE_DIRS ${${UPPER_PKG_NAME}_INCLUDE_DIRS})
      list(APPEND LINK_LIBS ${${UPPER_PKG_NAME}_LIBRARIES})
    else ()
      list(APPEND INCLUDE_DIRS ${${PKG_NAME}_INCLUDE_DIRS})
      list(APPEND LINK_LIBS ${${PKG_NAME}_LIBRARIES})
    endif ()
  
  else ()
    if (PKG_ERROR_MESSAGE)
      set(errorMsg ${PKG_ERROR_MESSAGE})
    else ()
      set(errorMsg "Failed to find prerequisite package '${PKG_NAME}'")
    endif ()
    message(STATUS ${errorMsg})
    # Download the missing thirdparty packages
    include("cmake/Add${PKG_NAME}.cmake")
  endif ()
endmacro(FindRequiredPackage)
