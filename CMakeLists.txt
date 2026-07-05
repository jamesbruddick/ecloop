cmake_minimum_required(VERSION 3.15)
project(ecloop C)

# ecloop is a unity build: main.c #includes every lib/*.c (all use #pragma once).
add_executable(ecloop main.c)

set_target_properties(ecloop PROPERTIES C_STANDARD 11)

# The code relies on GCC/Clang extensions (__uint128_t, statement expressions,
# __builtin_*), so MSVC is not supported. Use GCC or Clang (MinGW-w64 on Windows).
if(NOT (CMAKE_C_COMPILER_ID MATCHES "GNU|Clang"))
  message(FATAL_ERROR "ecloop requires GCC or Clang (MinGW-w64 on Windows); MSVC is not supported.")
endif()

target_compile_options(ecloop PRIVATE -O3 -ffast-math -Wall -Wextra)

# Enable native SIMD (AVX2 / SHA) on x86_64 to match the Makefile.
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
  target_compile_options(ecloop PRIVATE -march=native)
endif()

find_package(Threads REQUIRED)
target_link_libraries(ecloop PRIVATE Threads::Threads)

if(WIN32)
  # BCryptGenRandom (system RNG, replaces /dev/urandom).
  target_link_libraries(ecloop PRIVATE bcrypt)
else()
  target_link_libraries(ecloop PRIVATE m)
endif()
