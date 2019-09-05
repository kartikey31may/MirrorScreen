import os
from flask import Flask, request, redirect, url_for, render_template, send_from_directory
from werkzeug.utils import secure_filename
import cv2

UPLOAD_FOLDER = os.path.dirname(os.path.abspath(__file__)) + '/uploads/'
UPLOAD_FOLDER_LIVE = os.path.dirname(os.path.abspath(__file__)) + '/live/'
DOWNLOAD_FOLDER = os.path.dirname(os.path.abspath(__file__)) + '/downloads/'
ALLOWED_EXTENSIONS = {'mp4'}

app = Flask(__name__, static_url_path="/static")
DIR_PATH = os.path.dirname(os.path.realpath(__file__))

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['UPLOAD_FOLDER_LIVE'] = UPLOAD_FOLDER

app.config['DOWNLOAD_FOLDER'] = DOWNLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024


def allowed_file(filename):
   return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def gen(path=app.config['UPLOAD_FOLDER_LIVE']):
	path += "//" + os.listdir(path)[0]
	cap = cv2.VideoCapture(path)

    while True:
        ret ,frame = cap.read()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(gen(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/uploads/<filename>')
def uploaded_file(filename):
   return send_from_directory(app.config['UPLOAD_FOLDER'], filename, as_attachment=True)

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

@app.route('/live', methods=['GET', 'POST'])
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
           file.save(os.path.join(app.config['UPLOAD_FOLDER_LIVE'], filename))
           return redirect(url_for('uploaded_file', filename=filename))

   return render_template('index.html')

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
