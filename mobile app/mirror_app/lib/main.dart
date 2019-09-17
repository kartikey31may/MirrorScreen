import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:mirror_app/chewie_list_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'loader.dart';
import 'tool.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mirror app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mirror App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool flagSync = false;
  bool flagInternet = false;
  var video = [];
  var file = [];
  int count = 0;
  bool state = false;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  VoidCallback listener;

  syncFiles() async {
    //videoPlayerController = null;
    await checkInternet();
    if (!flagInternet) {
      return null;
    }
    Tool obj = new Tool();
    setState(() {
      flagSync = true;
    });

    try {
      await obj.syncFiles(context);
      video = await obj.files();
      //createVideo();
    } catch (e) {
      setState(() {
        flagSync = false;
      });
    }
    setState(() {
      flagSync = false;
    });
  }

  _onclickfloatingbutton() async {
    //obj.files();
    getFiles();
    debugPrint("Floating Action button");
    PermissionStatus ps = PermissionStatus.unknown;
    final Future<PermissionStatus> statusFuture =
        PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    statusFuture.then((PermissionStatus status) async {
      ps = status;

      if (ps == PermissionStatus.denied) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        PermissionStatus _status = permissions[PermissionGroup.storage];

        if (_status == PermissionStatus.denied) {
          PermissionHandler().openAppSettings().then((bool hasOpened) =>
              debugPrint('App Settings opened: ' + hasOpened.toString()));
        } else if (_status == PermissionStatus.granted) {
          syncFiles();
        }
      } else if (ps == PermissionStatus.granted) {
        syncFiles();
      }
    });
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          flagInternet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        flagInternet = false;
      });
    }
    return flagInternet;
  }

 getFiles() async {
   Tool obj; 
   file = obj.files();
 }

  @override
  void initState(){
    super.initState();
    getFiles();
    // if (flagInternet) {
    //   syncFiles();
    //   //createVideo();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: (!flagSync)?(video.length>0)
            ?  ListView.builder(itemCount: video.length,itemBuilder: (BuildContext context, int index) {
              return ChewieListItem(videoPlayerController: VideoPlayerController.file(video[index]),);
            },)
            : Text("Internet not connected or on a proxy network")
            :Loader()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onclickfloatingbutton,
        child: Icon(Icons.refresh),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getVideoValue() {
    int temp = count;
    count+=1;
    debugPrint("test1"+temp.toString());
    if(count>=video.length)
      count=0;
    return video[temp];
  }

  nextVideo(){

    if (video.length != 0) {
      debugPrint("testtest"+getVideoValue().toString());
     if(_controller!=null){
       if(_controller.value.isPlaying){
         _controller.pause();
         _controller.dispose();
         _controller = null;

         setState(() {

          state=false; 
          _controller =  VideoPlayerController.file(getVideoValue())
          ..setVolume(1.0)
          ..initialize()
          ..play();

          state = true;
         });
       }
     }else{
     setState(() {

          state=false; 
          _controller =  VideoPlayerController.file(video[0])
          ..setVolume(1.0)
          ..initialize()
          ..play();

          state = true;
         });
     }
    }

  }

   createVideo() {

    if (video.length != 0) {
      debugPrint("testtest"+getVideoValue().toString());
       setState(() {
        state = false;
 _controller =  VideoPlayerController.file(video[0])
          ..addListener(listener)
          ..setVolume(1.0)
          ..initialize()
          ..play();

          state = true;
      });
    }
    
  }
}
