import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/data/note_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
              Color.fromARGB(255, 252, 238, 238),
              Color.fromARGB(255, 248, 120, 120),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hello, Developer 👋",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const Text(
                          "คลังแอป & มินิเกม",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

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

                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/todopage'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.note_alt_rounded,
                                          color: Colors.green.shade700,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "To Do Progress",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    totalTasks == 0
                                        ? "ไม่มีงานค้างอยู่เลย!"
                                        : "เคลียร์ไปแล้ว $completedTasks จาก $totalTasks งาน",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progressPercentage,
                                      minHeight: 6,
                                      backgroundColor: Colors.grey.shade100,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${(progressPercentage * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                const Text(
                  "🔥 MINIGAMES",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.black45,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFeaturedCard(
                        context,
                        title: "Goods Sort",
                        subtitle: "เกมเรียงของบนชั้นวาง",
                        icon: Icons.grid_view_rounded,
                        color: Colors.brown.shade700,
                        onTap: () =>
                            Navigator.pushNamed(context, '/goodssortpage'),
                      ),
                      _buildFeaturedCard(
                        context,
                        title: "Number Guessing",
                        subtitle: "เกมทายเลข Roguelike",
                        icon: Icons.videogame_asset_rounded,
                        color: Colors.purple,
                        onTap: () =>
                            Navigator.pushNamed(context, '/numberguessingpage'),
                      ),
                      _buildFeaturedCard(
                        context,
                        title: "Memory Game",
                        subtitle: "จับคู่การ์ดทดสอบสมอง",
                        icon: Icons.extension_rounded,
                        color: Colors.pink,
                        onTap: () =>
                            Navigator.pushNamed(context, '/memorygamepage'),
                      ),
                      _buildFeaturedCard(
                        context,
                        title: "Ball Sort Puzzle",
                        subtitle: "เรียงลูกบอลสีในหลอด",
                        icon: Icons.sports_baseball_rounded,
                        color: Colors.green,
                        onTap: () =>
                            Navigator.pushNamed(context, '/ballsortpage'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "🛠️ UTILITIES & FUN",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.black45,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  shrinkWrap: true,
                  childAspectRatio: 1.4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildGridCard(
                      context,
                      title: "Soundboard",
                      desc: "กดเปิดเอฟเฟกต์เสียง",
                      icon: Icons.volume_up_rounded,
                      color: Colors.orange.shade700,
                      onTap: () =>
                          Navigator.pushNamed(context, '/soundboardpage'),
                    ),
                    _buildGridCard(
                      context,
                      title: "Fortune Cookie",
                      desc: "เสี่ยงทายเซียมซี",
                      icon: Icons.cookie_rounded,
                      color: Colors.amber.shade800,
                      onTap: () => Navigator.pushNamed(context, '/cookiepage'),
                    ),
                    _buildGridCard(
                      context,
                      title: "Pill Tracker",
                      desc: "บันทึกการกินยาประจำวัน",
                      icon: Icons.medication_rounded,
                      color: Colors.cyan.shade700,
                      onTap: () =>
                          Navigator.pushNamed(context, '/pilltrackerpage'),
                    ),
                    _buildGridCard(
                      context,
                      title: "วันนี้กินอะไรดี",
                      desc: "สุ่มเมนูอาหารจานโปรด",
                      icon: Icons.fastfood_rounded,
                      color: Colors.deepOrange,
                      onTap: () =>
                          Navigator.pushNamed(context, '/foodrandompage'),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: Colors.white.withOpacity(0.4),
                  leading: const Icon(
                    Icons.layers_rounded,
                    color: Colors.black87,
                  ),
                  title: const Text(
                    "ดูการออกแบบ Mockup Page",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/mockuppage'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: color, size: 24),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.black26,
                      size: 16,
                    ), // ไอคอนชี้ขึ้นเพิ่มความล้ำ
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
