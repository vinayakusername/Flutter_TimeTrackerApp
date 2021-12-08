import 'package:flutter/material.dart';
import'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker_app/common_widgets/custom_elevated_button.dart';

void main()
{
   testWidgets('OnPressed Callback Test', (WidgetTester tester)async
   {
     var pressed = false;
     /*
       'testWidgets(description,(WidgetTester tester)aysnc{})' function is used to write test cases for widgets
       Using 'WidgetTester' we can build and interact with widgets in test environment with the help of methods provide 
       by widgetTester like pumpWidget etc.
       MaterialApp is a ancestor widget of CustomElevatedButton() widget.
      */
     await tester.pumpWidget(
       MaterialApp(
         home:CustomElevatedButton
         (
           child: Text('Tap on me'),
           onPressed: () => pressed = true,
         )
         ));

     /*
       find.byType() it will find widget by type. 
     */
     final button = find.byType(ElevatedButton);
     expect(button, findsOneWidget);
     expect(find.byType(FlatButton),findsNothing);
     expect(find.text('Tap on me'), findsOneWidget);

    // To Test widget callbacks  
     await tester.tap(button);
     expect(pressed, true);
   });
}