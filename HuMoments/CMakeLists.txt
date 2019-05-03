cmake_minimum_required(VERSION 2.8.12)

PROJECT(computer-vision-examples)

set(OpenCV_DIR /Users/ro/.local/lib/cmake/opencv4/)
find_package( OpenCV REQUIRED )

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

include_directories(${OpenCV_INCLUDE_DIRS})

MACRO(add_example name)
  ADD_EXECUTABLE(${name} ${name}.cc)
  TARGET_LINK_LIBRARIES(${name} ${OpenCV_LIBS})
ENDMACRO()

add_example(hu_moments)
add_example(shape_matcher)
