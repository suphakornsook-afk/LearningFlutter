import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // เพิ่ม import นี้
import 'package:shared_preferences/shared_preferences.dart';
// สมมติว่าไฟล์ NotiService ของคุณชื่อ noti_service.dart อย่าลืมเปลี่ยน path ให้ตรงนะครับ
import 'package:flutter_application_2/pages/noti_service.dart';

class PillModel {
  final String name;
  final int hour;
  final int minute;
  bool isTaken;

  PillModel({
    required this.name,
    required this.hour,
    required this.minute,
    this.isTaken = false,
  });

  // สร้าง ID ที่ไม่ซ้ำกันจากชื่อและเวลา เพื่อใช้ผูกกับระบบ Notification
  int get uniqueId {
    return (name.hashCode + hour + minute).abs() % 100000;
  }

  String get formattedTime {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  factory PillModel.fromJson(Map<String, dynamic> json) => PillModel(
    name: json['name'],
    hour: json['hour'],
    minute: json['minute'],
    isTaken: json['isTaken'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'hour': hour,
    'minute': minute,
    'isTaken': isTaken,
  };
}

class PillTrackerPage extends StatefulWidget {
  const PillTrackerPage({super.key});

  @override
  State<PillTrackerPage> createState() => _PillTrackerPageState();
}

class _PillTrackerPageState extends State<PillTrackerPage> {
  List<PillModel> pills = [];
  // ประกาศตัวแปร NotiService ไว้เรียกใช้งานทั่วทั้งหน้าย่อยนี้
  final NotiService _notiService = NotiService();

  int selectedHour = 1;
  int selectedMinute = 50;

  @override
  void initState() {
    super.initState();
    _loadPills();
  }

  Future<void> _loadPills() async {
    final prefs = await SharedPreferences.getInstance();
    final String? pillsString = prefs.getString('saved_pills');

    if (pillsString != null) {
      final List<dynamic> decodedList = jsonDecode(pillsString);
      setState(() {
        pills = decodedList.map((item) => PillModel.fromJson(item)).toList();
      });
    } else {
      // ตั้งค่าเริ่มต้นของแอป และจองเวลาแจ้งเตือนสำหรับยาสองตัวแรก
      final defaultPills = [
        PillModel(name: "Paracetamol", hour: 8, minute: 0),
        PillModel(name: "Aspirin", hour: 18, minute: 0),
      ];

      setState(() {
        pills = defaultPills;
      });
      _savePills();

      // สั่งเปิดจองคิวแจ้งเตือนสำหรับชุดเริ่มต้น
      for (var pill in defaultPills) {
        await _notiService.scheduleNotification(
          id: pill.uniqueId,
          title: "ได้เวลาทานยาแล้ว 💊",
          body: "อย่าลืมทานยา ${pill.name} ของคุณนะ",
          hour: pill.hour,
          minute: pill.minute,
        );
      }
    }
  }

  Future<void> _savePills() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      pills.map((pill) => pill.toJson()).toList(),
    );
    await prefs.setString('saved_pills', encodedList);
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _showAddPillSheet() {
    selectedHour = 8;
    selectedMinute = 0;
    _nameController.clear();
    _timeController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add More Pill.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Pill Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medication),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Pill Time",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  setState(() {
                    selectedHour = pickedTime.hour;
                    selectedMinute = pickedTime.minute;
                    final String formatted =
                        "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                    _timeController.text = formatted;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _timeController.text.isEmpty) {
                    return;
                  }
                  List<String> timeParts = _timeController.text.split(':');
                  int finalHour = int.parse(timeParts[0]); // ได้ 11
                  int finalMinute = int.parse(timeParts[1]); // ได้ 30

                  final newPill = PillModel(
                    name: _nameController.text,
                    hour: selectedHour,
                    minute: selectedMinute,
                  );

                  setState(() {
                    pills.add(newPill);
                  });

                  // บันทึกลงเครื่อง
                  await _savePills();

                  // 🔥 จุดเชื่อมที่ 1: สั่งจองคิวแจ้งเตือนทันทีที่เพิ่มยาสำเร็จ
                  await NotiService().scheduleNotification(
                    id: 1,
                    title: "ได้เวลาทานยาแล้ว 💊",
                    body: "อย่าลืมทานยา ${newPill.name} ของคุณนะ",
                    hour: finalHour,
                    minute: finalMinute,
                  );

                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(225, 1, 93, 84),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save Pill", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Pill Tracker Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 144, 224, 239),
                Color.fromARGB(255, 1, 93, 84),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Today's Pills",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pills.length,
                      itemBuilder: (context, index) {
                        final pill = pills[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: pill.isTaken
                                ? Colors.white.withOpacity(0.6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            onTap: () {
                              setState(() {
                                pill.isTaken = !pill.isTaken;
                              });
                              _savePills();
                            },
                            leading: CircleAvatar(
                              backgroundColor: pill.isTaken
                                  ? Colors.grey
                                  : Colors.cyan.shade100,
                              child: Icon(
                                Icons.medication,
                                color: pill.isTaken
                                    ? Colors.black38
                                    : Colors.cyan.shade700,
                              ),
                            ),
                            title: Text(
                              pill.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: pill.isTaken
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: pill.isTaken
                                    ? Colors.black38
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "Time: ${pill.formattedTime}",
                              style: TextStyle(
                                color: pill.isTaken
                                    ? Colors.grey
                                    : Colors.black54,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    // 🔥 จุดเชื่อมที่ 2: ลบระบบสั่นเตือนของตัวยานี้ทิ้งก่อน แล้วค่อยลบออกจาก List
                                    await _notiService.notificationsPlugin
                                        .cancel(id: pill.uniqueId);

                                    setState(() {
                                      pills.removeAt(index);
                                    });
                                    _savePills();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    pill.isTaken
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: pill.isTaken
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pill.isTaken = !pill.isTaken;
                                    });
                                    _savePills();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Go Back"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          NotiService().scheduleNotification(
                            title: "pill tracker",
                            body: "pill",
                            hour: 12,
                            minute: 43,
                          );
                        },
                        child: Text("Schedul noti"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPillSheet,
        backgroundColor: Colors.white70,
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 1, 93, 84),
          size: 30,
        ),
      ),
    );
  }
}
