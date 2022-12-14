import 'package:flutter/material.dart';
import 'simple_circular_progress_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Duration _bpmToDuration(int bpm) {
  return Duration(milliseconds: (60000 / bpm).round());
}

class _MyHomePageState extends State<MyHomePage> {
  int _bpm = 100;

  void _updateBPM(String? inputValue) {
    setState(() {
      if (inputValue != null && int.tryParse(inputValue) != null) {
        int numericValue = int.parse(inputValue);
        if (0 < numericValue && numericValue < 400) {
          _bpm = numericValue;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(50.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Beats per minute',
                  labelText: 'BPM*',
                ),
                initialValue: _bpm.toString(),
                onChanged: (String? value) {
                  _updateBPM(value);
                },
              ),
            ),
            SimpleCircularProgressBar(
              progressColors:
                  // progressColors: const [
                  //   Colors.cyan,
                  //   Colors.green,
                  //   Colors.amberAccent,
                  //   Colors.redAccent,
                  //   Colors.purpleAccent
                  // ],
                  const [Colors.cyan],
              backColor: Colors.blueGrey,
              backStrokeWidth: 5,
              animationDuration: _bpmToDuration(_bpm),
            )
          ],
        ),
      ),
    );
  }
}
