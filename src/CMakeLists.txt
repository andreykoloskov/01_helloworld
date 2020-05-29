if ($ENV{INTERNAL_BUILD_VARIABLE})
    set_property (GLOBAL PROPERTY USE_FOLDERS ON)

    link_directories(${BOOST_LIBRARYDIR})
    include_directories(${BOOST_INCLUDEDIR})

    set (Boost_USE_STATIC_LIBS ON)
    set (Boost_USE_MULTITHREADED ON)
endif ()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

find_package(Threads REQUIRED)
find_package(Boost COMPONENTS unit_test_framework REQUIRED)

configure_file(version.h.in ${PROJECT_SOURCE_DIR}/src/gen/version.h)

add_executable(helloworld_cli main.cpp)

add_library(helloworld lib.cpp)

add_executable(test_version test_version.cpp)

set_target_properties(helloworld_cli helloworld test_version PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

if(MSVC)
    target_compile_options(helloworld_cli PRIVATE /W4 /WX)
else()
    target_compile_options(helloworld_cli PRIVATE -Wall -Wextra -Wpedantic -Werror)
endif()

if (WIN32 OR ((${CMAKE_SYSTEM_NAME} STREQUAL "Linux") AND (${CMAKE_SYSTEM} MATCHES ".*el7.*")))
    set_target_properties(test_version PROPERTIES
        INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIR}
    )
else ()
    set_target_properties(test_version PROPERTIES
        COMPILE_DEFINITIONS BOOST_TEST_DYN_LINK
        INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIR}
    )
endif ()

target_link_libraries(helloworld_cli
    helloworld
    Threads::Threads
)

target_link_libraries(test_version
    ${Boost_LIBRARIES}
    helloworld
)

install(TARGETS helloworld_cli RUNTIME DESTINATION bin)

if (WIN32)
    set(CPACK_GENERATOR WIX)
elseif ((${CMAKE_SYSTEM_NAME} STREQUAL "Linux") AND (${CMAKE_SYSTEM} MATCHES ".*el7.*"))
    set(CPACK_GENERATOR RPM)
else ()
    set(CPACK_GENERATOR DEB)
endif()

set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

set(CPACK_PACKAGE_CONTACT andreykoloskov.ru@gmail.com)

#if (NOT WIN32 AND NOT ((${CMAKE_SYSTEM_NAME} STREQUAL "Linux") AND (${CMAKE_SYSTEM} MATCHES ".*el7.*")))
#    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
#endif()

include(CPack)

add_test(NAME helloworld_tests COMMAND test_version)