import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Here showAlertDialog method is created to create custom alertDialog to show messages to user
Future<bool> showAlertDialog
(
  BuildContext context,
  {
    @required String title,
    @required String content,
    String cancelActionText,
    @required String defaultActionText
  }
)
{
  //If-block will be executed when Platform is not IOS. It will build alert dialog for android platforms
   if(!Platform.isIOS)
   {
    return showDialog
     (
       context: context,
       /*
       if the value barrierDismissible is true than alert dailog will dismiss when tap on the screen or
       by taping on back button of the phone screen. But if its value is false then alert dialog will not dismiss
       if you tap on screen but whereas if you tap on back button of screen it(Alert Dialog) will dismiss.
        */ 
       barrierDismissible: false,
       builder: (context)=> AlertDialog
       (
         title: Text(title),
         content: Text(content),
         actions: 
         [
           if(cancelActionText!=null)
           ElevatedButton
           (
             onPressed: ()=>Navigator.of(context).pop(false), 
             child: Text(cancelActionText)
           ),
           
           ElevatedButton
           (
             onPressed:()=>Navigator.of(context).pop(true), 
             child: Text(defaultActionText)
           )
         ],
       ),
     );
   }
   //Here CupertinoDialog is used show alert dialog box for IOS devices.
   return showCupertinoDialog
     (
       context: context, 
       builder: (context)=> CupertinoAlertDialog
       (
         title: Text(title),
         content: Text(content),
         actions: 
         [
           if(cancelActionText!=null)
           CupertinoDialogAction
           (
             child: Text(cancelActionText),
             onPressed: ()=>Navigator.of(context).pop(false),
           ),
           CupertinoDialogAction
           (
             child:Text(defaultActionText),
             onPressed: ()=> Navigator.of(context).pop(true),
           )
               
         ],
       ),
     );
}