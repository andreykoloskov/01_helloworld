cmake_minimum_required(VERSION 3.11)

project(helloworld VERSION 0.0.$ENV{TRAVIS_BUILD_NUMBER})

set(CMAKE_CXX_STANDARD 17)

if(WIN32 AND MSVC AND MSVC_VERSION GREATER 1400)
    add_compile_options(/MP)
endif()

enable_testing()

add_subdirectory("src")
