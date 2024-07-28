if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake CACHE STRING "Vcpkg toolchain file")
endif()

cmake_minimum_required(VERSION 3.20.0)

set(gltf_ver_maj 1)
set(gltf_ver_min 0)
set(gltf_ver_pat 0)
set(gltf_ver "${gltf_ver_maj}.${gltf_ver_min}.${gltf_ver_pat}")

project(gltf VERSION ${gltf_ver_maj}.${gltf_ver_min}.${gltf_ver_pat} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

find_package(simdjson REQUIRED)

# include(cmake/FindSimdjson.cmake)

add_compile_definitions(NOMINMAX _USE_MATH_DEFINES) # Windows is trash

# include(cmake/wall.cmake)

if (GLTF_ENABLE_ASAN)
  set(GLWRAP_ENABLE_ASAN TRUE)
  include(cmake/asan.cmake)
endif()

add_library(gltf "${PROJECT_SOURCE_DIR}/gltf.cpp")
target_include_directories(gltf PUBLIC "${PROJECT_SOURCE_DIR}")
target_link_libraries(gltf PRIVATE simdjson)
set_target_properties(gltf PROPERTIES PUBLIC_HEADER "${PROJECT_SOURCE_DIR}/gltf.hpp")

if (GLTF_BUILD_EXAMPLE)
  add_subdirectory(example)
endif()

# packaging
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${PROJECT_SOURCE_DIR}/cmake/gltfConfig.cmake.in"
    "${PROJECT_BINARY_DIR}/cmake/gltfConfig.cmake"
    INSTALL_DESTINATION "lib/cmake/result"
)
write_basic_package_version_file(
    "${PROJECT_BINARY_DIR}/cmake/gltfConfigVersion.cmake"
    VERSION ${Result_ver}
    COMPATIBILITY AnyNewerVersion
)
install(
    TARGETS gltf
    LIBRARY DESTINATION lib
)

install(
    FILES
        "${PROJECT_BINARY_DIR}/cmake/gltfConfig.cmake"
        "${PROJECT_BINARY_DIR}/cmake/gltfConfigVersion.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/result"
)