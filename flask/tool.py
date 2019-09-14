import os
import json

class Tool():

	def __init__(self):
		self.pathLive = os.getcwd() + "\\live"
		self.pathUploads = os.getcwd() + "\\uploads"


	def returnListLive(self):
		return os.listdir(self.pathLive)

	def returnListUploads(self):
		return os.listdir(self.pathUploads)

	def returnJsonLive(self):
		List = returnListLive()
		temporaryList = []
		temporaryDict = {}

		for i in List:
			name = i
			count = len(os.listdir(self.pathLive+"\\"+name))
			temporaryDict["name"] = name
			temporaryDict["count"] = count
			temporaryList.append(temporaryDict)
			temporaryDict={}

		return json.dumps(temporaryList)


	def returnJsonUploads(self):
		List = returnJsonUploads()
		tempraryList = []
		temporaryDict = []
		for i in List:
			temporaryDict["name"] = i
			tempraryList.append(temporaryDict)
			temporaryDict={}
			
		return json.dumps(temporaryList)

	