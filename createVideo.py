import cv2
import numpy as np
from PIL import ImageGrab


class CreateVideo():
    frames_per_second = 24

    def __init__(self, name):
        self.filename = name
        self.height, self.width, self.layers = np.array(ImageGrab.grab()).shape

    def run(self):
        out = cv2.VideoWriter(self.filename, cv2.VideoWriter_fourcc(*'XVID'), 24, (self.width, self.height))
        while True:
            img = np.array(ImageGrab.grab())
            out.write(img)
            if cv2.waitKey(0) == ord('q'):
                break
        cv2.destroyAllWindows()
