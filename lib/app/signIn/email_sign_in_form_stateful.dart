import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/signIn/validators.dart';
import 'package:flutter_time_tracker_app/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker_app/models/email_sign_in_model.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';




//Here EmailAndPasswordValidator is a mixin class and extends using 'with' keyword
class EmailSignInFormStateFul extends StatefulWidget with EmailAndPasswordValidator
{
 
  @override
  _EmailSignInFormStateFulState createState() => _EmailSignInFormStateFulState();
}

class _EmailSignInFormStateFulState extends State<EmailSignInFormStateFul> 
{

  //TextFieldController which controls the text being edited in textField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 

  /*
   FocusNode is used to highlight the textField when we move from one textField to
   another textFeild.

   When a text field is selected and accepting input, it is said to have “focus.”
   For example, say you have a search screen with a text field. When the user navigates to the search screen, 
   you can set the focus to the text field for the search term. 
   This allows the user to start typing as soon as the screen is visible, 
   without needing to manually tap the text field.
   */
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  //Below variable is created to disable the form till the authentication is in progress
  //and untill we get the response from firebase database
  bool _isLoading = false;

/*
Dispose() Method is used to dispose or remove objects from occupying memory that are
no longer needed when widgets are removed.
 */
@override
  void dispose()
  {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async
  {
    setState(() 
    {
       _submitted = true;
       _isLoading = true;  
    });
    try
    {
     final auth = Provider.of<AuthBase>(context,listen: false);
     if(_formType == EmailSignInFormType.signIn)
     {
       await auth.signInWithEmailAndPassword(_email, _password);
     }
     else 
     {
       await auth.createUserWithEmailAndPassword(_email, _password);
     }
    //Below statement is used to dismiss the Navigator  
    Navigator.of(context).pop(); 
    }on FirebaseAuthException catch(e)
     {
       showExceptionAlertDialog
       ( 
         context,
         title: 'Signed In Failed', 
         exception: e,
       );
     } 
     finally
     {
       setState(() {
         _isLoading = false;
       });
     }
    
  }

void _emailEditingComplete()
{
   //Below line of code is written to ensure that cursor will not move to the next field untill text is entered
   final newFcous = widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
  //FocusScope will focus on password textField after writing email as a input in email textField.
  //This property will improves the User Experience
  FocusScope.of(context).requestFocus(newFcous);
}

//This method is used to change value of the Text shown on button
  void _toggleFormType()
  {
    setState(() 
    {
        _submitted = false;
       _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.register :EmailSignInFormType.signIn;  
    });
    _emailController.clear();
    _passwordController.clear();
  }


  List<Widget> _buildChildren()
  {
    final primaryText = _formType == EmailSignInFormType.signIn ? 'SignIn' :'Create  an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'Have an account? SignIn';
    
    // variable is created of type boolean which is storing non null value.
    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password)
                                                                                             && !_isLoading;
                                   
    return 
    [
        //TextField widget is used to create textField
        
        _buildEmailTextField(),

        SizedBox(height:10.0),

        _buildPasswordTextField(),

         SizedBox(height:10.0),

         FormSubmitButton
         (
           text: primaryText,
           onPressed: submitEnabled ? _submit : null,
         ),

         SizedBox(height:10.0),

         FormSubmitButton
         (
           text: secondaryText,
           onPressed: !_isLoading ? _toggleFormType : null,
         )

         
         
    ];
  }
  
TextField _buildEmailTextField()
{
  bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
  return  TextField
         (
           controller: _emailController,
           focusNode: _emailFocusNode,
           decoration: InputDecoration
           (
             labelText: 'Email',
             hintText: 'test@gmail.com',
             errorText: showErrorText ? widget.invalidEmailErrorText : null,
             enabled: _isLoading == false
           ),
           //Below three statements are used to configure the phone keyboard while giving input. 
           //This autocorrect property of TextField having false value will disable the suggestion from the keyboard.  
           autocorrect: false,
           //keyboard property of TextField with value emailAddress type it will show @ and .(dot) in phone keyboard.
           keyboardType: TextInputType.emailAddress,
           //textInputAction property will show 'next' text instead of 'done' text on button in phone keyboard. 
           textInputAction: TextInputAction.next,
           onChanged: (email)=> _updateState(),
           onEditingComplete: _emailEditingComplete,
         );
}

TextField _buildPasswordTextField()
{
  bool showErrorText = _submitted && !widget.emailValidator.isValid(_password);
  return  TextField
         (
           controller: _passwordController,
           focusNode: _passwordFocusNode,
           decoration: InputDecoration
          (
             labelText: 'Password',
             errorText: showErrorText ? widget.invalidPasswordErrorText : null,
             enabled: _isLoading == false
          ),
          //obscure property is used to hide the password.
          obscureText: true,
          //textInputAction property will show 'done' text instead of 'next' text on button in phone keyboard.
          textInputAction: TextInputAction.done,
          onChanged: (password)=> _updateState(),
          onEditingComplete: _submit,
         );
}

//This method is declare to update the state of email and password field after giving single.
//Dont need to write any code in it because textEditingcontroller of email and password taking care of it. 
void _updateState()
{
   setState(() {});
} 

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column
      (
        //It will expand the column vertically according to children widget. 
        //And MainAxisSize.max will take full screen.
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}

