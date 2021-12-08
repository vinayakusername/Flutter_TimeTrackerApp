import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker_app/app/signIn/validators.dart';

//Test Cases to test the function  'isValid()' of NonEmptyStringValidator() class
void main()
{
  //Test case for checking non empty string 
  test('Non Empty String', ()
  {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true);
  });

  // Test case for checking empty string
  test('Empty String',()
  {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''),false);
  });

  //Test case for checking null string
  test('Null String',()
  {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null),false);
  });
}