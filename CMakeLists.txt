cmake_minimum_required(VERSION 3.20.0)

set(gltf_ver_maj 1)
set(gltf_ver_min 0)
set(gltf_ver_pat 0)
set(gltf_ver "${gltf_ver_maj}.${gltf_ver_min}.${gltf_ver_pat}")

project(gltf VERSION ${gltf_ver_maj}.${gltf_ver_min}.${gltf_ver_pat} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

find_package(simdjson REQUIRED)

add_library(gltf "${PROJECT_SOURCE_DIR}/gltf.cpp")
target_include_directories(gltf PRIVATE "${PROJECT_SOURCE_DIR}")
target_link_libraries(gltf PUBLIC simdjson)
set_target_properties(gltf PROPERTIES PUBLIC_HEADER "${PROJECT_SOURCE_DIR}/gltf.hpp")

if (GLTF_BUILD_EXAMPLE)
  add_subdirectory(example)
endif()

# packaging
include(CMakePackageConfigHelpers)
configure_package_config_file(
  "${PROJECT_SOURCE_DIR}/cmake/gltfConfig.cmake.in"
  "${PROJECT_BINARY_DIR}/cmake/gltfConfig.cmake"
  INSTALL_DESTINATION "lib/cmake/gltf"
)

write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/cmake/gltfConfigVersion.cmake"
  VERSION ${gltf_ver}
  COMPATIBILITY AnyNewerVersion
)

install(
  TARGETS gltf
  EXPORT gltfTargets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  PUBLIC_HEADER DESTINATION include
)

install(
  EXPORT gltfTargets
  FILE gltfTargets.cmake
  DESTINATION lib/cmake/gltf
)

install(
  FILES
    "${PROJECT_BINARY_DIR}/cmake/gltfConfig.cmake"
    "${PROJECT_BINARY_DIR}/cmake/gltfConfigVersion.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/gltf"
)