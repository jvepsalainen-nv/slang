cmake_minimum_required(VERSION 3.20)
project(shader_coverage_binding_demo LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
include(CTest)

get_filename_component(_slang_repo_default "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
set(SLANG_REPO "${_slang_repo_default}" CACHE PATH "Path to the Slang repository checkout")
set(SLANG_RHI_REPO "" CACHE PATH "Path to the slang-rhi repository checkout")
set(SLANG_BUILD_DIR "${SLANG_REPO}/build/Debug" CACHE PATH "Path to the built Slang tree")
set(SLANG_RHI_BUILD_DIR "" CACHE PATH "Path to the built slang-rhi tree")
set(SLANG_RHI_GENERATED_INCLUDE_DIR "" CACHE PATH "Path to generated slang-rhi headers")

if(NOT SLANG_RHI_REPO)
    message(FATAL_ERROR "Set SLANG_RHI_REPO to a slang-rhi checkout containing the synthetic resource binding changes.")
endif()

if(NOT SLANG_RHI_BUILD_DIR)
    message(FATAL_ERROR "Set SLANG_RHI_BUILD_DIR to the built slang-rhi output directory.")
endif()

if(NOT SLANG_RHI_GENERATED_INCLUDE_DIR)
    get_filename_component(_slang_rhi_build_root "${SLANG_RHI_BUILD_DIR}" DIRECTORY)
    set(SLANG_RHI_GENERATED_INCLUDE_DIR "${_slang_rhi_build_root}/include")
endif()

find_library(SLANG_RHI_LIB slang-rhi PATHS "${SLANG_RHI_BUILD_DIR}" NO_DEFAULT_PATH REQUIRED)
find_library(SLANG_RHI_RESOURCES_LIB slang-rhi-resources PATHS "${SLANG_RHI_BUILD_DIR}" NO_DEFAULT_PATH REQUIRED)
find_library(SLANG_COMPILER_LIB slang-compiler PATHS "${SLANG_BUILD_DIR}/lib" "${SLANG_BUILD_DIR}/bin" NO_DEFAULT_PATH REQUIRED)

add_executable(shader-coverage-binding-demo
    main.cpp
)

target_include_directories(shader-coverage-binding-demo PRIVATE
    "${SLANG_REPO}/include"
    "${SLANG_RHI_REPO}/include"
    "${SLANG_RHI_GENERATED_INCLUDE_DIR}"
)

target_link_libraries(shader-coverage-binding-demo PRIVATE
    "${SLANG_RHI_LIB}"
    "${SLANG_RHI_RESOURCES_LIB}"
    "${SLANG_COMPILER_LIB}"
)

if(APPLE)
    target_link_libraries(shader-coverage-binding-demo PRIVATE
        "-framework Foundation"
        "-framework Metal"
        "-framework Cocoa"
        "-framework IOKit"
        "-framework QuartzCore"
        "-framework CoreFoundation"
    )
endif()

if(APPLE)
    target_link_options(shader-coverage-binding-demo PRIVATE
        "-Wl,-rpath,${SLANG_BUILD_DIR}/lib"
        "-Wl,-rpath,${SLANG_BUILD_DIR}/bin"
        "-Wl,-rpath,${SLANG_RHI_BUILD_DIR}"
    )
endif()

if(BUILD_TESTING)
    add_test(
        NAME shader-coverage-binding-demo-vulkan
        COMMAND shader-coverage-binding-demo --device=vulkan
    )
    add_test(
        NAME shader-coverage-binding-demo-cuda
        COMMAND shader-coverage-binding-demo --device=cuda
    )
endif()
