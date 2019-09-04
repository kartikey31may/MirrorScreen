import cv2
import numpy as np
from PIL import ImageGrab


class Video():

    def __init__(self, name, path, fps=30):
        self.file_name = path
        self.window_name = name
        self.interframe_wait_ms = fps

    def run(self):
        print(self.file_name)
        cap = cv2.VideoCapture(self.file_name)
        if not cap.isOpened():
            exit()
        cv2.namedWindow(self.window_name, cv2.WND_PROP_FULLSCREEN)
        cv2.setWindowProperty(self.window_name, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
        while True:
            ret, frame = cap.read()
            if ret:
                cv2.imshow(self.window_name, frame)
            else:
                cap.set(cv2.CAP_PROP_POS_FRAMES, 0)

            if cv2.waitKey(self.interframe_wait_ms) == ord('q'):
                break
        cap.release()
        cv2.destroyAllWindows()


class CreateVideo():
    frames_per_second = 24

    def __init__(self, path):
        self.file_path = path
        self.height, self.width, self.layers = np.array(ImageGrab.grab()).shape

    def run(self):
        out = cv2.VideoWriter(self.file_path, cv2.VideoWriter_fourcc(*'XVID'), 24, (self.width, self.height))
        while True:
            img = np.array(ImageGrab.grab())
            out.write(img)
            if cv2.waitKey(0) == ord('q'):
                break
        cv2.destroyAllWindows()
