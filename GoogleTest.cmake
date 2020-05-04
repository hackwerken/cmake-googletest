# MIT License
#
# Copyright (c) 2020 Martijn Stommels
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# This module downloads and compiles Googletest and Googlemock.


# pass toolchain file to external project if one is set
if(DEFINED CMAKE_TOOLCHAIN_FILE)
    set(TOOLCHAIN_FILE_LOCATION "${CMAKE_TOOLCHAIN_FILE}")

    set(GMOCK_EXTERNAL_CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE_LOCATION}")
    message(STATUS "Passing toolchain file ${TOOLCHAIN_FILE_LOCATION} to gtest external project.")
endif(DEFINED CMAKE_TOOLCHAIN_FILE)


# Enable ExternalProject CMake module
include(ExternalProject)

set(GTEST_DIR "${CMAKE_CURRENT_BINARY_DIR}/external/gmock")
set(GTEST_BINARY_DIR "${GTEST_DIR}/bin")
set(GTEST_SOURCE_DIR "${GTEST_DIR}/src")

set(GMOCK_LIB_PATH "${GTEST_BINARY_DIR}/lib/libgmock.a")
set(GMOCK_MAIN_PATH "${GTEST_BINARY_DIR}/lib/libgmock_main.a") # Can be used to link in the standaard GoogleMock main()
set(GTEST_LIB_PATH "${GTEST_BINARY_DIR}/lib/libgtest.a")
set(GTEST_MAIN_PATH "${GTEST_BINARY_DIR}/lib/libgtest_main.a")# Can be used to link in the standaard GoogleTest main()

set(GTEST_TAG "release-1.10.0" CACHE STRING "Git tag to use for GoogleTest")


# Download GoogleTest from Github
ExternalProject_Add(
    gtest_external
    GIT_REPOSITORY "https://github.com/google/googletest.git"
    GIT_TAG ${GTEST_TAG}
    GIT_SHALLOW ON
    PREFIX ${GTEST_DIR}
    BINARY_DIR ${GTEST_BINARY_DIR}
    BUILD_BYPRODUCTS ${GMOCK_LIB_PATH} ${GMOCK_MAIN_PATH} ${GTEST_LIB_PATH} ${GTEST_MAIN_PATH}
    INSTALL_COMMAND "" # Disable install step
    CMAKE_ARGS ${GMOCK_EXTERNAL_CMAKE_ARGS}
)


function(target_link_googletest target)
  add_dependencies(${target} gtest_external)

  target_include_directories(${target} PRIVATE "${GTEST_SOURCE_DIR}/gtest_external/googletest/include"
                                               "${GTEST_SOURCE_DIR}/gtest_external/googlemock/include")

  target_link_libraries(${target} PRIVATE ${GTEST_LIB_PATH} ${GMOCK_LIB_PATH} pthread)
  
endfunction(target_link_googletest)
