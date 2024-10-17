import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/post_model.dart';

class SharePostSheet extends StatefulWidget {
  const SharePostSheet({super.key, required this.postData});

  final MyPost postData;

  @override
  State<SharePostSheet> createState() => _SharePostSheetState();
}

class _SharePostSheetState extends State<SharePostSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
