
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/BLOCs/email_sign_in_bloc.dart';
import 'package:flutter_time_tracker_app/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker_app/models/email_sign_in_model.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';





class EmailSignInFormBlocBased extends StatefulWidget 
{
  //We have initialized the bloc object through constructor
  EmailSignInFormBlocBased({@required this.bloc});
  //Declared instance variable of bloc
  EmailSignInBloc bloc;

 //below method will retrun provider
  static Widget create(BuildContext context)
  {
    //Creating a refernce variable of type authBase using provider and passing from parent to child widget 
    final auth = Provider.of<AuthBase>(context,listen: false);
    return Provider<EmailSignInBloc>
    (
      create:(_)=>EmailSignInBloc(auth: auth),
      /*
      consumer hold the provider and widget together and it is also widget of provider
      and it has one property called builder which three parameter 1. context,2. bloc variable
      3. other parameter
      */ 
      child: Consumer<EmailSignInBloc>
      (
        builder: (_,bloc,__)=> EmailSignInFormBlocBased(bloc: bloc)
      ),
      dispose:(_,bloc) =>bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> 
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
   
    try
    {
      //we use 'widget.' to use instance variable outside the state class 'EmailSignInFormBlocBasedState'       
       await widget.bloc.submit();
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
    
    
  }

void _emailEditingComplete(EmailSignInModel model)
{
   //Below line of code is written to ensure that cursor will not move to the next field untill text is entered
   final newFcous = model.emailValidator.isValid(model.email) ? _passwordFocusNode : _emailFocusNode;
  //FocusScope will focus on password textField after writing email as a input in email textField.
  //This property will improves the User Experience
  FocusScope.of(context).requestFocus(newFcous);
}

//This method is used to change value of the Text shown on button
  void _toggleFormType()
  {
   
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }


  List<Widget> _buildChildren(EmailSignInModel model)
  {
                                    
    return 
    [
        //TextField widget is used to create textField
        
        _buildEmailTextField(model),

        SizedBox(height:10.0),

        _buildPasswordTextField(model),

         SizedBox(height:10.0),

         FormSubmitButton
         (
           text: model.primaryButtonText,
           onPressed: model.canSubmit ? _submit : null,
         ),

         SizedBox(height:10.0),

         FormSubmitButton
         (
           text: model.secondaryButtonText,
           onPressed: !model.isLoading ? _toggleFormType : null,
         )

         
         
    ];
  }
  
TextField _buildEmailTextField(EmailSignInModel model)
{
  
  return  TextField
         (
           controller: _emailController,
           focusNode: _emailFocusNode,
           decoration: InputDecoration
           (
             labelText: 'Email',
             hintText: 'test@gmail.com',
             errorText: model.emailErrorText,
             enabled: model.isLoading == false
           ),
           //Below three statements are used to configure the phone keyboard while giving input. 
           //This autocorrect property of TextField having false value will disable the suggestion from the keyboard.  
           autocorrect: false,
           //keyboard property of TextField with value emailAddress type it will show @ and .(dot) in phone keyboard.
           keyboardType: TextInputType.emailAddress,
           //textInputAction property will show 'next' text instead of 'done' text on button in phone keyboard. 
           textInputAction: TextInputAction.next,
           //onChanged :(email) method and widget.bloc.updateEmail method both have same signature
           //so we dont required to pass the argument.
           onChanged: widget.bloc.updateEmail,
           onEditingComplete: ()=> _emailEditingComplete(model),
         );
}

TextField _buildPasswordTextField(EmailSignInModel model)
{
  //bool showErrorText = model.submitted && !model.passwordValidator.isValid(model.password);
  return  TextField
         (
           controller: _passwordController,
           focusNode: _passwordFocusNode,
           decoration: InputDecoration
          (
             labelText: 'Password',
             errorText: model.passwordErrorText,
             enabled: model.isLoading == false
          ),
          //obscure property is used to hide the password.
          obscureText: true,
          //textInputAction property will show 'done' text instead of 'next' text on button in phone keyboard.
          textInputAction: TextInputAction.done,
          //onChanged :(password) method and widget.bloc.updatePassword method both have same signature
           //so we dont required to pass the argument.
          onChanged: widget.bloc.updatePassword,
          onEditingComplete: _submit,
         );
}



  @override
  Widget build(BuildContext context) 
  {
    return StreamBuilder(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context,snapshot)
      {
      final EmailSignInModel model = snapshot.data;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column
        (
          //It will expand the column vertically according to children widget. 
          //And MainAxisSize.max will take full screen.
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(model),
        ),
      );
      }
    );
  }
}

