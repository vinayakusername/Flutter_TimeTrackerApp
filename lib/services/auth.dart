import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
 This is abstract class which contains only method and variable declaration and it doesn't have method body
 Importance of this abstract class we can use this properties and method in multiple clasess by overriding it.
*/
abstract class AuthBase
{
   User get currentUser;
   Stream<User> authStateChanges();
   Future <User> signInAnonymously();
   Future<User> signInWithEmailAndPassword(String email,String password);
   Future<User> createUserWithEmailAndPassword(String email, String password);
   Future<User> signInWithGoogle();
   Future<User> signInWithFacebbok();
   Future <void> signOut();
}

class Auth implements AuthBase
{
  /*Intializing FirebaseAuth.instance to user define private variable '_firebaseAuth'*/
  final _firebaseAuth = FirebaseAuth.instance; 

  /*
  Below statement is used to notifies about the changes to the user's sign-in state(such as sign-in or sign-out)
  using stream concept for state management. 
  */
  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();


  /* 
  FirebaseAuth.instance.currentUser will return currentUser and it will assign to currentUser variable
  using getter method 
  */
  @override
  User get currentUser => _firebaseAuth.currentUser;

  /*Below Method is cretaed so that user can signInAnonymously */
  @override
  Future <User> signInAnonymously() async
  {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  /*Below method is created so that user can do signIn through email and password */
  @override
  Future<User> signInWithEmailAndPassword(String email,String password) async
  {
      final userCredential = await _firebaseAuth.signInWithCredential
      (
        EmailAuthProvider.credential(email: email, password: password)
      );
      return userCredential.user;
  }

   /*Below method is created so that user can do signUp through email and password */
  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async
  {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword
    (
      email: email, 
      password: password
    );
    return userCredential.user;
  }


  /*Below method is created so that user can signIn through google account*/
  @override
  Future<User> signInWithGoogle() async
  {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if(googleUser !=null)
    {
      final googleAuth = await googleUser.authentication;
      if(googleAuth.idToken!=null)
      {
        final userCredentials = await _firebaseAuth.signInWithCredential
                                                    (
                                                      GoogleAuthProvider.credential
                                                                         (
                                                                           idToken: googleAuth.idToken,
                                                                           accessToken: googleAuth.accessToken
                                                                         )
                                                    );
       return userCredentials.user;
      }
       else
       {
          throw FirebaseAuthException
           (
              code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
              message: 'Missing Google Id Token'
          );
       }
    }
    else
    {
      throw FirebaseAuthException
        (
          code: 'ERROR_ABORTED_BY_USER',
          message: 'SignIn Aborted by User'
        );
    }
  }

   /*Below method is created so that user can signIn through facebook account */
   @override
   Future<User> signInWithFacebbok() async 
   {
     final fb = FacebookLogin();
     final response = await fb.logIn(permissions: 
                                  [
                                     FacebookPermission.publicProfile,
                                     FacebookPermission.email
                                  ]);

     switch(response.status)
     {
       case FacebookLoginStatus.success:
            final accessToken = response.accessToken;
            final userCredential = await _firebaseAuth.signInWithCredential
                                   (
                                     FacebookAuthProvider.credential(accessToken.token)
                                   );
            return userCredential.user;

      case FacebookLoginStatus.cancel:
           throw FirebaseAuthException
           (
             code: 'ERROR_ABORTED_BY_USER',
             message: 'SignIn Aborted by User'
           );
      case FacebookLoginStatus.error:
           throw FirebaseAuthException
           (
             code: 'ERROR_FACEBOOK_LOGIN_FAILED',
             message: response.error.developerMessage
           );
      default: UnimplementedError();
     }
   } 


  /*Below method is used for signOut functionality */
  @override
  Future <void> signOut() async
  {
     final googleSignIn = GoogleSignIn();
     await googleSignIn.signOut();
     final facebookLogin = FacebookLogin();
     await facebookLogin.logOut();
     await _firebaseAuth.signOut();
  }
}