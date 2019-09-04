from video import Video
from video import CreateVideo
import os
import time

class Sync():
    url = ""


if __name__ == '__main__':
    path = os.getcwd() + "\\flask\\uploads\\"
    file = os.listdir(path)[0]
    name = str(round(time.time() * 1000)) + ".mp4"
    path+=name

    createVideo = CreateVideo(path)

    
