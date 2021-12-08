import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/common_widgets/custom_elevated_button.dart';

/*This customizable class is created for login buttons to do login without social networking account and 
this button doesn't contain Image widget.
*/
class SignInButton extends CustomElevatedButton
{
  SignInButton
  ({
    //required is used to specifiy that property must included while designing widget
     @required String text,
     Color color:Colors.black87,
     Color textColor:Colors.black87,
     double border_Radius:0.0,
     double buttonWidth:150,
     double buttonHeight:50,
     @required VoidCallback onPressed,
  }): assert(text!=null), //assert is used to stop the execution if condition is fasle and trace error early
  super
       (
         child: Text
                (
                  text,
                  style: TextStyle(fontSize: 15.0,color: textColor,fontWeight: FontWeight.w600),
                ),
         color: color,
         border_Radius: border_Radius,
         width: buttonWidth,
         height: buttonHeight,
         onPressed: onPressed
       );
}