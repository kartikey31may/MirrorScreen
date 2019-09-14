import os
from flask import Flask, request, redirect, url_for, render_template, send_from_directory, Response, jsonify
from werkzeug.utils import secure_filename
import requests
import json
import cv2
from tool import Tool

UPLOAD_FOLDER = os.path.dirname(os.path.abspath(__file__)) + '/uploads/'
UPLOAD_FOLDER_LIVE = os.path.dirname(os.path.abspath(__file__)) + '/live/'
DOWNLOAD_FOLDER = os.path.dirname(os.path.abspath(__file__)) + '/downloads/'
ALLOWED_EXTENSIONS = {'mp4', 'jpg', 'mpeg', 'png', 'jpeg'}

app = Flask(__name__, static_url_path="/static")
DIR_PATH = os.path.dirname(os.path.realpath(__file__))

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['UPLOAD_FOLDER_LIVE'] = UPLOAD_FOLDER

app.config['DOWNLOAD_FOLDER'] = DOWNLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024


def allowed_file(filename):
   return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/uploads', methods=['GET'])
def live():
  data = {'status':'ERROR'}
  if request.method == 'GET':
    obj = Tool()
    files = obj.returnListUploads()

    video = []
    picture = []
    for i in files:
      if ".jpg" in i or ".png" in i or ".jpeg" in i:
        picture.append(i)
      elif ".mp4" in i or ".mpeg" in i:
        video.append(i)

    data = {}
    data['status'] = 'OK'
    data['video'] = video
    data['picture'] = picture

  return json.dumps(data)

@app.route('/uploads/<filename>')
def uploaded_file(filename):
   return send_from_directory(app.config['UPLOAD_FOLDER'], filename, as_attachment=True)

@app.route('/uploads_live/<filename>')
def uploaded_file_live(filename):
   return send_from_directory(app.config['UPLOAD_FOLDER_LIVE'], filename, as_attachment=True)

@app.route('/', methods=['GET', 'POST'])
def index():
   if request.method == 'POST':
       if 'file' not in request.files:
           print('No file attached in request')
           return redirect(request.url)
       file = request.files['file']

       if file.filename == '':
           print('No file selected')
           return redirect(request.url)

       if file and allowed_file(file.filename):
           filename = secure_filename(file.filename)
           file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
           return redirect(url_for('uploaded_file', filename=filename))

   return render_template('index.html')



if __name__ == '__main__':
    app.run(debug=True)
