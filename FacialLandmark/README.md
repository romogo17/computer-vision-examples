# Facial Landmark

> Modified from [LearnOpenCV](https://www.learnopencv.com/)

## Run the examples
For **Jypyter Notebook**, first install the requirements and then:
```sh
jupyter-notebook
```

For **C++**, first build the examples and then:

```sh
./facial_landmark
```

## Build the C++ examples

Specify the OpenCV_DIR and dlib_DIR in CMakeLists.txt file. Then:

```sh
mkdir build
cd build
cmake ..
make
```

## Requirements
Aside from OpenCV, this example requires [Dlib](http://dlib.net/). There is an installation script for OSX unde the `scripts/` directory.

Also, to run the Jupyter notebook you will need to install [Xeus-Cling](https://github.com/QuantStack/xeus-cling), which is a C++ Jupyter kernel

Download the [shape_predictor_68_face_landmarks.dat](https://github.com/davisking/dlib-models/blob/master/shape_predictor_68_face_landmarks.dat.bz2) file and extract it with:
```sh
bzip2 -d shape_predictor_68_face_landmarks.dat.bz2
```