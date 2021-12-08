import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/signIn/email_sign_in_form_bloc_based.dart';
import 'package:flutter_time_tracker_app/app/signIn/email_sign_in_form_change_notifier.dart';



class EmailSignInPage extends StatelessWidget 
{
    

 @override
  Widget build(BuildContext context) 
  {
    
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text
        (
        'Sign In',
        //textAlign: TextAlign.center,
        ),
        //elevation is the property of appBar which shows shadow of appBar
        elevation: 2.0,
      ),
      body:SingleChildScrollView
      (
        child: Padding
        (
          padding: EdgeInsets.all(16.0),
          child:Card
          (
      
            //child:EmailSignInFormBlocBased.create(context),
            child:EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    ); 
  }
  }