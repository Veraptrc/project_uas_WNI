import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  const FavoriteButton({
    super.key,
    required this.isLiked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
