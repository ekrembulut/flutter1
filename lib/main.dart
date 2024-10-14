import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  initializeDateFormatting('tr_TR', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var fadeAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(seconds: 2), // Animasyon süresi
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/htm.png', width: 150, height: 150), // Logo
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Hoşgeldiniz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _seconds = 60;
  int _totalSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  final TextEditingController _controller = TextEditingController(text: '1');
  int _cuzNumber = 7;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    if (!_isPaused) {
      _totalSeconds = int.tryParse(_controller.text)! * 60;
      _seconds = _totalSeconds;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer!.cancel();
        setState(() {
          _isRunning = false;
        });
        _showCompletionAlert();
      }
    });

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = int.tryParse(_controller.text)! * 60;
      _isRunning = false;
      _isPaused = false;
    });
    _timer?.cancel();
  }

  Color _getProgressColor(double progress) {
    if (progress > 0.5) {
      return Colors.green;
    } else if (progress > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getProgressBackgroundColor(double progress) {
    if (progress > 0.5) {
      return Colors.green.withOpacity(0.2);
    } else if (progress > 0.25) {
      return Colors.orange.withOpacity(0.2);
    } else {
      return Colors.red.withOpacity(0.2);
    }
  }

  void _showSettingsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ayarlar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Cüz Numarası'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _cuzNumber = int.tryParse(value) ?? 7;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Dakika Ayarı'),
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void _showCompletionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hatim Okuma Süresi Tamamlanmıştır ! '),
          content: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 64,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    final now = DateTime.now().toUtc().add(const Duration(hours: 3));

    String formattedDate = DateFormat('dd.MM.yyyy').format(now);
    String formattedDate2 = DateFormat('EEEE', 'tr_TR').format(now);

    double progressValue = _seconds / _totalSeconds;
    Color progressColor = _getProgressColor(progressValue);
    Color progressBackgroundColor = _getProgressBackgroundColor(progressValue);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/htm2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _isRunning ? null : _startTimer,
                            child: const Text('Başlat'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 34,
                                color: Color(0xFFECB364),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 1000,
                      height: 1000,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: progressValue),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 30,
                              color: progressColor,
                              backgroundColor: progressBackgroundColor);
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'ÜMRANİYE',
                              style: const TextStyle(
                                fontSize: 54,
                                color: Color(0xFFECB364),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/htm.png',
                                      width: 300,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      '$_cuzNumber. Cüz',
                                      style: const TextStyle(
                                        fontSize: 84,
                                        color: Color(0xFFECB364),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 84,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFECB364),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _stopTimer,
                                child: const Text('Durdur'),
                              ),
                              ElevatedButton(
                                onPressed: _resetTimer,
                                child: const Text('Sıfırla'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                formattedDate2,
                                style: const TextStyle(
                                  fontSize: 34,
                                  color: Color(0xFFECB364),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsModal,
        tooltip: 'Ayarlar',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
