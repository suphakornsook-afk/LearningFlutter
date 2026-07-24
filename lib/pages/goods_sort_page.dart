import 'package:flutter/material.dart';

class GoodsSortPage extends StatefulWidget {
  const GoodsSortPage({super.key});

  @override
  State<GoodsSortPage> createState() => _GoodsSortPageState();
}

class _GoodsSortPageState extends State<GoodsSortPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // พื้นหลังโทนห้องจีนโบราณอุ่นๆ
          gradient: LinearGradient(
            colors: [Color(0xFF3E2723), Color(0xFF1B0000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ================= 1. Top Bar Header =================
              _buildTopBar(context),

              const SizedBox(height: 10),

              // ================= 2. Main Game Body =================
              Expanded(
                child: Row(
                  children: [
                    // --- ฝั่งซ้าย: ปุ่มสกิลช่วยเหลือ (Boosters) ---
                    _buildSideSkillMenu(),

                    // --- ตรงกลาง-ขวา: ตู้ชั้นวางของ 3 ตู้ ---
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Expanded(child: _buildCabinet(cabinetIndex: 0)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildCabinet(cabinetIndex: 1)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildCabinet(cabinetIndex: 2)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 🏆 1. แถบด้านบนแสดงปุ่มย้อนกลับ เวลา และคะแนน
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Color(0xFFFFD54F),
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF5D4037).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  "เวลา: 05:00   |   คะแนน: 0",
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // สำหรับจัด Balance
        ],
      ),
    );
  }

  // 🎁 2. เมนูปุ่มสกิลฝั่งซ้าย (สไตล์ Identity V)
  Widget _buildSideSkillMenu() {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSkillButton(
            icon: Icons.card_giftcard,
            label: "กำจัดห่อใหญ่",
            count: 3,
          ),
          const SizedBox(height: 20),
          _buildSkillButton(
            icon: Icons.published_with_changes,
            label: "สุ่มเปลี่ยน",
            count: 3,
          ),
          const SizedBox(height: 20),
          _buildSkillButton(
            icon: Icons.autorenew_rounded,
            label: "รีเฟรชการวาง",
            count: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillButton({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 6),
                ],
              ),
              child: Icon(icon, color: const Color(0xFFFFECB3), size: 28),
            ),
            Positioned(
              right: -4,
              top: -4,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red[800],
                child: Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFECB3),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 🪵 3. โครงสร้างตู้ไม้ (1 ตู้มี 4 ชั้น)
  Widget _buildCabinet({required int cabinetIndex}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4E342E), // สีเนื้อไม้เข้ม
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8D6E63), width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: List.generate(4, (shelfIndex) {
          // ตัวอย่างจำลอง: ล็อกชั้นที่ 3 ของบางตู้ไว้เหมือนภาพต้นฉบับ
          bool isLocked = (shelfIndex == 2 && cabinetIndex > 0);
          int lockCount = cabinetIndex;

          return Expanded(
            child: _buildShelf(
              shelfIndex: shelfIndex,
              isLocked: isLocked,
              lockCount: lockCount,
            ),
          );
        }),
      ),
    );
  }

  // 🪹 4. แผ่นชั้นวางของแต่ละชั้น + โซ่ล็อก
  Widget _buildShelf({
    required int shelfIndex,
    required bool isLocked,
    required int lockCount,
  }) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF8D6E63), width: 6),
        ), // ขอบหนาเป็นแผ่นไม้รอง
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Item วางเรียงบนชั้น (ตัวอย่างวาง 3 ชิ้น)
          if (!isLocked)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("🏺", style: TextStyle(fontSize: 28)),
                Text("🪭", style: TextStyle(fontSize: 28)),
                Text("📜", style: TextStyle(fontSize: 28)),
              ],
            ),

          // ถ้าโดนล็อกอยู่ ให้ขึ้นม่านสายโซ่กับแม่กุญแจทับ
          if (isLocked)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link, color: Colors.amber, size: 30),
                  const SizedBox(width: 4),
                  Icon(Icons.lock, color: Colors.amber[300], size: 28),
                  Text(
                    " $lockCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.link, color: Colors.amber, size: 30),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
