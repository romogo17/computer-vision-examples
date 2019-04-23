# Image Inpainting
> Taken from [LearnOpenCV](https://www.learnopencv.com/)

**Image inpainting is a class of algorithms in computer vision where the objective is to fill regions inside an image or a video.**

## Navier-Stokes based Inpainting

The authors set up a partial differential equation (PDE) to update image intensities inside the region with the above constraints.

The image smoothness information is estimated by the image Laplacian and it is propagated along the isophotes (contours of equal intensities). The isophotes are estimated by the image gradient rotated by 90 degrees.

The authors show that these equations are closely related in form to the Navier-Stokes equations for 2D incompressible fluids.

The benefit of reducing the problem to one of fluid dynamics is that we benefit from well developed theoretical analysis and numerical tools.

[Further reading](http://www.math.ucla.edu/~bertozzi/papers/cvpr01.pdf)

## Fast Marching Method based

This implementation solves the same constraints using a different technique. Instead of using the image Laplacian as the estimator of smoothness, the author uses a weighted average over a known image neighborhood of the pixel to inpaint. The known neighborhood pixels and gradients are used to estimate the color of the pixel to be inpainted.

Once a pixel is inpainted, the boundary needs to updated. The author treats the missing region of the image as level sets and uses the fast marching method to update the boundary.

[Further reading](https://pdfs.semanticscholar.org/622d/5f432e515da69f8f220fb92b17c8426d0427.pdf)


## Run the examples
For **Python**:
```sh
python inpaint.py <image_path>
```

For **C++**, first build the examples and then:
```sh
./inpaint <image_path>
```

## Build the C++ examples
Specify the OpenCV_DIR in CMakeLists.txt file. Then:

```sh
mkdir build
cd build
cmake ..
```