# Copyright (c) 2020-2025 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

macro(set_common_project_settings required_components)
    # Path to common headers
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../)

    if (NOT TARGET TBB::tbb)
        list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../common/cmake/modules)
        find_package(TBB REQUIRED COMPONENTS ${required_components})
    endif()
    find_package(Threads REQUIRED)

    # ---------------------------------------------------------------------------------------------------------
    # Handle C++ standard version.
    if (NOT MSVC)  # no need to cover MSVC as it uses C++14 by default.
        if (NOT CMAKE_CXX_STANDARD)
            set(CMAKE_CXX_STANDARD 11)
        endif()
        if (CMAKE_CXX${CMAKE_CXX_STANDARD}_STANDARD_COMPILE_OPTION)  # if standard option was detected by CMake
            set(CMAKE_CXX_STANDARD_REQUIRED ON)
        endif()
    endif()

    set(CMAKE_CXX_EXTENSIONS OFF) # use -std=c++... instead of -std=gnu++...
    # ---------------------------------------------------------------------------------------------------------
endmacro()

macro(add_execution_target TARGET_NAME TARGET_DEPENDENCIES EXECUTABLE ARGS)
    if (WIN32)
        add_custom_target(${TARGET_NAME} set "PATH=$<TARGET_FILE_DIR:TBB::tbb>\\;$ENV{PATH}" & ${EXECUTABLE} ${ARGS})
    else()
        add_custom_target(${TARGET_NAME} ${EXECUTABLE} ${ARGS})
    endif()

    add_dependencies(${TARGET_NAME} ${TARGET_DEPENDENCIES})
endmacro()

macro(add_benchmark_target TARGET_NAME TARGET_DEPENDENCIES EXECUTABLE ARGS)
    find_program(GAWK gawk NO_CACHE)
    if(NOT GAWK)
      message(WARNING "AWK tool is not found: no benchmark reports will be composed by ${TARGET_NAME}.")
    else()
      message("AWK tool to compose data reports by ${TARGET_NAME}: ${GAWK}")
      find_file(TARGET_NAME_FILTER
        NAMES ${TARGET_NAME}.awk
        PATHS ${CMAKE_CURRENT_SOURCE_DIR}
        REQUIRED NO_CACHE)
      if (WIN32)
        add_custom_target(${TARGET_NAME}
          COMMAND set "PATH=$<TARGET_FILE_DIR:TBB::tbb>\\;$ENV{PATH}" & ${EXECUTABLE} ${ARGS} 2>&1 | ${GAWK} -v run_args="${ARGS}" -f ${TARGET_NAME_FILTER} > ${TARGET_NAME}.csv
        )
      else()
        add_custom_target(${TARGET_NAME}
          COMMAND  ${EXECUTABLE} ${ARGS} 2>&1 | ${GAWK} -v run_args="${ARGS}" -f ${TARGET_NAME_FILTER} > ${TARGET_NAME}.csv
        )
      endif()
      add_dependencies(${TARGET_NAME} ${TARGET_DEPENDENCIES})
    endif()
endmacro()
