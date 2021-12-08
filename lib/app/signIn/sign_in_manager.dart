import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';

class SignInManager
{
  SignInManager({@required this.auth,@required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

 
  /*
   _signIn is a private method of signInBloc of type 'User' and it takes Function as a parameter
   of type User.
   note: We can pass function as an input argument to other function
   */
  Future<User> _signIn(Future<User> Function() signInMethod) async
  {
     try
     {
       isLoading.value = true;
       return await signInMethod();
     }catch(e)
     {
       //Below statement will set loading to be false when signIn fails.
        isLoading.value = false;
       //rethrow will forward the exception upto the calling code.
        rethrow;
     }
  }

   //Here we are passsing signInAnonymously function as parameter to _signIn method.
   Future <User> signInAnonymously() async => await _signIn(auth.signInAnonymously);

   //Here we are passsing signInWithGoogle function as parameter to _signIn method.
   Future<User> signInWithGoogle() async => await _signIn(() => auth.signInWithGoogle());
   
   //Here we are passsing signInWithFacebook function as parameter to _signIn method.
   Future<User> signInWithFacebbok() async => await _signIn(() => auth.signInWithFacebbok());
   
}