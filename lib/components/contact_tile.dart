import 'package:flutter/material.dart';

class ContactTile extends StatefulWidget {
  const ContactTile({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.contactTitle,
    required this.contactIcon,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String contactTitle;
  final IconData contactIcon;

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  FocusNode focusNode = FocusNode(descendantsAreFocusable: false);

  @override 
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      focusNode: focusNode,
      title: Text(widget.contactTitle),
      secondary: Icon(widget.contactIcon),
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}