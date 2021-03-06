/*
 * Basic widget functionality, testing all widgets to ensure that the amount of
 * objects and widgets that they return are correct.
 * 
 */

import 'dart:ffi';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:famnet/widgets/groups.dart';
import 'package:famnet/widgets/todo.dart';
import 'package:famnet/widgets/add_group.dart';
import 'package:famnet/widgets/polls/form.dart';
import '../lib/widgets/polls/poll_content.dart';
import 'package:famnet/widgets/polls/multi_form.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/first_screen.dart';
import '../lib/login_page.dart';
import '../lib/widgets/calendar.dart';
import '../lib/sign_in.dart';

//Future Testing Imports :
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mockito/mockito.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';



Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
void main() {


  testWidgets('Login test', (WidgetTester tester) async {
  
    await tester.pumpWidget(buildTestableWidget(LoginPage()));
    //We're on the login page. There should be an outline button around an image
    //And an image for FamNet's logo.
    expect(find.byType(OutlineButton), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    
    //We click on the button taking us to the First Screen.
    await tester.tap(find.byType(OutlineButton));

    //This will be the "Sign in with google text"
    expect(find.byType(Text), findsOneWidget);

  });
  testWidgets('First Screen Test', (WidgetTester tester) async {

    // This section is for testing the authorization, but requires an anonymous
    // sign in that we don't have set up yet.

    // final googleSignIn = MockGoogleSignIn();
    // final signinAccount = await googleSignIn.signIn();
    // final googleAuth = await signinAccount.authentication;
    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    name = "JT";
    email = "test@testies.test";

    await tester.pumpWidget(buildTestableWidget(FirstScreen()));    
   
    expect(find.byType(Text), findsWidgets);
    expect(find.byKey(new Key("name")), findsOneWidget);
    expect(find.byKey(new Key("email")), findsOneWidget);
    expect(find.byKey(new Key("signout")), findsOneWidget);

  });

  //Tests that the calendar function is being called correctly.
  testWidgets('Calendar Call Test', (WidgetTester tester) async{

    await tester.pumpWidget(buildTestableWidget(Calendar()));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byKey(new Key("calendar")), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('todo call test', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget(TodoList()));
    expect(find.byKey(new Key("todo_list")), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byKey(new Key("add_task")), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('groups call test.', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget(Groups()));
    expect(find.byKey(new Key("safearea")), findsOneWidget);
    //await tester.enterText(find.byType(TextField), 'TEST');
    await tester.tap(find.byKey(new Key("adab")));
    expect(find.byType(Container), findsNWidgets(5));
  });

  testWidgets('add_group call test', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget(AddGroups()));
    expect(find.byType(AppBar), findsOneWidget);
  });
  testWidgets('poll test.', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget(PollApp()));
    expect(find.byType(AppBar), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    expect(find.byType(Text), findsNWidgets(4));
    Poll testPoll;
    // PollForm pfTest(testPoll);
  });

  testWidgets('multiform test.', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(MultiForm()));
    expect(find.byType(AppBar), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
  });

  // testWidgets('poll form test', (WidgetTester tester) async{
  //   Poll testpoll;
  //   await tester.pumpWidget(buildTestableWidget(PollForm()));
  //   expect(find.byType(TextFormField), findsNothing);
  // });
  testWidgets('find group call test.', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget(Groups()));
    await tester.pump(Duration(milliseconds:500));
    expect(find.byType(RaisedButton), findsOneWidget); //Find the create group button.
    await tester.pump(Duration(milliseconds:500));
    await tester.tap(find.byType(TextField)); //Tap the text field.
    await tester.pump(Duration(milliseconds:500));
    // await tester.tap(find.byElementType(Text));
    // expect(find.byType(Container), findsWidgets);
    await tester.tap(find.byType(IconButton)); //Test back button.
    
  });

  testWidgets('Searchbar tester.', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget(Home()));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byKey(new Key("safearea")), findsOneWidget);
    await tester.tap(find.byType(TextField));
    // await tester.enterText(find.byType(TextField), 'TEST\n');
    await tester.tap(find.byKey(new Key("searchbar")));
    await tester.pump(Duration(milliseconds:5000));
    await tester.enterText(find.byKey(new Key("searchbar")), "TEST");
    await tester.pump(Duration(milliseconds:5000));
  });

  // testWidgets('details tester.', (WidgetTester tester) async{
  //   //await tester.pumpWidget(buildTestableWidget(Detail()));
  //   //expect(find.byType(AppBar), findsOneWidget);
  // });
}
