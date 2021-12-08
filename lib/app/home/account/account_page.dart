import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/common_widgets/avatar.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget 
{
  const AccountPage({ Key key }) : super(key: key);


  //Global Accessing FirebaseAuth Service to use Authentication service using singleton object which is 'instance'
  Future<void>_signOut(BuildContext context) async
  {
    
    try
    {
     final auth = Provider.of<AuthBase>(context,listen: false); 
     await auth.signOut();
    }catch(e)
    {
      print(e.toString());
    }
  }

//Below method is written for doing logOut from application.
  Future<void> _confirmSignOut(BuildContext context) async
  {
    final didRequestSignOut = await showAlertDialog
     (
       context, 
       title: 'LogOut', 
       content: 'Are you sure that you want to logout?',
       cancelActionText: 'Cancel', 
       defaultActionText: 'LogOut'
       
     );

    if(didRequestSignOut == true)
     {
       _signOut(context);
     }

  }


  @override
  Widget build(BuildContext context) 
  {
    final auth = Provider.of<AuthBase>(context,listen: false);

    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Acount'),
        actions: 
        [
          FlatButton
          (
             child: Text
                    (
                      'LogOut',
                      style: TextStyle
                      (
                        color: Colors.white,
                        fontSize: 18.0
                      ),
                    ) ,
            onPressed: ()=> _confirmSignOut(context),
           
          )
        ],

        bottom: PreferredSize
               (
                 preferredSize: Size.fromHeight(130),
                 child: _buildUserInfo(auth.currentUser),
               ),
      ),
    );
  }

  Widget _buildUserInfo(User user)
  {
    return Column(
      children: 
      [
        Avatar
        (
          photoUrl: user.photoURL,
          radius: 50,
          
        ),
        SizedBox(height:8.0),
        if(user.displayName != null)
        Text
        (
          user.displayName,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8.0,)
      ],
    );
  }
}