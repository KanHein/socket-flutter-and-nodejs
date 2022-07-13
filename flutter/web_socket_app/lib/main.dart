import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String date = "";
  String message = "";
  final dateChannel = IOWebSocketChannel.connect('ws://10.0.2.2:3000/time');
  final chatChannel = IOWebSocketChannel.connect('ws://10.0.2.2:3000/chat');
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Socket"),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: dateChannel.stream,
              builder: (context, snapshot){
            if(snapshot.hasData){
              date = snapshot.data.toString();
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(date),
            );
          }),

          StreamBuilder(
              stream: chatChannel.stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  message = snapshot.data.toString();
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(message),
                );
              }),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _messageController,
            ),
          ),
          ElevatedButton(onPressed: (){
            chatChannel.sink.add(_messageController.text);
            _messageController.clear();
          }, child: const Text("Send"),),
        ],
      ),
    );
  }
}
