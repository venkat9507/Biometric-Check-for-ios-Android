import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
final LocalAuthentication _localAuthentication = LocalAuthentication();
bool _canCheckBiometric = false;
String _authorizedorNot = "Not Authorized";
List<BiometricType> _availableBiometricType = List<BiometricType>();
Future<void> _checkBiometric()async{
  bool canCheckBiometric = false;
  try {
    canCheckBiometric = await _localAuthentication.canCheckBiometrics;
  } on PlatformException catch (e){
    print(e);
  }
  if(!mounted) return;
  setState(() {
      _canCheckBiometric = canCheckBiometric;
  });
}


  Future<void> _getListOfBiometricTypes()async{
    List<BiometricType> listOfBiometrics ;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
      _availableBiometricType = listOfBiometrics  ;
    });
  }

  Future<void> _authorizeNow()async{
   bool isAuthorized = false;
    try {
     isAuthorized =  await _localAuthentication.authenticateWithBiometrics(localizedReason: "please authenticate to complete the process",
      useErrorDialogs:  true,
        stickyAuth: true,
      );
    } on PlatformException catch (e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
     if(isAuthorized){
       _authorizedorNot = "Authorized";
     }
     else {
       _authorizedorNot = "Not Authorized";
     }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Biometric : $_canCheckBiometric"),
            RaisedButton(onPressed: _checkBiometric,
            child: Text("Check Biometric"),
            color: Colors.red,
            colorBrightness: Brightness.light,),
            Text("List of Biometric : ${_availableBiometricType.toString()}"),
            RaisedButton(onPressed: _getListOfBiometricTypes,
              child: Text("List of Biometric  types"),
              color: Colors.red,
              colorBrightness: Brightness.light,),
            Text("Authorized : ${_authorizedorNot}"),
            RaisedButton(onPressed: _authorizeNow,
              child: Text("Authorize now"),
              color: Colors.red,
              colorBrightness: Brightness.light,)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
