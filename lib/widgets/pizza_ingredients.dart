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
                          color: Colors.black54,
                          offset: Offset(0, 5.0),
                          spreadRadius: 5)
                    ],
                  ),
                  child: child),
              data: ingredients,
              child: child,
              onDragCompleted: () {
                HapticFeedback.lightImpact();
              },
            ),
          );
  }
}
