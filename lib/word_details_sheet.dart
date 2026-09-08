import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'tts_service.dart';

void showWordDetailsSheet(BuildContext context, {required String word, required TtsService tts}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(word,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                _CircleIconButton(
                  icon: Icons.volume_up_rounded,
                  onTap: () => tts.speak(word),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('IPA not available yet', style: TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text('Meaning', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            const Text('Dictionary lookup coming soon.', style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      );
    },
  );
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
