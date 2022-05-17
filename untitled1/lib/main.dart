import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:untitled1/pages/show_flash.dart';
import 'package:contact_picker/contact_picker.dart';

import 'package:duration_button/duration_button.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => MyHomePage(),
      '/flashing': (context) => ShowFlash(),
    },
  ));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controllerInputText;
  late TextEditingController _controllerInputMorse;
  final ContactPicker contactPicker = new ContactPicker();
  late Contact contact;
  Map<String, String> dict = {
    'a': '.-',
    'b': '-...',
    'c': '-.-.',
    'd': '-..',
    'e': '.',
    'f': '..-.',
    'g': '--.',
    'h': '....',
    'i': '..',
    'j': '.---',
    'k': '-.-',
    'l': '.-..',
    'm': '--',
    'n': '-.',
    'o': '---',
    'p': '.--.',
    'q': '--.-',
    'r': '.-.',
    's': '...',
    't': '-',
    'u': '..-',
    'v': '...-',
    'w': '.--',
    'x': '-..-',
    'y': '-.--',
    'z': '--..',
    ' ': '/',
    '0': '-----',
    '1': '.----',
    '2': '..---',
    '3': '...--',
    '4': '....-',
    '5': '.....',
    '6': '-....',
    '7': '--...',
    '8': '---..',
    '9': '----.',
    '.': '.-.-.-',
    '?': '..--..',
    '!': '-.-.--',
    ',': '--..--',
    '\'': '.----.',
    '"': '.-..-.',
    '/': '-..-.',
    '&': '.-...',
    '@': '.--.-.',
    ':': '---...',
    '+': '.-.-.',
    '-': '-....-',
  };
  Map<String, String> reversedDict = {
    '-': 't',
    '--': 'm',
    '---': 'o',
    '-----': '0',
    '----.': '9',
    '---..': '8',
    '---...': ':',
    '--.': 'g',
    '--.-': 'q',
    '--..': 'z',
    '--..--': ',',
    '--...': '7',
    '-.': 'n',
    '-.-': 'k',
    '-.--': 'y',
    '-.-.': 'c',
    '-.-.--': '!',
    '-..': 'd',
    '-..-': 'x',
    '-..-.': '/',
    '-...': 'b',
    '-....': '6',
    '-....-': '-',
    '.': 'e',
    '.-': 'a',
    '.--': 'w',
    '.---': 'j',
    '.----': '1',
    '.----.': "'",
    '.--.': 'p',
    '.--.-.': '@',
    '.-.': 'r',
    '.-.-.': '+',
    '.-.-.-': '.',
    '.-..': 'l',
    '.-..-.': '"',
    '.-...': '&',
    '..': 'i',
    '..-': 'u',
    '..---': '2',
    '..--..': '?',
    '..-.': 'f',
    '...': 's',
    '...-': 'v',
    '...--': '3',
    '....': 'h',
    '....-': '4',
    '.....': '5',
    '/': ' '
  };

  @override
  void initState() {
    super.initState();
    _controllerInputText = TextEditingController();
    _controllerInputMorse = TextEditingController();
  }

  @override
  void dispose() {
    _controllerInputMorse.dispose();
    _controllerInputText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashlight App"),
      ),
      body: Center(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            // ElevatedButton(
            //   onPressed: () {
            //     _turnOnFlash(context);
            //   }, child: const Text("Flashlight Turn ON"),),
            // ElevatedButton(onPressed: () {
            //   _turnOffFlash(context);
            //   }, child: const Text("Flashlight Turn OFF")),
            TextField(
              controller: _controllerInputText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the text in latin alphabet'
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.pushNamed(context, '/flashing', arguments: {
                      'latin': _controllerInputText.text
                    });
                    // phraseInMorse();

                    }, child: const Text("⬆ 🔦 Flash it 🔦 ⬆")),
                  ElevatedButton(onPressed: () async{
                      contact =  await contactPicker.selectContact();
                      String phone = contact.phoneNumber.number;
                      print(phone);
                      print(contact.phoneNumber.number);
                      sendSms(phone);
                    }, child: const Text("📨 Send sms"))
                ],
            ),
            Container(
              // width: 100.0,
              child: TextField(
                controller: _controllerInputMorse,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the text in Morse Code'
                ),
              ),
            ),
            ElevatedButton(onPressed: () { translateFromMorse(); }, child: Text("Translate in latin ✍"))
          ],
        ),
      ),
    );
  }


  Future<void> translateFromMorse() async{

    String output = '';
    var words = _controllerInputMorse.text.split(" ");

    for(var word in words) {

      output += reversedDict[word] ?? "?";

    }

    testAlert(output);

  }

  Future<void> testAlert(String value) async {
        await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Translate'),
            content: Text('Text:  "$value"'),
            actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                ),
            ],
          );
        },
      );
  }

  Future<void> sendSms(String phone) async{

    String smsTranslated = '';
    _controllerInputText.text.runes.forEach((element) {
      smsTranslated += dict[String.fromCharCode(element)] ?? '';
      smsTranslated += ' ';
    });

    sendingSMS(smsTranslated, [phone]);

  }

  void sendingSMS(String msg, List<String> listReceipents) async {
    String sendResult = await sendSMS(message: msg, recipients: listReceipents)
        .catchError((err) {
    });
    if (kDebugMode) {
      print(sendResult);
    }
  }


}