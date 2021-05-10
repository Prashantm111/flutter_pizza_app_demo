import 'package:flutter/material.dart';

class PizzaCartButton extends StatefulWidget {
  final VoidCallback onTap;

  const PizzaCartButton({Key key, this.onTap}) : super(key: key);
  @override
  _PizzaCartButtonState createState() => _PizzaCartButtonState();
}

class _PizzaCartButtonState extends State<PizzaCartButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse(from: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _animateButton();
      },
      child: AnimatedBuilder(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [Colors.orange.shade100, Colors.orange.shade800],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0),
                    spreadRadius: 4.0)
              ]),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
          ),
        ),
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: (1 - Curves.bounceOut.transform(_animationController.value))
                .clamp(0.6, 1.0),
            child: child,
          );
        },
      ),
    );
  }
}
