import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizza_selection_app/models/ingrediants.dart';
import 'package:pizza_selection_app/state_managment/pizza_order_provider.dart';

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);

    return ValueListenableBuilder(
        valueListenable: bloc.totalPrice,
        builder: (context, snapshot, _) {
          return Container(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ingredientsListMain.length,
              itemBuilder: (context, index) {
                return _PizzaIngredientItems(
                  ingredients: ingredientsListMain[index],
                  isAdded: bloc.isExistAlready(
                    ingredientsListMain[index],
                  ),
                  onTap: () {
                    bloc.removeIngredient(ingredientsListMain[index]);
                  },
                );
              },
            ),
          );
        });
  }
}

class _PizzaIngredientItems extends StatelessWidget {
  final Ingredients ingredients;

  final bool isAdded;
  final VoidCallback onTap;

  const _PizzaIngredientItems(
      {Key key,
      @required this.ingredients,
      @required this.isAdded,
      @required this.onTap})
      : super(key: key);

  Widget _buildChild() {
    return Center(
      child: GestureDetector(
        onTap: isAdded ? onTap : null,
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: isAdded ? BoxShape.circle : BoxShape.circle,
                    // borderRadius: isAdded ? BorderRadius.circular(5) : null,
                    border: isAdded
                        ? Border.all(color: Colors.red, width: 2)
                        : null),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Image.asset(
                    ingredients.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            if (isAdded)
              Positioned(
                right: 00,
                top: 00,
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var child = _buildChild();

    return isAdded
        ? child
        : Center(
            child: Draggable(
              feedback: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        color: Colors.transparent,
                        offset: Offset(0, 5.0),
                        spreadRadius: 5)
                  ],
                ),
                child: ShakeWidget(
                  child: child,
                ),
              ),
              data: ingredients,
              child: child,
              onDraggableCanceled: (velocity, offset) {
               
              },
              onDragCompleted: () {
                
                HapticFeedback.lightImpact();
              },
            ),
          );
  }
}

class ShakeWidget extends StatefulWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    Key key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    this.child,
  }) : super(key: key);

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  /// convert 0-1 to 0-1-0
  // double shake(double animation) =>
  //     2 * (0.5 - (0.5 - widget.curve.transform(animation)).abs());
  AnimationController _controller;
  Animation<Offset> shakeAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        setState(() {});
      });

    shakeAnimation = Tween<Offset>(
      begin: const Offset(-10.0, 0.0),
      end: const Offset(10.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      }
      if (_controller.status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: shakeAnimation.value,
          child: child,
        );
      },
    );

    //  TweenAnimationBuilder<double>(
    //   key: widget.key,
    //   tween: Tween(begin: 0.0, end: 1.0),
    //   duration: widget.duration,
    //   builder: (context, animation, child) => Transform.translate(
    //     offset: Offset(widget.deltaX * shake(animation), 0),
    //     child: child,
    //   ),
    //   child: widget.child,
    // );
  }
}
