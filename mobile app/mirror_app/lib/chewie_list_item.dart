import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const ChewieListItem({Key key, this.videoPlayerController, this.looping}) : super(key: key);

  

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {

  ChewieController _chewieController;

  @override
  void initState(){
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,

      errorBuilder: (context, errorMessage) {
        return Center(child: Text(
          errorMessage,
          style: TextStyle(color: Colors.white),
        ),);
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:Chewie(controller: _chewieController,));
  }

  @override
  void dispose(){
    super.dispose();

    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
