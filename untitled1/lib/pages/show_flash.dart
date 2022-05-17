import 'dart:io';

import 'package:duration_button/duration_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';

class ShowFlash extends StatefulWidget {
  const ShowFlash({Key? key}) : super(key: key);

  @override
  State<ShowFlash> createState() => _ShowFlashState();
}

class _ShowFlashState extends State<ShowFlash> {

  Map data = {};
  String flashedString = '';
  int index = 0;
  TextDurationButton drbtn = TextDurationButton(text: const Text(""), duration: Duration(milliseconds: 1000), onPressed: (){});
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


  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments as Map;
    if( index == -1) {
      flashedString = "";
    }
    else {
      flashedString = data['latin'][index];
    }

    // phraseInMorse();
    drbtn = TextDurationButton(
        duration: Duration(milliseconds: 200),
        onPressed: () {
          if(index != -1) {
            letterInLight(data['latin'][index]);
          }
        },
        onComplete: (){
          if(index != -1) {
            letterInLight(data['latin'][index]);
          }
        },
        coverColor: Color(0),
        text: Text(
          (flashedString + " -> " + (spaceString(dict[flashedString] ?? "") ?? "DONE")),
          style: TextStyle(fontSize: 50),
        ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flash Show"),
      ),
      body:
        Center(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                Text(
                  data['latin'],
                  style: TextStyle(fontSize: 50)
                ),
                drbtn
              ]
          ),
        ),


    );
  }

  String? spaceString(String str){

    if(str == "") {
      return null;
    }

    String res = "";
    str.runes.forEach((element) {
      res += String.fromCharCode(element) + "  ";
    });

    return res;
  }

  Future<void> phraseInMorse() async{

    data['latin'].runes.forEach((element) {
      setState(() {
        flashedString = String.fromCharCode(element);
      });
      letterInLight(String.fromCharCode(element));
    });

  }

  void letterInLight(String letter) async{
    if(dict[letter] != null) {
      dict[letter]?.runes.forEach((element) async {

        if (String.fromCharCode(element) == '.'){
          _turnOnFlash(context);
          sleep(const Duration(milliseconds: 125));
          _turnOffFlash(context);
          sleep(const Duration(milliseconds: 125));
        }else if(String.fromCharCode(element) == '-'){
          _turnOnFlash(context);
          sleep(const Duration(milliseconds: 280));
          _turnOffFlash(context);
          sleep(const Duration(milliseconds: 125));
        }else{
          sleep(const Duration(milliseconds: 625));
        }

      });
    }
    sleep(const Duration(milliseconds: 450));
    if( index < data['latin'].length-1){
      setState(() {
        index++;
        simulatePress();
      });
    }else {
      setState(() {
        index = -1;
      });
    }
  }

  Future<void> simulatePress() async{
    Future.delayed(Duration(milliseconds: 1000), () {drbtn.onPressed();});
  }

  Future<void> _turnOnFlash(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
      // sendingSMS('Hello, this the test message', ['0786392693']);
    } on Exception catch (_) {
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  Future<void> _turnOffFlash(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      _showErrorMes('Could not enable Flashlight', context);
    }
  }
  void _showErrorMes(String mes, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mes)));
  }
}
