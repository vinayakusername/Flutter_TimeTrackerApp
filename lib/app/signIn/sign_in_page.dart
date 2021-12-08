
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/signIn/email_sign_in_page.dart';
import 'package:flutter_time_tracker_app/app/signIn/sign_in_button.dart';
import 'package:flutter_time_tracker_app/app/signIn/sign_in_manager.dart';
import 'package:flutter_time_tracker_app/app/signIn/social_sign_in_button.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget 
{
   SignInPage({@required this.manager,@required this.isLoading});
   final SignInManager manager;
   final bool isLoading;
   /*
    Below statements are written to make provider as parent class of signInBloc and signInPage 
    */
   static Widget create(BuildContext context)
   {
     final auth = Provider.of<AuthBase>(context,listen: false);
     return ChangeNotifierProvider<ValueNotifier<bool>>
     (
       
       create: (_)=>ValueNotifier<bool>(false),//passing 'false' as a initial value to valueNotifier
       /*
       Below consumer will hold changeNotifierProvider<ValueNotifier<bool>> and Provider<SignInBloc> together
       */
       child: Consumer<ValueNotifier<bool>>
       (
         builder: (_,isLoading,__)=> Provider<SignInManager>
         (
           create: (_)=>SignInManager(auth: auth,isLoading: isLoading),
           /*
            consumer is a generic type widget of provider and it has one property called builder(Anonynoums function) 
            which takes three parameter 1. context, 2. BLOC instance 3. one argument.
            '_' underscore as a argument used when we are not using arguments in function.
            */
           child: Consumer<SignInManager>
             (
               builder:(_,manager,__) => SignInPage(manager: manager,isLoading: isLoading.value,)
             ),
         ),
       ),
     );
   }
 
 void _showSignInError(BuildContext context,Exception exception)
 {
   if(exception is FirebaseException && exception.code == 'ERROR_ABORTED_BY_USER')
   {
     return;
   }
   
   showExceptionAlertDialog
   (
     context, 
     title: 'Sign In Failed', 
     exception: exception
  );
 }

 Future <void> _signInAnonymously(BuildContext context) async
  {

    try
    {
      
      await manager.signInAnonymously(); 
    }on Exception catch(e)
    {
      _showSignInError(context,e);
  
    }
  }

Future <void> _signInWithGoogle(BuildContext context) async
  {
  
    try
    {
     
      await manager.signInWithGoogle();
      
    }on Exception catch(e)
    {
      _showSignInError(context,e);
  
    }
  }

Future <void> _signInWithFacebook(BuildContext context) async
  {
  
    try
    {
      
      await manager.signInWithFacebbok();
      
    }on Exception catch(e)
    {
      _showSignInError(context, e);
    }
  }

void _signInWithEmail(BuildContext context)
{
  
  //Navigator is predefine widget which is used to navigate between widgets.
  //Navigator.of(context) tells that from signInPage widget we have to navigate to emailSignInPage widget.
  Navigator.of(context).push
  (
    MaterialPageRoute<void>
    (
      //fullScreenDialog will tells how widget should be present.
      //fullScreenDialog is a property of a MaterialPageRoute and it is used for swiping of widget
      //If the value of fullScreenDialog is true then widget(emailSignInPage) will sliding from bottom
      //of the screen with close icon and if its value is false then widget will sliding from right hand side. 
      fullscreenDialog: true,
      builder: (context)=> EmailSignInPage(),
    ),
  );
}

  @override
  Widget build(BuildContext context) 
  {
    /*
    we have create provider object of type SignInBloc and it is because provider of signInBloc is parent widget
    for signInPage
     */
   
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text
        (
        'Time Tracker',
        //textAlign: TextAlign.center,
        ),
        //elevation is the property of appBar which shows shadow of appBar
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    ); 
  }

  Widget _buildContent(BuildContext context)
  {
    return  Padding
    (
         padding: const EdgeInsets.all(16.0),
       
          child: Column
                (
                  
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget> 
                  [
                    SizedBox
                    (
                      height:50.0,
                      child: _buildHeader()
                    ),
                    SizedBox(height:48.0),
                   
                    SocialSignInButton
                    (
                      assetName: 'images/google-logo.png',
                      text: 'Sign in with Google',
                      textColor: Colors.black,
                      border_Radius:20.0,
                      color: Colors.white,
                      onPressed: isLoading ? null : ()=> _signInWithGoogle(context),
          
                    ), 
                    SizedBox(height: 10.0,),
                    SocialSignInButton
                    (
                      assetName: 'images/facebook-logo.png',
                      text: 'Sign in with Facebook',
                      textColor: Colors.white,
                      border_Radius:20.0,
                      color: Color(0xFF334D92),
                      onPressed: isLoading ? null: ()=> _signInWithFacebook(context),
          
                    ),
                    SizedBox(height: 10.0,),
                    SignInButton
                    (
                      text: 'Sign in with Email',
                      textColor: Colors.white,
                      border_Radius:20.0,
                      color: Colors.teal,
                      onPressed: isLoading ? null : ()=> _signInWithEmail(context),
          
                    ),
                    SizedBox(height: 10.0,),
                    Text('or',style: TextStyle(fontSize: 15.0,color: Colors.black87),textAlign: TextAlign.center,),
                    SizedBox(height: 10.0,),
                     SignInButton
                    (
                      text: 'Continue with Anonymous ',
                      textColor: Colors.black87,
                      border_Radius:20.0,
                      color: Color(0xFF88C781),
                      onPressed: isLoading ? null : ()=> _signInAnonymously(context),
          
                    ),
                   
                  ],
                ),

    );
  }

  Widget _buildHeader()
  {
    if(isLoading)
    {
      return Center
      (
        child:CircularProgressIndicator()
      );
    }
    return  Text
              (
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle
                (
                  fontSize: 35.0,
                  fontWeight: FontWeight.w600,
                              
                ),
              );
  }
}