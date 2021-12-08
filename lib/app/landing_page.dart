import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/home_page.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/jobs_page.dart';
import 'package:flutter_time_tracker_app/app/signIn/sign_in_page.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:flutter_time_tracker_app/services/database.dart';
import 'package:provider/provider.dart';

//This class is created to maintain the state(LogIn or LogOut) of user
class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) 
  {
     final auth = Provider.of<AuthBase>(context,listen: false);
     return StreamBuilder<User>
     (
       stream: auth.authStateChanges(),
       builder: (context,snapshot)
       {
         if(snapshot.connectionState==ConnectionState.active)
         {
           final User user = snapshot.data;
           if(user==null)
             {
               return SignInPage.create(context);
             }

          /*
          Below provider will provide 'userId' to 'FirestoreDatabase' class and it is of type 'Database'
           */  
           return Provider<Database>
           (
             create: (_)=> FirestoreDatabase(uid: user.uid),
             child: HomePage(),
             //child: JobsPage()
           );
                
                  
              
         }

         return Scaffold
         (
           body: Center
           (
             child: CircularProgressIndicator(),
           ),
         );
       }
     );

   
  }
}