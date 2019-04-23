# Hu Moments
> Taken from [LearnOpenCV](https://www.learnopencv.com/)

**Image moments are a weighted average of image pixel intensities.**

Image moments capture information about the shape of a blob in a binary image because they contain information about the intensity I(x,y), as well as position x and y of the pixels.

Hu Moments ( or rather Hu moment invariants ) are a set of 7 numbers calculated using central moments that are invariant to image transformations. The first 6 moments have been proved to be invariant to translation, scale, and rotation, and reflection. While the 7th moment’s sign changes for image reflection.

[Further reading](https://www.researchgate.net/publication/224146066_Analysis_of_Hu's_moment_invariants_on_image_scaling_and_rotation)


## Run the examples
For **Python**:
```sh
# Hu Moments example
python hu_moments.py images/*

# Shape Matcher example
python shape_matcher.py
```

For **C++**, first build the examples and then:
```sh
# Hu Moments example
./hu_moments ../images/*

# Shape Matcher example
./shape_matcher
```

## Build the C++ examples
Specify the OpenCV_DIR in CMakeLists.txt file. Then:

```sh
mkdir build
cd build
cmake ..
```