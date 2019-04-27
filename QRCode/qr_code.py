import cv2
import numpy as np
import sys
import time


def display(im, bbox):
    n = len(bbox)
    for j in range(n):
        cv2.line(im,
                 tuple(bbox[j][0]),
                 tuple(bbox[(j+1) % n][0]),
                 (255, 0, 0), 3)
        cv2.imshow("Results", im)


def main():
    if len(sys.argv) > 1:
        input_image = cv2.imread(sys.argv[1])
    else:
        input_image = cv2.imread("images/convoluted-webpage.png")

    qr_decoder = cv2.QRCodeDetector()
    t = time.time()
    data, bbox, rectifiedImage = qr_decoder.detectAndDecode(input_image)
    print("Time taken for Detect and Decode : {:.3f} seconds".format(
        time.time() - t))

    if len(data) > 0:
        print("Decoded Data: {}".format(data))
        display(input_image, bbox)
        rectifiedImage = np.uint8(rectifiedImage)
        cv2.imshow("Rectified QR Code", rectifiedImage)
    else:
        print("QR Code not detected")
        cv2.imshow("Results", input_image)

    cv2.waitKey(0)
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
