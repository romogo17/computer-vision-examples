
#include "include_libraries.h"

#include <string>
#include <cstring>
#include <fstream>

#include <dlib/opencv.h>
#include <dlib/image_processing.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;
using namespace dlib;

// Write landmarks to file
void writeLandmarksToFile(dlib::full_object_detection &landmarks, const std::string &filename)
{
  // Open file
  std::ofstream ofs;
  ofs.open(filename);

  // Loop over all landmark points
  for (int i = 0; i < landmarks.num_parts(); i++)
  {
    // Print x and y coordinates to file
    ofs << landmarks.part(i).x() << " " << landmarks.part(i).y() << std::endl;
  }
  // Close file
  ofs.close();
}

void drawLandmarks(cv::Mat &im, dlib::full_object_detection landmarks)
{
  for (int i = 0; i < landmarks.num_parts(); i++)
  {
    int px = landmarks.part(i).x();
    int py = landmarks.part(i).y();

    char landmark_index[3];
    sprintf(landmark_index, "%d", i + 1);

    circle(im, cv::Point(px, py), 1, cv::Scalar(0, 0, 255), 2, cv::LINE_AA);
    putText(im, landmark_index, cv::Point(px, py), cv::FONT_HERSHEY_SIMPLEX, .3, cv::Scalar(255, 0, 0), 1);
  }
}

int main()
{
  // Create the landmark detector and the face detector
  dlib::frontal_face_detector faceDetector = dlib::get_frontal_face_detector();
  dlib::shape_predictor landmarkDetector;
  // After that, deserialize the shape predictor for face landmarks into the landmark detector
  dlib::deserialize("../shape_predictor_68_face_landmarks.dat") >> landmarkDetector;

  // Read the image into a dlib image
  std::string imageFilename("../images/girl.jpg");
  cv::Mat im = cv::imread(imageFilename);

  std::string landmarksBasename("output");

  dlib::cv_image<dlib::bgr_pixel> dlibIm(im);

  // Detect the faces in the image
  std::vector<dlib::rectangle> faceRects = faceDetector(dlibIm);
  std::cout << "Number of faces detected: " << faceRects.size() << std::endl;

  // Detect the face landmarks in each of the faces detected
  std::vector<dlib::full_object_detection> landmarksAll;
  for (int i = 0; i < faceRects.size(); i++)
  {
    // For every face rectangle, run landmarkDetector
    dlib::full_object_detection landmarks;

    landmarks = landmarkDetector(dlibIm, faceRects[i]);

    // Print number of landmarks
    if (i == 0)
      std::cout << "Number of landmarks : " << landmarks.num_parts() << std::endl;

    // Store landmarks for current face
    landmarksAll.push_back(landmarks);

    // Draw landmarks on face
    drawLandmarks(im, landmarks);

    // Write landmarks to disk
    std::stringstream landmarksFilename;
    landmarksFilename << landmarksBasename << "_" << i << ".txt";
    std::cout << "Saving landmarks to " << landmarksFilename.str() << std::endl;
    writeLandmarksToFile(landmarks, landmarksFilename.str());
  }

  std::string outputFilename("../images/girl_output.jpg");
  std::cout << "Saving output image to " << outputFilename << std::endl;

  cv::imwrite(outputFilename, im);

  return 0;
}