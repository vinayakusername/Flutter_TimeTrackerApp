import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/common_widgets/custom_elevated_button.dart';

/*This customizable class is created for login buttons to do login through social networking account and 
this button  contain Image widget.
*/
class SocialSignInButton extends CustomElevatedButton
{
  SocialSignInButton
  ({
     //required is used to specifiy that property must included while designing widget
     @required String assetName,
     @required String text,
     Color color:Colors.black87,
     Color textColor:Colors.black87,
     double border_Radius:0.0,
     double buttonWidth:150,
     double buttonHeight:50,
     @required VoidCallback onPressed,
  }): assert(assetName!=null), //assert is used to stop the execution if condition is fasle and trace error early
      assert(text!=null),
  super
       (
         child: Row
                  (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>
                        [
                          Image.asset(assetName),
                          Text(text, style: TextStyle(fontSize: 15.0,color: textColor,fontWeight: FontWeight.w600),),
                          Opacity
                          (
                            opacity: 0.0,
                            child: Image.asset(assetName)
                          ),
                        ]
                  ),
         color: color,
         border_Radius: border_Radius,
         width: buttonWidth,
         height: buttonHeight,
         onPressed: onPressed
       );
}