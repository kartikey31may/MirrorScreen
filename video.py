import cv2


class Video:

    def __init__(self, name, path, fps=30):
        self.file_name = path
        self.window_name = name
        self.interframe_wait_ms = fps

    def run(self):
        #print(self.file_name)
        cap = cv2.VideoCapture(self.file_name)
        if not cap.isOpened():
            exit()
        cv2.namedWindow(self.window_name, cv2.WND_PROP_FULLSCREEN)
        cv2.setWindowProperty(self.window_name, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

        for i in range(int(cap.get(cv2.CAP_PROP_FRAME_COUNT))):
            ret, frame = cap.read()
            if ret:
                cv2.imshow(self.window_name, frame)
            else:
                cap.set(cv2.CAP_PROP_POS_FRAMES, 0)

            if cv2.waitKey(self.interframe_wait_ms) == ord('q'):
                break
        cap.release()
        cv2.destroyAllWindows()
