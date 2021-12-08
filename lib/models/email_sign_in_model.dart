import 'package:flutter_time_tracker_app/app/signIn/validators.dart';



//It is class which used to represent a fixed number of constant values
enum EmailSignInFormType 
{
  signIn,
  register
}

//Here EmailAndPasswordValidator is a mixin class and extends using 'with' keyword
class EmailSignInModel with EmailAndPasswordValidator
{
  EmailSignInModel
  ({
    this.email = '', 
    this.password ='', 
    this.formType = EmailSignInFormType.signIn, 
    this.isLoading = false, 
    this.submitted = false
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

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

  EmailSignInModel copyWith
  ({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted
  })
  {
    return EmailSignInModel
    (
      /*
        '??' double question mark means here is that it will return value to the left if it is not null
        or if the returned value is null then it will store it in right hand side.
       */
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted
    );
  }
}