import 'package:flutter/material.dart';

class GoodsSortPage extends StatefulWidget {
  const GoodsSortPage({super.key});

  @override
  State<GoodsSortPage> createState() => _GoodsSortPageState();
}

class _GoodsSortPageState extends State<GoodsSortPage>
    with TickerProviderStateMixin {
  final List<String> itemTypes = ["🏺", "🪭", "📜", "🪴", "🍵", "🕯️"];

  late List<List<List<String?>>> cabinets;

  // 🌟 เก็บข้อมูล Opacity ของแต่ละชั้นไว้ควบคุม Fade Animation (1.0 = ชัดปกติ, 0.2 = จาง)
  late List<List<double>> shelfOpacities;

  List<String> reservePool = [];
  int score = 0;

  List<_EffectParticle> particles = [];

  @override
  void initState() {
    super.initState();
    generateLevelData();
  }

  void generateLevelData() {
    int totalSets = 12;

    List<String> pool = [];
    for (int i = 0; i < totalSets; i++) {
      String selectedType = itemTypes[i % itemTypes.length];
      pool.addAll([selectedType, selectedType, selectedType]);
    }

    pool.shuffle();

    List<String?> frontItems = [];
    for (int i = 0; i < 12; i++) {
      frontItems.add(pool[i]);
    }
    for (int i = 0; i < 3; i++) {
      frontItems.add(null);
    }
    frontItems.shuffle();

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
      // 🌟 กำหนด Opacity เริ่มต้นให้ทุกชั้นเป็น 1.0 (ชัดปกติ)
      shelfOpacities = [
        [1.0, 1.0, 1.0],
        [1.0, 1.0, 1.0],
      ];
      score = 0;
    });
  }

  // ✨ ฟังก์ชันสำหรับเล่นอนิเมชัน Fade-in เมื่อมีของใหม่ถูกเติมลงชั้น
  void _triggerFadeInAnimation(int cabinetIndex, int shelfIndex) {
    setState(() {
      shelfOpacities[cabinetIndex][shelfIndex] = 0.2; // ทำให้จางก่อน
    });

    // ค่อยๆ ปรับให้กลับมาชัดปกติ (Fade-in)
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          shelfOpacities[cabinetIndex][shelfIndex] = 1.0;
        });
      }
    });
  }

  void moveItem({
    required int fromCabinet,
    required int fromShelf,
    required int fromSlot,
    required int toCabinet,
    required int toShelf,
    required GlobalKey shelfKey,
  }) {
    int targetSlot = cabinets[toCabinet][toShelf].indexOf(null);

    if (targetSlot == -1) return;

    if (fromCabinet == toCabinet &&
        fromShelf == toShelf &&
        fromSlot == targetSlot) {
      return;
    }

    setState(() {
      String? movedItem = cabinets[fromCabinet][fromShelf][fromSlot];
      cabinets[fromCabinet][fromShelf][fromSlot] = null;
      cabinets[toCabinet][toShelf][targetSlot] = movedItem;

      // 🎯 1. เช็กชั้นต้นทาง: ถ้าว่างเปล่าทั้ง 3 ช่อง ให้เติมของใหม่ + เล่น Fade-In
      List<String?> fromShelfItems = cabinets[fromCabinet][fromShelf];
      bool isFromShelfEmpty = fromShelfItems.every((item) => item == null);

      if (isFromShelfEmpty && reservePool.isNotEmpty) {
        List<String?> refilledItems = [];
        for (int i = 0; i < 3; i++) {
          if (reservePool.isNotEmpty) {
            refilledItems.add(reservePool.removeAt(0));
          } else {
            refilledItems.add(null);
          }
        }
        cabinets[fromCabinet][fromShelf] = refilledItems;

        // 🎬 เล่นอนิเมชัน Fade-in ของใหม่
        _triggerFadeInAnimation(fromCabinet, fromShelf);
      }

      // 🎯 2. ตรวจจับการ Match-3 ของชั้นปลายทาง
      _checkMatch3(toCabinet, toShelf, shelfKey);
    });
  }

  void _checkMatch3(int cabinetIndex, int shelfIndex, GlobalKey shelfKey) {
    List<String?> shelf = cabinets[cabinetIndex][shelfIndex];

    if (shelf[0] != null && shelf[0] == shelf[1] && shelf[1] == shelf[2]) {
      score += 100;

      _triggerSparklesEffect(shelfKey);

      List<String?> newShelfItems = [];
      bool hasRefilled = false;

      for (int i = 0; i < 3; i++) {
        if (reservePool.isNotEmpty) {
          newShelfItems.add(reservePool.removeAt(0));
          hasRefilled = true;
        } else {
          newShelfItems.add(null);
        }
      }

      cabinets[cabinetIndex][shelfIndex] = newShelfItems;

      // 🎬 ถ้ามีการเติมของใหม่หลังจาก Match-3 ให้เล่น Fade-in ด้วย
      if (hasRefilled) {
        _triggerFadeInAnimation(cabinetIndex, shelfIndex);
      }
    }
  }

  void _triggerSparklesEffect(GlobalKey shelfKey) {
    final RenderBox? renderBox =
        shelfKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final center = Offset(
      position.dx + size.width / 2,
      position.dy + size.height / 2,
    );

    setState(() {
      for (int i = 0; i < 10; i++) {
        particles.add(
          _EffectParticle(
            x: center.dx + (i % 2 == 0 ? i * 8 : -i * 8),
            y: center.dy,
            text: i % 2 == 0 ? "✨" : "⭐",
            fontSize: 24,
          ),
        );
      }
      particles.add(
        _EffectParticle(
          x: center.dx - 30,
          y: center.dy - 10,
          text: "+100",
          fontSize: 28,
          isScoreText: true,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          particles.removeWhere((p) => p.isFinished);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ...particles.map((p) => _AnimatedSparkle(particle: p)),
        ],
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
    GlobalKey shelfKey = GlobalKey();

    return DragTarget<Map<String, dynamic>>(
      key: shelfKey,
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
          shelfKey: shelfKey,
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
                // 🌟 หุ้มไอเทมด้วย AnimatedOpacity เพื่อสร้างเอฟเฟกต์ Fade-In นุ่มๆ
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInQuad,
                  opacity: shelfOpacities[cabinetIndex][shelfIndex],
                  child: Row(
                    children: List.generate(3, (slotIndex) {
                      String? item = items[slotIndex];
                      bool hasItem = item != null;

                      return Expanded(
                        child: Center(
                          child: hasItem
                              ? Draggable<Map<String, dynamic>>(
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

class _EffectParticle {
  final double x;
  final double y;
  final String text;
  final double fontSize;
  final bool isScoreText;
  bool isFinished = false;

  _EffectParticle({
    required this.x,
    required this.y,
    required this.text,
    required this.fontSize,
    this.isScoreText = false,
  });
}

class _AnimatedSparkle extends StatefulWidget {
  final _EffectParticle particle;

  const _AnimatedSparkle({required this.particle});

  @override
  State<_AnimatedSparkle> createState() => _AnimatedSparkleState();
}

class _AnimatedSparkleState extends State<_AnimatedSparkle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetY;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetY = Tween<double>(
      begin: 0,
      end: -60,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _scale = Tween<double>(
      begin: 0.5,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward().then((_) {
      widget.particle.isFinished = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.particle.x,
          top: widget.particle.y + _offsetY.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: widget.particle.isScoreText
                  ? Text(
                      widget.particle.text,
                      style: const TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8),
                          Shadow(color: Colors.amber, blurRadius: 16),
                        ],
                      ),
                    )
                  : Text(
                      widget.particle.text,
                      style: TextStyle(fontSize: widget.particle.fontSize),
                    ),
            ),
          ),
        );
      },
    );
  }
}
