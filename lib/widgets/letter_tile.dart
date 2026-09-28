import 'package:flutter/material.dart';

import '../data/letter.dart';
import '../theme/app_theme.dart';

class LetterTile extends StatelessWidget {
  const LetterTile({
    super.key,
    required this.letter,
    required this.completed,
    required this.onTap,
  });

  final Letter letter;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey('tile_${letter.nameEn}'),
      color: completed ? AppTheme.completed : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: completed ? AppTheme.completedBorder : Colors.black12,
          width: completed ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Text(letter.letter, style: const TextStyle(fontSize: 40)),
        ),
      ),
    );
  }
}
