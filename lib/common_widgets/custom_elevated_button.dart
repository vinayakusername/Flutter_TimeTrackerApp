
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  CustomElevatedButton
  ({
    @required this.child,
    @required this.color,
    this.border_Radius:0.0,
    this.width:0.0,
    this.height:0.0,
    @required this.onPressed
  });

  final Widget child;
  final Color color;
  final double border_Radius;
  final double width;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
     //elevatedButton is used to created simple buttons and it replaces raisedButton and flatButton
    return ElevatedButton
            (
                onPressed:onPressed, 
                child: child,
                               
                //style property is used to design a button
                style: ElevatedButton.styleFrom
                (
                  primary: color,
                  minimumSize: Size(width,height),
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.all
                                 (
                                   Radius.circular(border_Radius)
                                 )
                  ),
                  
                ),
              
            );
  }
}