import 'package:flutter/material.dart';
import 'dart:math';

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  final List<String> _fortunes = [
    "ไม่อยากติดแกลมแล้ว อยากติดเธอมากกว่า",
    "รักน้ำรักปลารักผมบ้างยัง",
    "ธนาคารมีไว้ฝากตังค์ แต่เธอมีใครหรือยัง อยากฝากใจ",
    "จะคิดมุกได้ ต้องคิดถึงเธอก่อน",
    "Holiday อ่ะวันหยุด แต่ถ้ารักที่สุดอ่ะ Everyday",
  ];

  String _currentFortune = "แตะที่คุกกี้เพื่อเปิดคำทำนายของคุณ!";
  bool _isBroken = false;
  bool _isShaking = false;

  void _breakCookie() async {
    if (_isBroken) {
      // ถ้าคุกกี้แตกอยู่แล้ว กดอีกทีจะรีเซ็ตกลับมาเป็นชิ้นเดิม
      setState(() {
        _isBroken = false;
        _currentFortune = "แตะที่คุกกี้เพื่อเปิดคำทำนายของคุณ!";
      });
      return;
    }
    setState(() {
      _isShaking = true;
    });
    await Future.delayed(const Duration(milliseconds: 500)); // สั่น 0.5 วินาที

    // สเต็ป 2: คุกกี้แตกออก และสุ่มคำทำนาย
    final random = Random();
    setState(() {
      _isShaking = false;
      _isBroken = true;
      _currentFortune = _fortunes[random.nextInt(_fortunes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Fortune Cookie", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 247, 222, 222),
                const Color.fromARGB(255, 248, 96, 96),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _breakCookie,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  transform: Matrix4.translationValues(
                    _isShaking ? (Random().nextBool() ? 10 : -10) : 0,
                    0,
                    0,
                  ),
                  child: _isBroken
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cookie_outlined,
                              size: 80,
                              color: Colors.brown,
                            ),
                            SizedBox(width: 40),
                            Icon(
                              Icons.cookie_outlined,
                              size: 80,
                              color: Colors.brown,
                            ),
                          ],
                        )
                      : const Icon(
                          //สั่น
                          Icons.cookie,
                          size: 150,
                          color: Colors.brown,
                        ),
                ),
              ),

              const SizedBox(height: 50),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _isShaking ? 0.0 : 1.0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _currentFortune,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isBroken
                          ? Colors.red.shade700
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
