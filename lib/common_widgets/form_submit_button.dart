
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton
{
   FormSubmitButton
   ({
      @required String text,
      VoidCallback onPressed                 
    }):super
       (
          child:Text
          (
            text,
            style: TextStyle(color: Colors.white,fontSize:20.0),
          ),
          height: 44.0,
          border_Radius: 30,
          color: Colors.purple,
          onPressed: onPressed
       );
}