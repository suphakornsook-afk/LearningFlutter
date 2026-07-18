import 'package:flutter/material.dart';

class SkillCardData {
  final String name;
  final String description;
  final IconData icon;
  final Function(dynamic pageState) action;

  SkillCardData({
    required this.name,
    required this.description,
    required this.icon,
    required this.action,
  });
}

List<SkillCardData> getAvailableSkills(BuildContext context) {
  return [
    SkillCardData(
      name: "Scan Area",
      description: "Border Cut 10%",
      icon: Icons.radar,
      action: (pageState) {
        pageState.useScanAreaSkill();
      },
    ),
    SkillCardData(
      name: "Lucky Radar",
      description: "Give odd or even number hint",
      icon: Icons.psychology,
      action: (pageState) {
        final target = pageState.targetNumber;
        final isEven = target % 2 == 0;
        pageState.setState(() {
          pageState.hintMessage =
              "Radar Reveal:\nThe Secret number is ${isEven ? 'Even (เลขคู่)' : 'Odd (เลขคี่)'}!";
          pageState.hintColor = Colors.teal[700]!;
        });
      },
    ),
    SkillCardData(
      name: "Change BGC",
      description: "Try This!!",
      icon: Icons.palette,
      action: (pageState) {
        pageState.changeBackgroundColors();
      },
    ),
    SkillCardData(
      name: "Time Stone",
      description: "Decrease Number of Guess Counter",
      icon: Icons.hourglass_bottom,
      action: (pageState) {
        pageState.useTimeStoneSkill();
      },
    ),
    SkillCardData(
      name: "The Shield",
      description: "Shield your next blunder doesn't count",
      icon: Icons.shield,
      action: (pageState) {
        pageState.useShieldSkill();
      },
    ),
    SkillCardData(
      name: "Hot & Cold",
      description: "Giving more hint to this round",
      icon: Icons.thermostat,
      action: (pageState) {
        pageState.useHotAndColdSkill();
      },
    ),
  ];
}
