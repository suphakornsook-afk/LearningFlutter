import 'package:flutter/material.dart';

class GoodsSortPage extends StatefulWidget {
  const GoodsSortPage({super.key});

  @override
  State<GoodsSortPage> createState() => _GoodsSortPageState();
}

class _GoodsSortPageState extends State<GoodsSortPage> {
  final List<String> itemTypes = ["🏺", "🪭", "📜", "🪴", "🍵", "🕯️"];

  late List<List<List<String>>> cabinets;

  int? selectedCabinet;
  int? selectedShelf;

  @override
  void initState() {
    super.initState();
    generateLevelData();
  }

  void generateLevelData() {
    // 1. มีพื้นที่ทั้งหมด 15 ช่อง แต่เราจะใส่ของแค่ 12 ชิ้น (4 ชุด x 3 ชิ้น)
    // เพื่อให้เหลือช่องว่างว่างเปล่า 3 ช่องไว้ขยับของ!
    int totalItems = 12;
    int totalSets = totalItems ~/ 3; // ได้ 4 ชุด

    List<String> pool = [];
    for (int i = 0; i < totalSets; i++) {
      String selectedType = itemTypes[i % itemTypes.length];
      pool.addAll([selectedType, selectedType, selectedType]);
    }

    // เติมช่องว่างเปล่า (Empty Space) เข้าไปใน Pool ให้ครบ 15 ช่อง
    while (pool.length < 15) {
      pool.add(""); // ใช้ "" แทนช่องว่าง
    }

    List<List<List<String>>> newCabinets = [];
    bool hasInitialMatch = true;

    while (hasInitialMatch) {
      pool.shuffle(); // เขย่าสุ่มกระจายของและช่องว่าง
      newCabinets = [];
      hasInitialMatch = false;
      int poolIndex = 0;

      for (int c = 0; c < 2; c++) {
        List<List<String>> shelves = [];
        for (int s = 0; s < 3; s++) {
          bool isLocked = (s == 2 && c == 1);

          if (isLocked) {
            shelves.add([]);
          } else {
            List<String> shelfItems = [];
            for (int i = 0; i < 3; i++) {
              String item = pool[poolIndex++];
              if (item.isNotEmpty) {
                shelfItems.add(item); // ใส่เฉพาะชิ้นที่มีของลงชั้น
              }
            }

            // เช็กไม่ให้ซ้ำ 3 ชิ้นตั้งแต่แรก
            if (shelfItems.length == 3 &&
                shelfItems[0] == shelfItems[1] &&
                shelfItems[1] == shelfItems[2]) {
              hasInitialMatch = true;
            }

            shelves.add(shelfItems);
          }
        }
        newCabinets.add(shelves);
      }
    }

    setState(() {
      cabinets = newCabinets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C1810), Color(0xFF100805)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ================= 1. Header (เวลา & คะแนน) =================
              _buildTopBar(context),

              const SizedBox(height: 12),

              // ================= 2. Main Area: 2 ตู้กว้างๆ (3 ชั้น) =================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: _buildCabinet(cabinetIndex: 0)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCabinet(cabinetIndex: 1)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= 3. Bottom Action Bar: ย้ายสกิลมาเรียงแนวนอนด้านล่าง =================
              _buildBottomSkillMenu(),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // 🏆 1. Top Bar กระชับ ไม่กินพื้นที่
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Color(0xFFFFD54F),
              size: 28,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4E342E).withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.amber, size: 18),
                SizedBox(width: 6),
                Text(
                  "เวลา: 05:00   |   คะแนน: 0",
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40), // Balance
        ],
      ),
    );
  }

  // 🪵 2. ตู้ไม้ 2 ตู้ x 3 ชั้น (ขยายกว้างเต็มตา)
  Widget _buildCabinet({required int cabinetIndex}) {
    return Container(
      // ... ตกแต่งตู้เดิม ...
      child: Column(
        children: List.generate(3, (shelfIndex) {
          bool isLocked = (shelfIndex == 2 && cabinetIndex == 1);
          int lockCount = 1;

          return Expanded(
            child: _buildShelf(
              cabinetIndex: cabinetIndex, // 👈 ส่ง cabinetIndex เข้าไป
              shelfIndex: shelfIndex,
              isLocked: isLocked,
              lockCount: lockCount,
            ),
          );
        }),
      ),
    );
  }

  // 🪹 3. แผ่นชั้นวางของ (เพิ่มขนาด Emoji ให้ใหญ่สะใจ)
  Widget _buildShelf({
    required int cabinetIndex,
    required int shelfIndex,
    required bool isLocked,
    required int lockCount,
  }) {
    List<String> items = cabinets[cabinetIndex][shelfIndex];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF6D4C41), width: 8)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!isLocked)
            // 🎯 บังคับทำเป็น 3 สล็อตตายตัวเสมอ
            Row(
              children: List.generate(3, (slotIndex) {
                // เช็กว่าช่องนี้มีไอเทมไหม
                bool hasItem = slotIndex < items.length;
                String item = hasItem ? items[slotIndex] : "";

                return Expanded(
                  child: Center(
                    child: hasItem
                        ? Text(item, style: const TextStyle(fontSize: 40))
                        : Container(
                            // 🔲 ช่องว่าง: ทำเป็นกรอบจางๆ ไว้ให้รู้ว่าวางของได้
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                  ),
                );
              }),
            ),

          if (isLocked)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link, color: Colors.amber, size: 32),
                  const SizedBox(width: 6),
                  Icon(Icons.lock, color: Colors.amber[300], size: 30),
                  Text(
                    " $lockCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.link, color: Colors.amber, size: 32),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSkillMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4E342E).withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF8D6E63), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomSkillButton(
            icon: Icons.card_giftcard,
            label: "กำจัดห่อใหญ่",
            count: 3,
          ),
          _buildBottomSkillButton(
            icon: Icons.published_with_changes,
            label: "สุ่มเปลี่ยน",
            count: 3,
          ),
          _buildBottomSkillButton(
            icon: Icons.autorenew_rounded,
            label: "รีเฟรชการวาง",
            count: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSkillButton({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 4),
                ],
              ),
              child: Icon(icon, color: const Color(0xFFFFECB3), size: 24),
            ),
            Positioned(
              right: -2,
              top: -2,
              child: CircleAvatar(
                radius: 9,
                backgroundColor: Colors.red[800],
                child: Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
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
          style: const TextStyle(
            color: Color(0xFFFFECB3),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
