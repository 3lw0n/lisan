import 'package:flutter/material.dart';

/// إطار بديل واضح يظهر مكان أي أصل لم يُضف بعد.
class MissingAssetBox extends StatelessWidget {
  const MissingAssetBox({super.key, required this.message, this.height});

  final String message;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }
}
