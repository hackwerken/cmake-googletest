cmake_minimum_required(VERSION 3.13)
project(cmake-googletest-example)

include(../GoogleTest.cmake)

add_executable(unittest "test.cpp")

target_link_libraries(unittest PRIVATE ${GMOCK_MAIN_PATH})
target_link_googletest(unittest)
