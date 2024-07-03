import 'package:flutter/material.dart';

class DetailBox extends StatelessWidget {
  final String section;
  final String text;
  final void Function()? onPressed;
  final Icon? icon;
  const DetailBox({
    super.key,
    required this.section,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: onPressed != null ? 4.0 : 12.0),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 160,
              child: Text(
                section,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Expanded(
              child: Text(
            text.length > 32 ? '${text.substring(0, 32)}...' : text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          )),
          if (onPressed != null)
            IconButton(
              onPressed: onPressed,
              icon: icon ??
                  Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
        ],
      ),
    );
  }
}
