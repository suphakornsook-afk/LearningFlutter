import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //column for profile picture and name
          Column(
            children: [
              //profile picture
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              SizedBox(height: 10),
              //name
              Text(
                "Suphakorn Sooktongsa",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Anything you want me to be.",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 84, 84, 84),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          const SizedBox(height: 25),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profileCompletionCards.length,
            itemBuilder: (context, index) {
              final tile = profileCompletionCards[index];
              return Card(
                child: ListTile(
                  leading: Icon(tile.icon),
                  title: Text(tile.title),
                  subtitle: Text(tile.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => tile.targetPage),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileCompletionCard {
  final String title;
  final String description;
  final IconData icon;
  final Widget targetPage;
  ProfileCompletionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.targetPage,
  });
}

List<ProfileCompletionCard> profileCompletionCards = [
  ProfileCompletionCard(
    title: "Editing your profile",
    description: "Edit your profile information at any time.",
    icon: Icons.person,
    targetPage: SettingsPage(),
  ),
  ProfileCompletionCard(
    title: "Notifications",
    description: "Manage your notification preferences.",
    icon: Icons.notifications,
    targetPage: SettingsPage(),
  ),
  ProfileCompletionCard(
    title: "Password & Security",
    description: "Update your password and manage your security settings.",
    icon: Icons.lock,
    targetPage: SettingsPage(),
  ),
  ProfileCompletionCard(
    title: "Settings",
    description: "Access and modify your app settings.",
    icon: Icons.settings,
    targetPage: SettingsPage(),
  ),
];
