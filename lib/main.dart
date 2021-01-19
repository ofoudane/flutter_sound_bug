import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static MethodChannel _channel = new MethodChannel("com.dooboolab.example.native");

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<bool> _requestPermissions() {
    return Permission.microphone
        .request()
        .then((status) => status == PermissionStatus.granted)
        .catchError((err) => false);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Sound Background Bug"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: getTemporaryDirectory().then((p) => p.path + "/output.audio"),
                builder: (ctx, state) {
                  return state.connectionState == ConnectionState.done
                      ? RecorderPlaybackController(
                          child: SoundRecorderUI(Track(trackPath: state.data)),
                        )
                      : Container();
                },
              ),
              SizedBox(height: 20),
              FlatButton(
                onPressed: () {
                  _channel.invokeMethod("triggerBug");
                },
                color: Colors.blue,
                child: Text("Run Background service"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
