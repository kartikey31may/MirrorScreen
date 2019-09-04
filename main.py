import video
import os

class Sync():
	url = ""

if __name__ == '__main__':
	path = os.getcwd()+"\\flask\\uploads\\"
	file = os.listdir(path)[0]
	path+=file
	v = video.video("test", path)
	v.run()

	