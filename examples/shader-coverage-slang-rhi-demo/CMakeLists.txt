cmake_minimum_required(VERSION 3.20)
project(slang_rhi_coverage_demo LANGUAGES CXX)

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

add_executable(slang-rhi-coverage-demo
    main.cpp
)

target_include_directories(slang-rhi-coverage-demo PRIVATE
    "${SLANG_REPO}/include"
    "${SLANG_RHI_REPO}/include"
    "${SLANG_RHI_GENERATED_INCLUDE_DIR}"
)

target_link_libraries(slang-rhi-coverage-demo PRIVATE
    "${SLANG_RHI_LIB}"
    "${SLANG_RHI_RESOURCES_LIB}"
    "${SLANG_COMPILER_LIB}"
)

if(APPLE)
    target_link_libraries(slang-rhi-coverage-demo PRIVATE
        "-framework Foundation"
        "-framework Metal"
        "-framework Cocoa"
        "-framework IOKit"
        "-framework QuartzCore"
        "-framework CoreFoundation"
    )
endif()

if(APPLE)
    target_link_options(slang-rhi-coverage-demo PRIVATE
        "-Wl,-rpath,${SLANG_BUILD_DIR}/lib"
        "-Wl,-rpath,${SLANG_BUILD_DIR}/bin"
        "-Wl,-rpath,${SLANG_RHI_BUILD_DIR}"
    )
endif()

if(BUILD_TESTING)
    add_test(
        NAME slang-rhi-coverage-demo-vulkan
        COMMAND slang-rhi-coverage-demo --device=vulkan
    )
    add_test(
        NAME slang-rhi-coverage-demo-cuda
        COMMAND slang-rhi-coverage-demo --device=cuda
    )
endif()
