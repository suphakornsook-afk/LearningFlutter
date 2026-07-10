import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class FoodRandomPage extends StatefulWidget {
  const FoodRandomPage({super.key});

  @override
  State<FoodRandomPage> createState() => _FoodRandomState();
}

class _FoodRandomState extends State<FoodRandomPage> {
  //ข้อความเริ่มต้น
  String currentMenu = "กดปุ่มด้านล่าง";
  String currentMeat = "เพื่อเริ่มสุ่มเมนู";

  // รายการชื่อเมนู
  final List<String> menus = [
    'ผัดกะเพรา',
    'แพนง',
    'ผัดเปรี้ยวหวาน',
    'ผัดมาม่า',
    'สุกี้แห้ง',
    'สุกี้น้ำ',
    'ผัดขี้เมา',
    'ผัดจังโก้',
    'ลาบ',
    'ยำ',
  ];

  // รายการเนื้อสัตว์
  final List<String> meats = [
    'ไก่',
    'หมู',
    'ปลา',
    'หมึก',
    'เนื้อวัว',
    'รวมมิตร',
  ];

  void randomFood() {
    final random = Random();
    setState(() {
      currentMenu = menus[random.nextInt(menus.length)];
      currentMeat = meats[random.nextInt(meats.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        //transparent appbar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Food Randomizer Page",
          style: TextStyle(color: Colors.black),
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentMenu,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentMeat,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: randomFood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(30),
                      ),
                      elevation: 4,
                    ),
                    icon: Icon(Icons.casino, size: 28),
                    label: Text(
                      'Random',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
