import 'package:flutter/material.dart';

class MashupPage extends StatefulWidget {
  const MashupPage({super.key});

  @override
  State<MashupPage> createState() => _MashupPageState();
}

class _MashupPageState extends State<MashupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Mashup Frontend", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade200, Colors.blue.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //ลูก1 ไว้ใส่ภาพ
                  Image.asset(
                    "assets/images/ComfyUI_temp_qqdlf_00002_.png",
                    width: 100,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mini Topic",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Mashup \nDo Frontend things here",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 20),
                      Text(
                        "ลองฝึกทำ frontend หลายๆแบบครับ \nไม่รู้ว่าจะสำเร็จไหม \nแต่ก็อยากลองทำดูครับ \nผมหวังว่าวันนึงผมจะมีงานทำ \nภาพที่ผมใช้ ผม generated มาจาก ComfyUI ครับ",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
