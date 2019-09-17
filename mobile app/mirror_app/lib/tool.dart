import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class Tool {
  ProgressDialog pr;
  String url = "http://hitenjain88.pythonanywhere.com/uploads";
  double progressNumber=0.0;
  files() async {
    var root = await getExternalStorageDirectory();
    var files = await FileManager(root: root).walk().toList();

    List temp = List();
    for (var file in files) {
      temp.add(file.path);
    }
    //debugPrint(temp.toString());
    return files;
  }

  getJsonList() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var response = json.decode(res.body);

    var video = response['video'];
    //print(video);
    return video;
  }

  syncFiles(BuildContext context) async {
    var root = await getExternalStorageDirectory();
    //debugPrint(root.toString());
    var file = await files();
    //debugPrint("something is coming : "+file.toString());
    var video = await getJsonList();
    Dio dio = Dio();

    for (var i in video) {
      bool flag = true;
      var p = root.path;

      for (var j in file) {
        if (j.toString().contains(i.toString())) {
          // print("\n\n\n\n\n");
          // print(i);
          // print(j);
          flag = false;
        }
      }

      if (flag) {
        //debugPrint(i);
        try {
          var path = root.path + "/" + i.toString();
          //print(path+"\n\n\n");

          pr = new ProgressDialog(context,
              type: ProgressDialogType.Normal, isDismissible: true);
          
          pr.style(
              message: 'Downloading :\n'+i.toString(),
              borderRadius: 10.0,
              backgroundColor: Colors.white,
              progressWidget: CircularProgressIndicator(),
              elevation: 10.0,
              insetAnimCurve: Curves.easeInOut,
              progress: progressNumber,
              maxProgress: 100.0,
              progressTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600));
          pr.show();
          await dio.download(url + "/" + i.toString(), path,
              onReceiveProgress: (rec, total) {
            double t = rec / total * 100;
            progressNumber = t;
            

            //debugPrint("$t");
          });
         
        } catch (e) {
          print(e);
        }

         pr.dismiss();
      }
    }
  }
}
