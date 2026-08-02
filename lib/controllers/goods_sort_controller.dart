import 'dart:math';
import 'package:flutter/material.dart';

class GoodsSortController {
  final List<String> itemTypes = ["🏺", "🪭", "📜", "🪴", "🍵", "🕯️"];

  late List<List<List<String?>>> cabinets;
  late List<List<double>> shelfOpacities;

  List<String> reservePool = [];
  int score = 0;
  int shuffleSkillCount = 3;

  int matchesCount = 0;
  final int unlockRequirement = 2;
  bool isCabinetUnlocked = false;

  // 🔄 เริ่มเกมใหม่ / รีเซ็ตข้อมูลทั้งหมด
  void generateLevelData() {
    // 🎯 [จุดสำคัญ] ต้องรีเซ็ตสถานะปลดล็อกเป็น false ก่อนเริ่มสร้างด่านเสมอ!
    isCabinetUnlocked = false;
    matchesCount = 0;
    score = 0;
    shuffleSkillCount = 3;

    int totalSets = 24;

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
          // คราวนี้ isCabinetUnlocked เป็น false แน่นอน ชั้นล็อกจะทำงานถูกต้อง
          bool isLocked = (s == 2 && c == 1 && !isCabinetUnlocked);

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

    cabinets = newCabinets;
    shelfOpacities = [
      [1.0, 1.0, 1.0],
      [1.0, 1.0, 1.0],
    ];
  }

  // 🚚 ย้ายไอเทม
  bool moveItem({
    required int fromCabinet,
    required int fromShelf,
    required int fromSlot,
    required int toCabinet,
    required int toShelf,
    required Function(int, int) triggerFadeAnimation,
  }) {
    int targetSlot = cabinets[toCabinet][toShelf].indexOf(null);

    if (targetSlot == -1) return false;

    if (fromCabinet == toCabinet &&
        fromShelf == toShelf &&
        fromSlot == targetSlot) {
      return false;
    }

    String? movedItem = cabinets[fromCabinet][fromShelf][fromSlot];
    cabinets[fromCabinet][fromShelf][fromSlot] = null;
    cabinets[toCabinet][toShelf][targetSlot] = movedItem;

    // เช็กชั้นต้นทางถ้าว่างเปล่าให้เติมของ
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
      triggerFadeAnimation(fromCabinet, fromShelf);
    }

    return true;
  }

  // ✨ เช็ก Match-3
  bool checkMatch3({
    required int cabinetIndex,
    required int shelfIndex,
    required Function(int, int) triggerFadeAnimation,
    required VoidCallback onUnlock,
  }) {
    List<String?> shelf = cabinets[cabinetIndex][shelfIndex];

    if (shelf[0] != null && shelf[0] == shelf[1] && shelf[1] == shelf[2]) {
      score += 100;
      matchesCount++;

      if (!isCabinetUnlocked && matchesCount >= unlockRequirement) {
        unlockShelf(triggerFadeAnimation: triggerFadeAnimation);
        onUnlock();
      }

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

      if (hasRefilled) {
        triggerFadeAnimation(cabinetIndex, shelfIndex);
      }

      return true;
    }
    return false;
  }

  // 🔓 ปลดล็อกชั้นวาง
  void unlockShelf({required Function(int, int) triggerFadeAnimation}) {
    isCabinetUnlocked = true;

    List<String?> unlockedShelfItems = [];
    for (int i = 0; i < 3; i++) {
      if (reservePool.isNotEmpty) {
        unlockedShelfItems.add(reservePool.removeAt(0));
      } else {
        unlockedShelfItems.add(null);
      }
    }
    cabinets[1][2] = unlockedShelfItems;
    triggerFadeAnimation(1, 2);
  }

  // 🔄 ใช้สกิลสุ่มเปลี่ยน
  bool useShuffleSkill({required Function(int, int) triggerFadeAnimation}) {
    if (shuffleSkillCount <= 0) return false;

    List<String> realItems = [];
    for (int c = 0; c < 2; c++) {
      for (int s = 0; s < 3; s++) {
        bool isLocked = (s == 2 && c == 1 && !isCabinetUnlocked);
        if (!isLocked) {
          for (var item in cabinets[c][s]) {
            if (item != null) {
              realItems.add(item);
            }
          }
        }
      }
    }

    int totalAvailableSlots = isCabinetUnlocked ? 18 : 15;

    final random = Random();
    int randomEmptySlots = random.nextInt(4) + 2;
    int targetItemsCount = totalAvailableSlots - randomEmptySlots;

    while (realItems.length < targetItemsCount && reservePool.isNotEmpty) {
      realItems.add(reservePool.removeAt(0));
    }
    while (realItems.length > targetItemsCount) {
      reservePool.insert(0, realItems.removeLast());
    }

    int finalEmptySlots = totalAvailableSlots - realItems.length;

    List<String?> finalBoardSlots = [];
    for (var item in realItems) {
      finalBoardSlots.add(item);
    }
    for (int i = 0; i < finalEmptySlots; i++) {
      finalBoardSlots.add(null);
    }

    List<List<List<String?>>> bestCabinets = [];
    for (int attempt = 0; attempt < 50; attempt++) {
      finalBoardSlots.shuffle();

      List<List<List<String?>>> tempCabinets = [];
      int slotIndex = 0;
      bool hasInitialMatch = false;

      for (int c = 0; c < 2; c++) {
        List<List<String?>> shelves = [];
        for (int s = 0; s < 3; s++) {
          bool isLocked = (s == 2 && c == 1 && !isCabinetUnlocked);
          if (isLocked) {
            shelves.add([null, null, null]);
          } else {
            List<String?> shelfItems = [
              finalBoardSlots[slotIndex++],
              finalBoardSlots[slotIndex++],
              finalBoardSlots[slotIndex++],
            ];

            if (shelfItems[0] != null &&
                shelfItems[0] == shelfItems[1] &&
                shelfItems[1] == shelfItems[2]) {
              hasInitialMatch = true;
            }

            shelves.add(shelfItems);
          }
        }
        tempCabinets.add(shelves);
      }

      bestCabinets = tempCabinets;
      if (!hasInitialMatch) break;
    }

    cabinets = bestCabinets;

    for (int c = 0; c < 2; c++) {
      for (int s = 0; s < 3; s++) {
        bool isLocked = (s == 2 && c == 1 && !isCabinetUnlocked);
        if (!isLocked) {
          triggerFadeAnimation(c, s);
        }
      }
    }

    shuffleSkillCount--;
    return true;
  }

  // 🏆 เช็กชนะเกม
  bool checkGameWin() {
    if (reservePool.isNotEmpty) return false;

    for (int c = 0; c < 2; c++) {
      for (int s = 0; s < 3; s++) {
        for (var item in cabinets[c][s]) {
          if (item != null) return false;
        }
      }
    }
    return true;
  }
}
