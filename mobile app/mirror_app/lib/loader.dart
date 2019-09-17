import 'dart:math';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation_rotation;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;

  final double initialRadius = 30.0;

  double radius = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation_radius_in = Tween<double>(
      begin: 1.0,
      end: 0.0
    ).animate(CurvedAnimation(parent: animationController,
        curve: Interval(
      0.75, 1.0, curve: Curves.elasticIn
    )));

    animation_radius_out = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(parent: animationController, curve: Interval(
        0.0, 0.25, curve: Curves.elasticOut
    )));

    animation_rotation = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(parent: animationController, curve: Interval(
        0.0, 1.0, curve: Curves.linear
    )));


    animationController.addListener((){
      setState(() {
        if(animationController.value >= 0.75 && animationController.value <= 1.0){
          radius=animation_radius_in.value*initialRadius;
        }else if(animationController.value >= 0.0 && animationController.value <= 0.25){
          radius=animation_radius_out.value*initialRadius;
        }
      });
    });

    animationController.repeat();
    //animationController.dispose();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation,
          child: Stack(
            children: <Widget>[
              Dot(
                radius: 30.0,
                color: Colors.black12,
              ),

              Transform.translate(
                offset: Offset(radius * cos(pi/4), radius * sin(pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.blueGrey,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(2*pi/4), radius * sin(2*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.blue,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(3*pi/4), radius * sin(3*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.indigo,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(4*pi/4), radius * sin(4*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.green,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(5*pi/4), radius * sin(5*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.yellow,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(6*pi/4), radius * sin(6*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.orange,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(7*pi/4), radius * sin(7*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.red,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(2*pi), radius * sin(2*pi)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: this.radius,
      height: this.radius,
      decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
    ));
  }
}
