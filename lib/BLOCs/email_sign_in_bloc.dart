import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_time_tracker_app/models/email_sign_in_model.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:rxdart/rxdart.dart';

class EmailSignInBloc
{
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  /* 
  //instance variable of stream controller
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  //Below statement will take inputs from _modelController
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();
  */
  

  /*
  BehaviorSubject is a streamController of RxDart which provides additional functionality to the dart stream.
  It will remember only last item added to streamController which is called 'subject'.
  seeded is used to provide initial value to the behaviorSubject StreamContoller of RxDart. 
  */
  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;

  void dispose()
  {
    _modelSubject.close();
    //_modelController.close();
  }

 Future<void> submit() async
  {
    updateWith
    (
      submitted: true,
      isLoading: true
    );
    try
    {
     
     if(_model.formType == EmailSignInFormType.signIn)
     {
       await auth.signInWithEmailAndPassword(_model.email, _model.password);
     }
     else 
     {
       await auth.createUserWithEmailAndPassword(_model.email, _model.password);
     }
    
    }catch(e)
     {
       updateWith(isLoading: false);
       rethrow;  
     } 
     
    
  }

  void toggleFormType()
  {
   final formType =_model.formType == EmailSignInFormType.signIn 
                                      ? EmailSignInFormType.register 
                                      : EmailSignInFormType.signIn;
  updateWith
    (
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }


  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith
  ({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted
  })
  {
    //update model
    //_modelSubject is a reference variable of BehaviorSubject which is RxDart streamController.
    _modelSubject.value = _model.copyWith
                         (
                            email: email,
                            password: password,
                            formType: formType,
                            isLoading: isLoading,
                            submitted: submitted
                          );
     
    /*
    Below code written for StreamController of Dart. 
    _model = _model.copyWith
    (
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );
    // add updated model to _model controller
      _modelController.add(_model);  
   */
  }
}