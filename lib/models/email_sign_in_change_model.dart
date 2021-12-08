import 'package:flutter/foundation.dart';
import 'package:flutter_time_tracker_app/app/signIn/validators.dart';
import 'package:flutter_time_tracker_app/models/email_sign_in_model.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';


//Here EmailAndPasswordValidator  and ChangeNotifier is used as a mixin class and extends using 'with' keyword.
class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier
{
  EmailSignInChangeModel
  ({
    @required this.auth,
    this.email = '', 
    this.password ='', 
    this.formType = EmailSignInFormType.signIn, 
    this.isLoading = false, 
    this.submitted = false
  });

   final AuthBase auth;
   String email;
   String password;
   EmailSignInFormType formType;
   bool isLoading;
   bool submitted;

  
   Future<void> submit() async
  {
    updateWith
    (
      submitted: true,
      isLoading: true
    );
    try
    {
     
     if(formType == EmailSignInFormType.signIn)
     {
       await auth.signInWithEmailAndPassword(email, password);
     }
     else 
     {
       await auth.createUserWithEmailAndPassword(email, password);
     }
    
    }catch(e)
     {
       updateWith(isLoading: false);
       rethrow;  
     } 
     
    
  }

  String get primaryButtonText
  {
    return formType == EmailSignInFormType.signIn 
                       ? 'SignIn' 
                       :'Create  an account';
  }

  String get secondaryButtonText
  {
    return formType == EmailSignInFormType.signIn 
                                            ? 'Need an account? Register' 
                                            : 'Have an account? SignIn';
  }

  bool get canSubmit
  {
     // variable is created of type boolean which is storing non null value.
    return emailValidator.isValid(email) 
                                 && passwordValidator.isValid(password)
                                 && !isLoading;
  }

  String get emailErrorText
  {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }


  String get passwordErrorText
  {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }
  
  void toggleFormType()
  {
   final formType =this.formType == EmailSignInFormType.signIn 
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
      /*
        '??' double question mark means here is that it will return value to the left if it is not null
        or if the returned value is null then it will store it in right hand side.
       */
      this.email= email ?? this.email;
      this.password= password ?? this.password;
      this.formType= formType ?? this.formType;
      this.isLoading= isLoading ?? this.isLoading;
      this.submitted= submitted ?? this.submitted;
      notifyListeners();
  }
}