import 'package:flutter/material.dart';

class GoodsSortPage extends StatefulWidget {
  const GoodsSortPage({super.key});

  @override
  State<GoodsSortPage> createState() => _GoodsSortPageState();
}

class _GoodsSortPageState extends State<GoodsSortPage> {
  final List<String> itemTypes = ["🏺", "🪭", "📜", "🪴", "🍵", "🕯️"];

  late List<List<List<String?>>> cabinets;
  List<String> reservePool = []; // 📦 คลังสำรองหลังตู้
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateLevelData();
  }

  void generateLevelData() {
    // 1. สร้างของทั้งหมด 12 ชุด (36 ชิ้น)
    int totalSets = 12;

    List<String> pool = [];
    for (int i = 0; i < totalSets; i++) {
      String selectedType = itemTypes[i % itemTypes.length];
      pool.addAll([selectedType, selectedType, selectedType]);
    }

    pool.shuffle(); // เขย่าของ

    // 2. ดึงแค่ 12 ชิ้นแรกมาวางหน้าตู้ + เติม null อีก 3 ช่องให้ครบ 15 ช่อง (เพื่อให้มีช่องว่าง 3 ช่องเสมอ!)
    List<String?> frontItems = [];
    for (int i = 0; i < 12; i++) {
      frontItems.add(pool[i]);
    }
    for (int i = 0; i < 3; i++) {
      frontItems.add(null); // 🔲 ช่องว่าง 3 ช่อง
    }
    frontItems.shuffle(); // สุ่มกระจายช่องว่างให้ปะปนบนชั้นวาง

    // 3. ของที่เหลืออีก 24 ชิ้น เก็บไว้เป็นคลังหลังตู้เพื่อรอเติมตอน Match-3
    reservePool = pool.sublist(12);

    List<List<List<String?>>> newCabinets = [];
    bool hasInitialMatch = true;

    while (hasInitialMatch) {
      frontItems.shuffle();
      newCabinets = [];
      hasInitialMatch = false;
      int itemIndex = 0;

      for (int c = 0; c < 2; c++) {
        List<List<String?>> shelves = [];
        for (int s = 0; s < 3; s++) {
          bool isLocked = (s == 2 && c == 1);

          if (isLocked) {
            shelves.add([null, null, null]);
          } else {
            List<String?> shelfItems = [];
            for (int i = 0; i < 3; i++) {
              shelfItems.add(frontItems[itemIndex++]);
            }

            // เช็กไม่ให้ตรงกัน 3 ชิ้นตั้งแต่แรก
            if (shelfItems[0] != null &&
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
      score = 0;
    });
  }

  // 🚚 ฟังก์ชันย้ายไอเทม (ย้ายไปช่องว่างเฉยๆ ไม่เติมของ)
  void moveItem({
    required int fromCabinet,
    required int fromShelf,
    required int fromSlot,
    required int toCabinet,
    required int toShelf,
  }) {
    // หาช่องว่างแรก (null) ในชั้นปลายทาง
    int targetSlot = cabinets[toCabinet][toShelf].indexOf(null);

    // ถ้าชั้นปลายทางไม่มีช่องว่างเลย ย้ายไม่ได้
    if (targetSlot == -1) return;

    if (fromCabinet == toCabinet &&
        fromShelf == toShelf &&
        fromSlot == targetSlot) {
      return;
    }

    setState(() {
      // 1. ดึงของออกจากช่องเดิม -> ช่องเดิมกลายเป็น null (กลายเป็นช่องว่างใหม่)
      String? movedItem = cabinets[fromCabinet][fromShelf][fromSlot];
      cabinets[fromCabinet][fromShelf][fromSlot] = null;

      // 2. นำไปวางในช่องว่างของชั้นใหม่
      cabinets[toCabinet][toShelf][targetSlot] = movedItem;

      // 3. เช็กเฉพาะการ Match-3
      _checkMatch3(toCabinet, toShelf);
    });
  }

  // ✨ ฟังก์ชัน Match-3: สลายแล้ว "เติมของใหม่เฉพาะตอนที่ Match-3 สำเร็จ"
  void _checkMatch3(int cabinetIndex, int shelfIndex) {
    List<String?> shelf = cabinets[cabinetIndex][shelfIndex];

    if (shelf[0] != null && shelf[0] == shelf[1] && shelf[1] == shelf[2]) {
      score += 100;

      // ถ้าในคลังหลังตู้ยังมีของเหลือ -> ดึงของใหม่ 3 ชิ้นมาเติมลงชั้นนี้
      // ถ้าคลังหมด -> ให้กลายเป็นชั้นว่างเปล่า [null, null, null]
      List<String?> newShelfItems = [];
      for (int i = 0; i < 3; i++) {
        if (reservePool.isNotEmpty) {
          newShelfItems.add(reservePool.removeAt(0));
        } else {
          newShelfItems.add(null);
        }
      }

      cabinets[cabinetIndex][shelfIndex] = newShelfItems;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✨ จับคู่สำเร็จ! +100 คะแนน (ของในคลังเหลือ: ${reservePool.length})",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: const Duration(milliseconds: 900),
          backgroundColor: Colors.amber,
        ),
      );
    }
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
              _buildTopBar(context),
              const SizedBox(height: 12),
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
              _buildBottomSkillMenu(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

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
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  "เวลา: 05:00   |   คะแนน: $score",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildCabinet({required int cabinetIndex}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3E2723),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8D6E63), width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: List.generate(3, (shelfIndex) {
          bool isLocked = (shelfIndex == 2 && cabinetIndex == 1);
          int lockCount = 1;

          return Expanded(
            child: _buildShelf(
              cabinetIndex: cabinetIndex,
              shelfIndex: shelfIndex,
              isLocked: isLocked,
              lockCount: lockCount,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShelf({
    required int cabinetIndex,
    required int shelfIndex,
    required bool isLocked,
    required int lockCount,
  }) {
    List<String?> items = cabinets[cabinetIndex][shelfIndex];

    return DragTarget<Map<String, int>>(
      onWillAcceptWithDetails: (details) {
        return !isLocked && items.contains(null);
      },
      onAcceptWithDetails: (details) {
        final data = details.data;
        moveItem(
          fromCabinet: data['cabinet']!,
          fromShelf: data['shelf']!,
          fromSlot: data['slot']!,
          toCabinet: cabinetIndex,
          toShelf: shelfIndex,
        );
      },
      builder: (context, candidateData, rejectedData) {
        bool isHovered = candidateData.isNotEmpty;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.amber.withOpacity(0.15)
                : Colors.transparent,
            border: const Border(
              bottom: BorderSide(color: Color(0xFF6D4C41), width: 8),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!isLocked)
                Row(
                  children: List.generate(3, (slotIndex) {
                    String? item = items[slotIndex];
                    bool hasItem = item != null;

                    return Expanded(
                      child: Center(
                        child: hasItem
                            ? Draggable<Map<String, int>>(
                                data: {
                                  'cabinet': cabinetIndex,
                                  'shelf': shelfIndex,
                                  'slot': slotIndex,
                                },
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 54),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.2,
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              )
                            : Container(
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
      },
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
