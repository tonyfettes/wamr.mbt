cmake_minimum_required(VERSION 3.19)
project(wamr.mbt LANGUAGES C)

set(c.mbt_DIR ${CMAKE_SOURCE_DIR}/../c.mbt/install/lib/cmake/c.mbt)
find_package(c.mbt REQUIRED)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE on)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wmissing-field-initializers -lm")

include(CMakePrintHelpers)
set(MOON_HOME "$ENV{MOON_HOME}")
cmake_print_variables(MOON_HOME)

include(cmake/MoonBit.cmake)

setup_moonbit_module(.)

# Automatically detect platform
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(WAMR_BUILD_PLATFORM "linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(WAMR_BUILD_PLATFORM "darwin")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(WAMR_BUILD_PLATFORM "windows")
else()
  message(WARNING "Unsupported platform: ${CMAKE_SYSTEM_NAME}, defaulting to linux")
  set(WAMR_BUILD_PLATFORM "linux")
endif()

# Automatically detect architecture
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
  set(WAMR_BUILD_TARGET "X86_64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64|aarch64")
  set(WAMR_BUILD_TARGET "AARCH64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "arm|ARM")
  set(WAMR_BUILD_TARGET "ARM")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "i686|i386")
  set(WAMR_BUILD_TARGET "X86_32")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "riscv64")
  set(WAMR_BUILD_TARGET "RISCV64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "riscv32")
  set(WAMR_BUILD_TARGET "RISCV32")
else()
  message(WARNING "Unsupported architecture: ${CMAKE_SYSTEM_PROCESSOR}, defaulting to X86_64")
  set(WAMR_BUILD_TARGET "X86_64")
endif()

# Print detected platform and architecture
message(STATUS "Detected platform: ${WAMR_BUILD_PLATFORM}")
message(STATUS "Detected architecture: ${WAMR_BUILD_TARGET}")
set(WAMR_BUILD_INTERP 1)
set(WAMR_BUILD_FAST_INTERP 1)
set(WAMR_BUILD_AOT 1)
set(WAMR_BUILD_LIBC_BUILTIN 1)
set(WAMR_BUILD_LIBC_WASI 0)
set(WAMR_BUILD_SIMD 1)
set(WAMR_BUILD_GC 1)
set(WAMR_ROOT_DIR src/wamr)

include(${WAMR_ROOT_DIR}/build-scripts/runtime_lib.cmake)
add_library(vmlib ${WAMR_RUNTIME_LIB_SOURCE})

add_library(wamr.mbt::moonbit ALIAS moonbit)
add_library(wamr.mbt STATIC src/wasm/wasm.c)
add_library(wamr.mbt::wamr.mbt ALIAS wamr.mbt)
add_library(wamr.mbt::vmlib ALIAS vmlib)
target_link_libraries(wamr.mbt PRIVATE moonbit vmlib c.mbt::c.mbt)

include(GNUInstallDirs)
install(
  TARGETS wamr.mbt vmlib moonbit
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
