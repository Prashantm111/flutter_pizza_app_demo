import 'package:flutter/material.dart';

class PizzaSizeSelection extends StatelessWidget {
  const PizzaSizeSelection({
    Key key,
    this.text,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w300),
          ),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0.0, 3.0),
                        spreadRadius: 4.0)
                  ]
                : null),
      ),
    );
  }
}
