<!--
******************************************************************************
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/-->

# Release Notes <!-- omit in toc -->
This document contains changes of oneTBB compared to the last release.

## Table of Contents <!-- omit in toc -->
- [New Features](#new-features)
- [Known Limitations](#known-limitations)
- [Fixed Issues](#fixed-issues)

## :tada: New Features
- Extended the ``parallel_reduce`` and ``parallel_deterministic_reduce`` functional form APIs to better support ``rvalues reduction`` ([GitHub* #1299](https://github.com/oneapi-src/oneTBB/issues/1299)). 

## :rotating_light: Known Limitations
- The ``oneapi::tbb::info`` namespace interfaces might unexpectedly change the process affinity mask on Windows* OS systems (see https://github.com/open-mpi/hwloc/issues/366 for details) when using hwloc version lower than 2.5.
- Using a hwloc version other than 1.11, 2.0, or 2.5 may cause an undefined behavior on Windows OS. See https://github.com/open-mpi/hwloc/issues/477 for details.
- The NUMA topology may be detected incorrectly on Windows* OS machines where the number of NUMA node threads exceeds the size of 1 processor group.
- On Windows OS on ARM64*, when compiling an application using oneTBB with the Microsoft* Compiler, the compiler issues a warning C4324 that a structure was padded due to the alignment specifier. Consider suppressing the warning by specifying /wd4324 to the compiler command line.
- C++ exception handling mechanism on Windows* OS on ARM64* might corrupt memory if an exception is thrown from any oneTBB parallel algorithm (see Windows* OS on ARM64* compiler issue: https://developercommunity.visualstudio.com/t/ARM64-incorrect-stack-unwinding-for-alig/1544293.
- When CPU resource coordination is enabled, tasks from a lower-priority ``task_arena`` might be executed before tasks from a higher-priority ``task_arena``.

> **_NOTE:_**  To see known limitations that impact all versions of oneTBB, refer to [oneTBB Documentation](https://oneapi-src.github.io/oneTBB/main/intro/limitations.html).


## :hammer: Fixed Issues
- Improved security by excluding CWD from a search for load-time dependencies.
- Improved performance:
  - On Apple* platforms by aligning block-time behavior with other OSs.
  - On non-hybrid CPU hardware by reworking block-time behavior.
  - On ARM64* platforms by fixing backoff behavior for spin loops.
  - When constrained APIs are used on a server CPU HW with multiple NUMA nodes.
- Improved WASM support by fixing a segmentation fault if global ``tbb::task_scheduler_observer`` is used. ([GitHub* #1341](https://github.com/oneapi-src/oneTBB/issues/1341)). 
- Fixed CMake skipping library compilation when using FetchContent with ``OVERRIDE_FIND_PACKAGE`` ([GitHub* #1323](https://github.com/oneapi-src/oneTBB/issues/1323)). 
- Improved support for Bazel version 7.1.1. 
- Added Apple* frameworks support to build iOS-compatible application bundles ([GitHub* #1252](https://github.com/oneapi-src/oneTBB/issues/1252)). 
- Fixed the huge page size for LoongArch64* architecture. 
- Fixed oneTBB build with MinGW* and GCC* 13.2 ([GitHub* #1314](https://github.com/oneapi-src/oneTBB/issues/1314)). 
