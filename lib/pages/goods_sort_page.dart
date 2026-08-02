import 'dart:math';
import 'package:flutter/material.dart';

import '../controllers/goods_sort_controller.dart';
import '../models/effect_particle.dart';
import '../views/widgets/animated_sparkle.dart';

class GoodsSortPage extends StatefulWidget {
  const GoodsSortPage({super.key});

  @override
  State<GoodsSortPage> createState() => _GoodsSortPageState();
}

class _GoodsSortPageState extends State<GoodsSortPage> {
  // ⚙️ เรียกใช้ Controller จัดการ Logic
  final GoodsSortController _controller = GoodsSortController();
  bool _hasShownWinDialog = false;
  List<EffectParticle> particles = [];
  bool _isWinDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _controller.generateLevelData();
  }

  // 🎬 ฟังก์ชันอนิเมชัน Fade-in
  void _triggerFadeInAnimation(int cabinetIndex, int shelfIndex) {
    setState(() {
      _controller.shelfOpacities[cabinetIndex][shelfIndex] = 0.2;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _controller.shelfOpacities[cabinetIndex][shelfIndex] = 1.0;
        });
      }
    });
  }

  // 🚚 ย้ายไอเทม
  // 🚚 ย้ายไอเทม
  void _handleMoveItem({
    required int fromCabinet,
    required int fromShelf,
    required int fromSlot,
    required int toCabinet,
    required int toShelf,
    required GlobalKey shelfKey,
  }) {
    setState(() {
      bool moved = _controller.moveItem(
        fromCabinet: fromCabinet,
        fromShelf: fromShelf,
        fromSlot: fromSlot,
        toCabinet: toCabinet,
        toShelf: toShelf,
        triggerFadeAnimation: _triggerFadeInAnimation,
      );

      if (moved) {
        bool isMatched = _controller.checkMatch3(
          cabinetIndex: toCabinet,
          shelfIndex: toShelf,
          triggerFadeAnimation: _triggerFadeInAnimation,
          onUnlock: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "🔓 ปลดล็อกชั้นวางสำเร็จ! ขยายพื้นที่วางของเพิ่มแล้ว",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                duration: Duration(milliseconds: 1500),
                backgroundColor: Colors.green,
              ),
            );
          },
        );

        if (isMatched) {
          _triggerSparklesEffect(shelfKey);
        }

        // 🎯 ตรวจสอบว่าชนะเกมหรือยังทุกครั้งที่มีการย้าย/จับคู่สำเร็จ
        _checkGameWin();
      }
    });
  }

  // 🔄 ใช้สกิลสุ่มเปลี่ยน
  void _handleShuffleSkill() {
    bool success = _controller.useShuffleSkill(
      triggerFadeAnimation: _triggerFadeInAnimation,
    );

    if (success) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("สิทธิ์การใช้สกิลหมดแล้ว!"),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  // ✨ สร้าง Sparkle Effect
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
          EffectParticle(
            x: center.dx + (i % 2 == 0 ? i * 8 : -i * 8),
            y: center.dy,
            text: i % 2 == 0 ? "✨" : "⭐",
            fontSize: 24,
          ),
        );
      }
      particles.add(
        EffectParticle(
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

  void _checkGameWin() {
    if (_isWinDialogShowing) return;

    if (_controller.checkGameWin()) {
      _isWinDialogShowing = true;
      // รอให้ Frame ปัจจุบันวาดเสร็จสมบูรณ์ก่อนเรียกเปิด Dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showWinDialog();
        }
      });
    }
  }

  // 🏆 Popup แสดงชัยชนะ
  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF3E2723),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFFD54F), width: 2),
        ),
        title: const Text(
          "🎉 ชัยชนะ!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "คุณเก่งมาก! เคลียร์ของบนชั้นวางหมดเรียบร้อยแล้ว",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "คะแนนรวม: ${_controller.score}",
              style: const TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.replay),
              label: const Text(
                "เล่นใหม่อีกครั้ง",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onPressed: () {
                // 1. ปิด Dialog ก่อน
                Navigator.of(dialogContext).pop();

                // 2. เช็ก mounted ก่อนสั่ง setState เริ่มเกมใหม่
                if (mounted) {
                  setState(() {
                    _isWinDialogShowing = false;
                    _controller.generateLevelData();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
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
          ...particles.map((p) => AnimatedSparkle(particle: p)),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4E342E).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  "เวลา: 05:00   |   คะแนน: ${_controller.score}",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFFFFD54F),
              size: 28,
            ),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _isWinDialogShowing = false;
                  _controller.generateLevelData();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🔄 เริ่มเกมใหม่เรียบร้อย!"),
                    duration: Duration(milliseconds: 800),
                  ),
                );
              }
            },
          ),
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
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: List.generate(3, (shelfIndex) {
          bool isLocked =
              (shelfIndex == 2 &&
              cabinetIndex == 1 &&
              !_controller.isCabinetUnlocked);
          int lockCount = max(
            0,
            _controller.unlockRequirement - _controller.matchesCount,
          );

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
    List<String?> items = _controller.cabinets[cabinetIndex][shelfIndex];
    GlobalKey shelfKey = GlobalKey();

    return DragTarget<Map<String, dynamic>>(
      key: shelfKey,
      onWillAcceptWithDetails: (details) {
        return !isLocked && items.contains(null);
      },
      onAcceptWithDetails: (details) {
        final data = details.data;
        _handleMoveItem(
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
                ? Colors.amber.withValues(alpha: 0.15)
                : Colors.transparent,
            border: const Border(
              bottom: BorderSide(color: Color(0xFF6D4C41), width: 8),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!isLocked)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInQuad,
                  opacity: _controller.shelfOpacities[cabinetIndex][shelfIndex],
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
                                    color: Colors.black.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.amber.withValues(
                                        alpha: 0.2,
                                      ),
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
                  color: Colors.black.withValues(alpha: 0.5),
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
        color: const Color(0xFF4E342E).withValues(alpha: 0.85),
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
            onTap: () {},
          ),
          _buildBottomSkillButton(
            icon: Icons.published_with_changes,
            label: "สุ่มเปลี่ยน",
            count: _controller.shuffleSkillCount,
            onTap: _handleShuffleSkill,
          ),
          _buildBottomSkillButton(
            icon: Icons.autorenew_rounded,
            label: "รีเฟรชการวาง",
            count: 3,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSkillButton({
    required IconData icon,
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: count > 0 ? const Color(0xFF8D6E63) : Colors.grey[700],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: count > 0 ? const Color(0xFFFFD54F) : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 4),
                  ],
                ),
                child: Icon(
                  icon,
                  color: count > 0 ? const Color(0xFFFFECB3) : Colors.grey[400],
                  size: 24,
                ),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: count > 0
                      ? Colors.red[800]
                      : Colors.grey[800],
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
            style: TextStyle(
              color: count > 0 ? const Color(0xFFFFECB3) : Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
