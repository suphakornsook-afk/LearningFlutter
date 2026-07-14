import 'package:flutter/material.dart';

class SkillCardData {
  final String name;
  final String description;
  final IconData icon;
  final Function(dynamic state) action;

  SkillCardData({
    required this.name,
    required this.description,
    required this.icon,
    required this.action,
  });
}

List<SkillCardData> getAvailableSkills(
  BuildContext context, {
  required VoidCallback onScanActive,
}) {
  return [
    SkillCardData(
      name: "Scan Area",
      description: "Border Cut 10%",
      icon: Icons.radar,
      action: (_) => onScanActive(),
    ),
    SkillCardData(
      name: "Lucky Radar",
      description: "Give odd or even number hint",
      icon: Icons.psychology,
      action: (_) {
        //TODO Skill
      },
    ),
    SkillCardData(
      name: "Change BGC",
      description: "Try This!!",
      icon: Icons.radar,
      action: (_) {
        //Todo
      },
    ),
  ];
}
