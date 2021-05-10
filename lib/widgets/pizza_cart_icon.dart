import 'package:flutter/material.dart';
import 'package:pizza_selection_app/state_managment/pizza_order_provider.dart';

class PizzaCartIcon extends StatefulWidget {
  @override
  _PizzaCartIconState createState() => _PizzaCartIconState();
}

class _PizzaCartIconState extends State<PizzaCartIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animationScaleOut;
  Animation<double> _animationScaleIn;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds:500));

    _animationScaleOut = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0,0.5),
    );

    _animationScaleIn = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5,1.0),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierCartAnimationCountProduct.addListener(() {
        counter = bloc.notifierCartAnimationCountProduct.value;
        _controller.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          double scale;
          const scaleFactor = 0.5;
          if (_animationScaleOut.value < 1.0) {
            scale = 1.0 + scaleFactor * _animationScaleOut.value;
          } else if (_animationScaleIn.value <= 1.0) {
            scale = (1.0 + scaleFactor) - scaleFactor * _animationScaleIn.value;
          }

          return Transform.scale(
            alignment: Alignment.center,
            scale: scale,
            child: Stack(children: [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              Positioned(
                  top: 2,
                  right: 7,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      counter.toString(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white ),
                    ),
                  ))
            ]),
          );
        });
  }
}
