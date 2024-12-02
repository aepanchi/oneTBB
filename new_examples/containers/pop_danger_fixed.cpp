/*
    Copyright (c) 2024 Intel Corporation
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
        http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#include <iostream>
#include <tbb/concurrent_priority_queue.h>
#include <tbb/parallel_invoke.h>
#include <tbb/parallel_for.h>

int main() { 
  int sum0(0), sum1(0); 
  
  tbb::concurrent_priority_queue<int> myPQ; 
  
  tbb::parallel_for(0,10001,1, 
        [&](size_t i){ myPQ.push(i); } ); 
  
  tbb::parallel_invoke( 
    [&]() { 
      int item = 0; 
      while( myPQ.try_pop(item) ) 
        sum0 += item; 
    }, 
    [&]() { 
      int item = 0; 
      while( myPQ.try_pop(item) ) 
        sum1 += item; 
    }); 

  // prints "total: 50005000" (for 0,10001,1)
  std::cout << "total: "
	    << sum0+sum1 << '\n';
  return 0;
}
