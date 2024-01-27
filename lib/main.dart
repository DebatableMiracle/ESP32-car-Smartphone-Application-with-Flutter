import 'package:flutter/material.dart';
import 'package:joystick/joystick.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketLed(),
    );
  }
}

class WebSocketLed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebSocketLed();
  }
}

class _WebSocketLed extends State<WebSocketLed> {
  late IOWebSocketChannel channel;
  bool connected = false; //boolean value to track if WebSocket is connected
  bool isUpButtonOn = false;
  bool isLeftButtonOn = false;
  bool isStopButtonOn = false;
  bool isDownButtonOn = false;
  bool isRightButtonOn = false;
  bool useJoystick = false;
  @override
  void initState() {
    connected = false; //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            }
          });
        },
        onDone: () {
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (cmd != '1' && cmd != '2' && cmd != '3' && cmd != '4' && cmd != '0') {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: connected
            ? const Text('ESP32 Car Control: CONNECTED')
            : const Text("ESP32 Car Not connected :("),
        backgroundColor: const Color.fromRGBO(13, 20, 226, 0.514),
      ),
      body: Center(
        child: useJoystick
            ? JoystickWidget(sendcmd)
            // Joystick(
            //     size: 125.0,
            //     isDraggable: true,
            //     iconColor: Colors.amber,
            //     backgroundColor: Colors.black,
            //     opacity: 0.5,
            //     joystickMode: JoystickModes.all,
            //     onUpPressed: () {
            //       setState(() {
            //         isUpButtonOn = true;
            //         sendcmd('1');
            //       });
            //     },
            //     onDownPressed: () {
            //       setState(() {
            //         isDownButtonOn = true;
            //         sendcmd('2');
            //       });
            //     },
            //     onLeftPressed: () {
            //       setState(() {
            //         isLeftButtonOn = true;
            //         sendcmd('3');
            //       });
            //     },
            //     onRightPressed: () {
            //       setState(() {
            //         isRightButtonOn = true;
            //         sendcmd('4');
            //       });  
            //     },
            //   )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        isUpButtonOn = true;
                        sendcmd('1');
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isUpButtonOn = false;
                        sendcmd('0');
                      });
                    },
                    child: Container(
                      color: isUpButtonOn
                          ? Colors.blue
                          : Colors.grey, // Change the color as needed
                      padding: const EdgeInsets.all(16.0),
                      child: const Text('Forward'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            isLeftButtonOn = true;
                            sendcmd('3');
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            isLeftButtonOn = false;
                            sendcmd('0');
                          });
                        },
                        child: Container(
                          color: isLeftButtonOn
                              ? Colors.blue
                              : Colors.grey, // Change the color as needed
                          padding: const EdgeInsets.all(16.0),
                          child: const Text('Left'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            isStopButtonOn = true;
                            sendcmd('0');
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            isStopButtonOn = false;
                            sendcmd('0');
                          });
                        },
                        child: Container(
                          color: isStopButtonOn
                              ? Colors.blue
                              : Colors
                                  .grey, // Change the color as needed // Change the color as needed
                          padding: const EdgeInsets.all(16.0),
                          child: const Text('Stop'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            isRightButtonOn = true;
                            sendcmd('4');
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            isRightButtonOn = false;
                            sendcmd('0');
                          });
                        },
                        child: Container(
                          color: isRightButtonOn
                              ? Colors.blue
                              : Colors.grey, // Change the color as needed
                          padding: const EdgeInsets.all(16.0),
                          child: const Text('Right'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        isDownButtonOn = true;
                        sendcmd('2');
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isDownButtonOn = false;
                        sendcmd('0');
                      });
                    },
                    child: Container(
                      color: isDownButtonOn
                          ? Colors.blue
                          : Colors.grey, // Change the color as needed
                      padding: const EdgeInsets.all(16.0),
                      child: const Text('Backward'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
}
class JoystickWidget extends StatefulWidget {
  final Function(String) sendcmd;

  const JoystickWidget(this.sendcmd);

  @override
  _JoystickWidgetState createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = const Offset(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          position += details.delta;
          // Limit joystick movement within a circle
          if (position.distance > 50) {
            position = position / position.distance * 50;
          }
          // Calculate direction based on position
          double angle = position.direction;
          double distance = position.distance / 50; // Normalize to 0-1
          // Map angle and distance to appropriate commands
          // Example: Send commands based on angle and distance
          // For simplicity, this example sends a single command '5'
          widget.sendcmd('5');
        });
      },
      onPanEnd: (details) {
        setState(() {
          position = const Offset(0, 0);
          // Send stop command when joystick is released
          widget.sendcmd('0');
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(0.5),
        ),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
