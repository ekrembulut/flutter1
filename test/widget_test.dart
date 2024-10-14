import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _seconds = 1800;  // Varsayılan süre (30 dakika)
  Timer? _timer;
  bool _isRunning = false;
  final TextEditingController _controller = TextEditingController(text: '30'); // Varsayılan giriş süresi

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer!.cancel();
        _isRunning = false;
      }
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = int.tryParse(_controller.text)! * 60; // Kullanıcıdan girilen değere göre resetle
      _isRunning = false;
    });
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _seconds ~/ 60; // Dakika kısmını hesapla
    int seconds = _seconds % 60;  // Saniye kısmını hesapla

    return Scaffold(
      appBar: AppBar(
        title: const Text('Girilebilir Zamanlayıcı'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Arka plan resminin yolu
            fit: BoxFit.cover, // Resmin ekrana yayılması
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Kalan Süre:',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                '$minutes dakika $seconds saniye',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Yazının rengini beyaz yaptık
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Süreyi dakika olarak girin',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, // TextField'in arka plan rengi
                    filled: true, // Arka plan rengini etkinleştir
                  ),
                  onChanged: (value) {
                    setState(() {
                      int? enteredMinutes = int.tryParse(value);
                      if (enteredMinutes != null && enteredMinutes > 0) {
                        _seconds = enteredMinutes * 60; // Girilen dakika ile saniye güncelle
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isRunning ? null : _startTimer,
                    child: const Text('Başla'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isRunning ? _stopTimer : null,
                    child: const Text('Durdur'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    child: const Text('Sıfırla'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
