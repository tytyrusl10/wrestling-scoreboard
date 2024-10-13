import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Wrestling Scoreboard')),
        body: TimerPage(),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  int _counter = 420; // 7 minutes in seconds
  bool isCountingDown = false;
  int _blueCounter = 0;
  int _redCounter = 0;
  int _ridingTime = 0;
  bool _isRidingTimeCountingDown = false;
  bool _countRidingTime = false;

  // Blood time variables
  late Timer _bloodTimeTimer;
  int _bloodTimeCounter = 300; // 5 minutes in seconds
  bool isBloodTimeActive = false;

  // Injury time variables
  late Timer _redInjuryTimer;
  late Timer _greenInjuryTimer;
  int _redInjuryTimeCounter = 90; // 90 seconds for red injury time
  int _greenInjuryTimeCounter = 90; // 90 seconds for green injury time
  bool isRedInjuryTimeActive = false;
  bool isGreenInjuryTimeActive = false;
   
   void runRedInjuryTime() {
    const oneSec = Duration(seconds: 1);
    _redInjuryTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_redInjuryTimeCounter == 0) {
            timer.cancel();
            isRedInjuryTimeActive = false; // Reset injury time when it reaches zero
          } else {
            _redInjuryTimeCounter--;
          }
        });
      },
    );
  }

  

  void runGreenInjuryTime() {
    const oneSec = Duration(seconds: 1);
    _greenInjuryTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_greenInjuryTimeCounter == 0) {
            timer.cancel();
            isGreenInjuryTimeActive = false; // Reset injury time when it reaches zero
          } else {
            _greenInjuryTimeCounter--;
          }
        });
      },
    );
  }

  // Toggle Red Injury Time
  void toggleRedInjuryTime() {
    if (isRedInjuryTimeActive) {
      _redInjuryTimer.cancel(); // Stop the timer if it's active
      setState(() {
        isRedInjuryTimeActive = false; // Mark as inactive
      });
    } else {
      runRedInjuryTime(); // Start red injury time
      setState(() {
        isRedInjuryTimeActive = true; // Mark as active
      });
    }
  }

  // Toggle Green Injury Time
  void toggleGreenInjuryTime() {
    if (isGreenInjuryTimeActive) {
      _greenInjuryTimer.cancel(); // Stop the timer if it's active
      setState(() {
        isGreenInjuryTimeActive = false; // Mark as inactive
      });
    } else {
      runGreenInjuryTime(); // Start green injury time
      setState(() {
        isGreenInjuryTimeActive = true; // Mark as active
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatRidingTime(int seconds) {
    int absoluteSeconds = seconds.abs();
    int minutes = absoluteSeconds ~/ 60;
    int remainingSeconds = absoluteSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //function to adjust time
  void _adjustTimer(int seconds) {
  setState(() {
    _counter = (_counter + seconds).clamp(0, 420); // Ensure the timer doesn't go below 0 or above 7 minutes
  });
}

  // String state can be "clock" or "riding"
  void runClock(String state) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_counter == 0 && isCountingDown) {
            _isRidingTimeCountingDown = false;
            _countRidingTime = false;
            timer.cancel();
          } else {
            if (isCountingDown) {
              _counter--;
              if (_countRidingTime) {
                // If _countRidingTime is true, then we need to be incrementing riding time as well along with the clock.
                if (_isRidingTimeCountingDown) {
                  _ridingTime--;
                } else {
                  _ridingTime++;
                }
              }
            }
            if (!isCountingDown) {
              _isRidingTimeCountingDown = false; // Ensure Riding Time stops.
              _countRidingTime = false;
              timer.cancel();
            }
          }
        },
      ),
    );
  }

   void runBloodTime() {
    const oneSec = Duration(seconds: 1);
    _bloodTimeTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_bloodTimeCounter == 0) {
            timer.cancel();
            isBloodTimeActive = false; // Reset blood time when it reaches zero
          } else {
            _bloodTimeCounter--;
          }
        });
      },
    );
  }

   void toggleBloodTime() {
    if (isBloodTimeActive) {
      _bloodTimeTimer.cancel(); // Stop the timer if it's active
      setState(() {
        _bloodTimeCounter = 300; // Reset to 5 minutes
        isBloodTimeActive = false;
      });
    } else {
      runBloodTime(); // Start blood time
      setState(() {
        isBloodTimeActive = true;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Position the "clock" 3/4 up the app centered
          Positioned(
            top: MediaQuery.of(context).size.height / 40,
            left: MediaQuery.of(context).size.width / 2.3,
            child: Center(
              child: Text(
                formatTime(_counter),
                style: TextStyle(
                  fontSize: 200.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          // Position the buttons at the bottom center of the app
          Positioned(
            top: 5,
            left: MediaQuery.of(context).size.width / 40,
            
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    isCountingDown = isCountingDown ? false : true;
                    runClock("clock");
                  },
                  child: Text('Play/Pause Clock'),
                ),
                SizedBox(width: 10), // Add some spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    isCountingDown = false;
                    _counter = 420; // 7 minutes
                    runClock("clock");
                  },
                  child: Text('Reset Clock'),
                ),
                 ElevatedButton(
                  onPressed: () {
                     if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(-60); // Subtract 1 minute
                       });
                    }
                },
              child: Text('-1 min'),
              
                ),
                
                SizedBox(width: 10), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(-1); // Subtract 1 second
                       });
                    }
                 },
                child: Text('-1 sec'),
                ),
                SizedBox(width: 10), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                     if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(1); // add 1 second
                       });
                    }
                   },
                 child: Text('+1 sec'),
                ),
                
                SizedBox(width: 10), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                     if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(60); // add 1 minute
                       });
                    }
                  },
                child: Text('+1 min'),
                    ), 
                    ElevatedButton(
                      onPressed: () {
                        if (!isCountingDown) {
                          setState(() {
                            _blueCounter = 0; // clear both scores
                            _redCounter = 0;
                       });
                    }
                },
              child: Text('Clear Score'),
                ),
                    ],
                  ),
                ),
                // Blood Time Button
          Positioned(
            top: 5,
            right: MediaQuery.of(context).size.width / 40,
            child: ElevatedButton(
              onPressed: toggleBloodTime,
              child: Text('Blood Time'),
            ),
          ),
          // Display Blood Time if active
          if (isBloodTimeActive)
            Positioned(
              top: 40,
              right: MediaQuery.of(context).size.width / 40,
              child: Text(
                formatTime(_bloodTimeCounter),
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
              ),
            ),
          // Position the "Riding Time" Text below the main clock
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 2.09,
            child: Column(
              children: <Widget>[
                Text(
                  'Riding Time',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Position the "Riding Time" clock below the main clock
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              children: <Widget>[
                Text(
                  formatRidingTime(_ridingTime),
                  style: TextStyle(
                    fontSize: 100.0,
                    color: _ridingTime < 0
                        ? Colors.green
                        : (_ridingTime > 0 ? Colors.red : Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isRidingTimeCountingDown = true;
                          _countRidingTime = true;
                          if (_ridingTime > 0) {
                            _ridingTime--;
                          }
                        });
                      },
                      child: Text('Riding Time Green'),
                    ),
                    SizedBox(width: 10), // Add some spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isRidingTimeCountingDown = false;
                          _ridingTime++;
                          _countRidingTime = true;
                        });
                      },
                      child: Text('Riding Time Red'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _ridingTime = 0;
                          _countRidingTime = false;
                        });
                      },
                      child: Text('Reset Riding Time'),
                    ),
                    SizedBox(width: 10), // Add some spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _countRidingTime = false;
                        });
                      },
                      child: Text('Pause Riding Time'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Draw a white line horizontally in the middle of the app
          Positioned(
            top: MediaQuery.of(context).size.height / 1.8,
            child: Container(
              height: 1.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
          // Draw a white line vertically from the center of the app to the bottom
          Positioned(
  bottom: 0,
  left: 0,
  child: Container(
    height: MediaQuery.of(context).size.height / 2.2,
    width: MediaQuery.of(context).size.width / 2,
    color: Colors.green,
    child: Stack( // Use Stack to position the injury time button
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isGreenInjuryTimeActive)
          Text(
            formatTime(_greenInjuryTimeCounter),
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
            Text(
              '$_blueCounter',
              style: TextStyle(
                fontSize: 200.0,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _blueCounter = max(0, _blueCounter - 1);
                    });
                  },
                  child: Text('Green-'),
                ),
                SizedBox(width: 10), // Add some spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _blueCounter++;
                    });
                  },
                  child: Text('Green+'),
                ),
              ],
            ),
            SizedBox(height: 20), // Add some spacing between the score and the new buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _blueCounter += 3;
                    _isRidingTimeCountingDown = true;
                    _countRidingTime = true;
                  },
                  child: Text('Takedown'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _blueCounter += 2;
                    _isRidingTimeCountingDown = true;
                    _countRidingTime = true;
                  },
                  child: Text('Reversal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _blueCounter++;
                    _isRidingTimeCountingDown = false;
                    _countRidingTime = false;
                  },
                  child: Text('Escape'),
                ),
              ],
            ),
          ],
        ),
        // Injury Time Button in the top left of the green quadrant
        Positioned(
          top: 10,
          left: 10,
          child: ElevatedButton(
            onPressed: toggleGreenInjuryTime, // Toggle injury time for green
            child: Text(isGreenInjuryTimeActive ? 'Stop Green Injury Time' : 'Start Green Injury Time'),
          ),
        ),
      ],
    ),
  ),
),
          // Create the bottom right quadrant (red)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width / 2,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   // Add injury time display for Red
                  // Conditionally display injury time for Red
        if (isRedInjuryTimeActive)
          Text(
            formatTime(_redInjuryTimeCounter),
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
                  Text(
                    '$_redCounter',
                    style: TextStyle(
                      fontSize: 200.0,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _redCounter = max(0, _redCounter - 1);
                          });
                        },
                        child: Text('Red-'),
                      ),
                      SizedBox(
                          width: 10), // Add some spacing between the buttons
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _redCounter++;
                          });
                        },
                        child: Text('Red+'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Add some spacing between the score and the new buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _redCounter+= 3;
                           _ridingTime++;
                           _isRidingTimeCountingDown = false;
                          _countRidingTime = true;

                      },
                      child: Text('Takedown'),
                    ),
                      ElevatedButton(
                        onPressed: () {
                          _redCounter+= 2;
                          _ridingTime++;
                          _isRidingTimeCountingDown = false;
                          _countRidingTime = true;

                      },
                      child: Text('Reversal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                         _redCounter++;
                         _isRidingTimeCountingDown = false;
                         _countRidingTime = false;

                     },
                     child: Text('Escape'),
                   ),
                  ],
                ),
                ],
              ),
              
            ),
          ),
          // Injury Time Button in the top right of the red quadrant
        Positioned(
          top: 540,
          right: 10,
          child: ElevatedButton(
            onPressed: toggleRedInjuryTime, // Toggle injury time for red
            child: Text(isRedInjuryTimeActive ? 'Stop Red Injury Time' : 'Start Red Injury Time'),
          ),
        ),
        ],
      ),
    );
  }
}

