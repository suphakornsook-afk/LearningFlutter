import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    // TODO: implement initState
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
      setState(() {
        pills = [
          PillModel(name: "Paracetamol", hour: 8, minute: 0),
          PillModel(name: "Aspirin", hour: 18, minute: 0),
        ];
      });
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
    int selectedHour = 8;
    int selectedMinute = 0;
    _nameController.clear();
    _timeController.clear();

    showModalBottomSheet(
      //space
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          //space
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsetsGeometry.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add More Pill.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
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
                  selectedHour = pickedTime.hour;
                  selectedMinute = pickedTime.minute;
                  final String formatted =
                      "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                  setState(() {
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
                //space
                onPressed: () {
                  if (_nameController.text.isEmpty ||
                      _timeController.text.isEmpty)
                    return;

                  setState(() {
                    pills.add(
                      PillModel(
                        name: _nameController.text,
                        hour: selectedHour,
                        minute: selectedMinute,
                      ),
                    );
                  });
                  _savePills();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(225, 1, 93, 84),
                  foregroundColor: Colors.white,
                ),
                child: Text("Save Pill", style: TextStyle(fontSize: 16)),
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
        //transparent appbar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Pill Tracker Page", style: TextStyle(color: Colors.black)),
      ),

      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 144, 224, 239),
                const Color.fromARGB(255, 1, 93, 84),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Today's Pills",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pills.length,
                      itemBuilder: (context, index) {
                        final pill = pills[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: pill.isTaken
                                ? Colors.white.withOpacity(0.6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
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
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
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
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                      label: Text("Go Back"),
                    ),
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
        child: Icon(Icons.add, color: Color.fromARGB(255, 1, 93, 84), size: 30),
      ),
    );
  }
}
