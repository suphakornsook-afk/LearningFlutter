import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/counter_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/settings_page.dart';
import 'package:flutter_application_2/pages/ball_sort_page.dart';
import 'package:flutter_application_2/data/note_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ToDoDataBase db = ToDoDataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 247, 222, 222),
              Color.fromARGB(255, 248, 96, 96),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= ส่วนหัวข้อ (แบบ ก: ขาวโปร่งแสง) =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.35,
                    ), // ขาวโปร่งแสงสไตล์กระจกฝ้า
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // ขอบมนเข้ากับตัวการ์ด
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "คลังแอปและมินิเกม 🚀",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "รวมผลงานโปรเจกต์ทั้งหมดของคุณไว้ในที่เดียว",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16), // เว้นระยะห่างก่อนเริ่ม Grid
                ValueListenableBuilder(
                  valueListenable: Hive.box("notebox").listenable(),
                  builder: (context, Box box, child) {
                    final List dynamicList = box.get("TODOLIST") ?? [];
                    final int totalTasks = dynamicList.length;

                    final int completedTasks = dynamicList
                        .where((todo) => todo[1] == true)
                        .length;

                    final double progressPercentage = totalTasks > 0
                        ? (completedTasks / totalTasks)
                        : 0.0;

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.45,
                        ), // ขาวโปร่งแสงสไตล์กระจกฝ้าเข้ากับธีมแดงของคุณ
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ความคืบหน้า To Do App 📝",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              // แสดงตัวเลขเปอร์เซ็นต์แบบจำนวนเต็ม เช่น 50%
                              Text(
                                "${(progressPercentage * 100).toInt()}%",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value:
                                  progressPercentage, // เปอร์เซ็นต์ความคืบหน้าที่คำนวณได้
                              minHeight: 10,
                              backgroundColor: Colors.white.withOpacity(
                                0.3,
                              ), // สีเส้นรางหลัง
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 135, 189, 63),
                              ), // แถบความคืบหน้าสีขาวเด่นๆ บนพื้นแดง
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // ================= ส่วนของ Grid แถวละ 3 ชิ้น =================
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // 1. Soundboard
                    _buildGridCard(
                      context,
                      title: "Soundboard",
                      icon: Icons.volume_up,
                      color: Colors.orange,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SoundboardPage()));
                      },
                    ),
                    // 2. Fortune Cookie
                    _buildGridCard(
                      context,
                      title: "Fortune\nCookie",
                      icon: Icons.cookie,
                      color: Colors.amber.shade700,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const FortuneCookiePage()));
                      },
                    ),
                    // 3. Memory Game
                    _buildGridCard(
                      context,
                      title: "Memory\nGame",
                      icon: Icons.extension,
                      color: Colors.pink,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const MemoryGamePage()));
                      },
                    ),
                    // 4. Ball Sort
                    _buildGridCard(
                      context,
                      title: "Ball Sort\nGame",
                      icon: Icons.sports_baseball,
                      color: Colors.green,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const BallSortGamePage()));
                      },
                    ),
                    // 5. Pill Tracker
                    _buildGridCard(
                      context,
                      title: "Pill\nTracker",
                      icon: Icons.medication,
                      color: Colors.cyan,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const PillTrackerPage()));
                      },
                    ),
                    // 6. Mockup Page
                    _buildGridCard(
                      context,
                      title: "Mockup\nPage",
                      icon: Icons.layers,
                      color: Colors.purple,
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const MockupPage()));
                      },
                    ),
                    _buildGridCard(
                      context,
                      title: "To Do\nApp",
                      icon: Icons.note,
                      color: Colors.lightGreen,
                      onTap: () {
                        Navigator.pushNamed(context, '/todopage');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างกล่องสี่เหลี่ยมจัตุรัสสำหรับ Grid
  Widget _buildGridCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          // เปลี่ยนจากสีขาวทึบ เป็นสีขาวโปร่งแสง
          color: const Color.fromARGB(255, 253, 244, 244),
          borderRadius: BorderRadius.circular(16),
          // เพิ่มเส้นขอบบางๆ ให้ดูเหมือนขอบกระจกสะท้อนแสง
          border: Border.all(color: Colors.white, width: 1.5),
          // ปรับเงาให้ฟุ้งและจางลงมาก เพื่อความละมุน
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.18),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
