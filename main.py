from video import Video
from video import CreateVideo
import os
import time
import requests

url = "http://hitenjain88.pythonanywhere.com/uploads"

def returnUploads():
		List = os.listdir(os.getcwd()+"//uploads")
		return List

def sync():
	r = requests.get(url=url)
	json = r.json()
	video = json['video']
	picture = json['picture']

	data = returnUploads()
	for i in video:
		if i not in data:
			re = requests.get(url+"/"+i, allow_redirects=True)
			
			with open(os.getcwd()+"//uploads//"+i, 'wb') as f: 
				f.write(re.content)
				print(i)

	for i in picture:
		if i not in data:
			re = requests.get(url+"/"+i, allow_redirects=True)
			with open(os.getcwd()+"//uploads//"+i, 'wb') as f: 
				f.write(re.content)
				print(i)

if __name__ == '__main__':
    r = requests.get(url=url)
    json = r.json()
    video = json['video']
    picture = json['picture']
    print(video, picture)
    sync()
    print("working jugad")