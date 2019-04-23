import numpy as np
import cv2 as cv
import sys

# OpenCV Utility Class for Mouse Handling
class Sketcher:
  def __init__(self, windowname, dests, colors_func):
    self.prev_pt = None
    self.windowname = windowname
    self.dests = dests
    self.colors_func = colors_func
    self.dirty = False
    self.show()
    cv.setMouseCallback(self.windowname, self.on_mouse)

  def show(self):
    cv.imshow(self.windowname, self.dests[0])
    cv.imshow(self.windowname + ": mask", self.dests[1])

  def on_mouse(self, event, x, y, flags, param):
    pt = (x, y)
    if event == cv.EVENT_LBUTTONDOWN:
      self.prev_pt = pt
    elif event == cv.EVENT_LBUTTONUP:
      self.prev_pt = None

    if self.prev_pt and flags & cv.EVENT_FLAG_LBUTTON:
      for dst, color in zip(self.dests, self.colors_func()):
        cv.line(dst, self.prev_pt, pt, color, 5)
      self.dirty = True
      self.prev_pt = pt
      self.show()

def main():
  print("""usage: python inpaint <image_path>
keys:
  t     Inpaint using FMM
  n     Inpaint using NS
  r     Reset te inpainting mask
  ESC   Exit """)

  # Read the image in color mode
  img = cv.imread(sys.argv[1], cv.IMREAD_COLOR)

  # If image is not read properly, return error
  if img is None:
    print("Failed to load image file: {}".format(sys.argv[1]))
    return

  # Create a copy of original image
  img_mask = img.copy()

  # Create a black copy of original image (acts as a mask)
  inpaint_mask = np.zeros(img.shape[:2], np.uint8)

  # Create a sketch using utility class Sketcher
  sketch = Sketcher(sys.argv[1], [img_mask, inpaint_mask],
    lambda : ((255, 255, 255), 255)
  )

  while True:
    ch = cv.waitKey()
    if ch == 27:
      break
    if ch == ord('t'):
      # Use Algorithm proposed by Alexendra Telea: Fast Marching Method (2004)
      res = cv.inpaint(src=img_mask, inpaintMask=inpaint_mask, inpaintRadius=3, flags=cv.INPAINT_TELEA)
      cv.imshow("Inpaiunt output using FMM", res)
    if ch == ord('n'):
      # Use Algorithm proposed by Bertalmio, Marcelo, Andrea L. Bertozzi, and Guillermo Sapiro: Navier-Stokes, Fluid Dynamics, and Image and Video Inpainting (2001)
      res = cv.inpaint(src=img_mask, inpaintMask=inpaint_mask, inpaintRadius=3, flags=cv.INPAINT_NS)
      cv.imshow("Inpaiunt output using NS technique", res)
    if ch == ord('r'):
      img_mask[:] = img
      inpaint_mask[:] = 0
      sketch.show()
  print("Completed")

if __name__ == '__main__':
  main()
  cv.destroyAllWindows()
