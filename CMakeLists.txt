cmake_minimum_required(VERSION 3.19)
project(wamr.mbt LANGUAGES C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE on)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wmissing-field-initializers -lm")

include(CMakePrintHelpers)
set(MOON_HOME "$ENV{MOON_HOME}")
cmake_print_variables(MOON_HOME)

include(cmake/MoonBit.cmake)

setup_moonbit_module(.)

add_library(wamr.mbt::moonbit ALIAS moonbit)

set(WAMR_BUILD_PLATFORM "linux")
set(WAMR_BUILD_TARGET "X86_64")
set(WAMR_BUILD_INTERP 1)
set(WAMR_BUILD_FAST_INTERP 1)
set(WAMR_BUILD_AOT 1)
set(WAMR_BUILD_LIBC_BUILTIN 1)
set(WAMR_BUILD_LIBC_WASI 1)
set(WAMR_BUILD_SIMD 1)
set(WAMR_ROOT_DIR src/wamr)

include(${WAMR_ROOT_DIR}/build-scripts/runtime_lib.cmake)
add_library(vmlib ${WAMR_RUNTIME_LIB_SOURCE})

add_library(wamr.mbt STATIC src/wasm/wasm.c)
add_library(wamr.mbt::wamr.mbt ALIAS wamr.mbt)
target_link_libraries(wamr.mbt PRIVATE moonbit vmlib)

include(GNUInstallDirs)
install(
  TARGETS wamr.mbt moonbit vmlib
  EXPORT WAMRTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(
  EXPORT WAMRTargets
  NAMESPACE wamr.mbt::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/wamr.mbt
  FILE WAMRTargets.cmake)
export(EXPORT WAMRTargets FILE ${CMAKE_CURRENT_BINARY_DIR}/WAMRTargets.cmake)
include(CMakePackageConfigHelpers)
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/cmake/Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/wamr.mbt-config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/wamr.mbt
)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/wamr.mbt-config.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/wamr.mbt
)

add_moon_package(src)
