import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade200, Colors.blue.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 475,
                            height: 300,
                            clipBehavior: Clip.antiAlias,
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
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.deepOrange,
                                    padding: const EdgeInsets.all(16.0),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "Home",
                                          style: GoogleFonts.bigShoulders(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "This is a sample description for the Work section. You can add more details...",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    color: Colors.teal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.work,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "Work",
                                          style: GoogleFonts.bigShoulders(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "This is a sample description for the Work section. You can add more details...",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    color: Colors.brown,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.yard,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "Yard",
                                          style: GoogleFonts.bigShoulders(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "This is a sample description for the Work section. You can add more details...",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          Container(
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
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
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
