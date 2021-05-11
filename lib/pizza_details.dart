import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pizza_selection_app/models/ingrediants.dart';
import 'package:pizza_selection_app/state_managment/pizza_order_bloc.dart';
import 'package:pizza_selection_app/state_managment/pizza_order_provider.dart';
import 'package:pizza_selection_app/widgets/pizza_size_selection.dart';
import 'package:pizza_selection_app/widgets/pizza_size_state.dart';

class PizzaDetails extends StatefulWidget {
  @override
  PizzaDetailsState createState() => PizzaDetailsState();
}

class PizzaDetailsState extends State<PizzaDetails>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationRotateController;
  List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaBoxContraint;

  final _keyPizza = GlobalKey();

  void _createAnimationIngredients() {
    _animationList.clear();

    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.7, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.decelerate),
      ),
    );
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.6, curve: Curves.decelerate),
      ),
    );
  }

  Widget _buildIngredientWidget(Ingredients deleteItem) {
    List<Widget> elements = [];
    final selectedIngredients =
        List.from(PizzaOrderProvider.of(context).selectedIngredients);
    if (deleteItem != null) {
      selectedIngredients.add(deleteItem);
    }

    if (_animationList.isNotEmpty) {
      for (int i = 0; i < selectedIngredients.length; i++) {
        Ingredients ingredients = selectedIngredients[i];
        final ingWid = Image.asset(ingredients.image, height: 50);
        for (int j = 0; j < ingredients.positions.length; j++) {
          final animation = _animationList[j];
          final inPostion = ingredients.positions[j];
          final positionX = inPostion.dx;
          final positionY = inPostion.dy;

          if (i == selectedIngredients.length - 1 &&
              _animationController.isAnimating) {
            double fromX = 0.0;
            double fromY = 0.0;

            if (j < 1) {
              fromX = -_pizzaBoxContraint.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = _pizzaBoxContraint.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -_pizzaBoxContraint.maxHeight * (1 - animation.value);
            } else {
              fromY = _pizzaBoxContraint.maxHeight * (1 - animation.value);
            }
            final opacity = animation.value;
            if (animation.value > 0) {
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        fromX + _pizzaBoxContraint.maxWidth * positionX,
                        fromY + _pizzaBoxContraint.maxHeight * positionY,
                      ),
                    child: ingWid,
                  ),
                ),
              );
            }
          } else {
            elements.add(
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _pizzaBoxContraint.maxWidth * positionX,
                    _pizzaBoxContraint.maxHeight * positionY,
                  ),
                child: ingWid,
              ),
            );
          }
        }
      }
      return Stack(
        children: elements,
      );
    }

    return SizedBox.fromSize();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animationRotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierPizaBoxAnimation.addListener(() {
        print("ADD PIZZA TO CART  ${bloc.notifierPizaBoxAnimation.value}");

        if (bloc.notifierPizaBoxAnimation.value) {
          _addPizzaToCart();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);

    return Column(
      children: [
        Expanded(
            child: DragTarget<Ingredients>(
          onAccept: (value) {
            print('ACCEPTED VALUE :  $value');

            bloc.pizzaFocusedNotifier.value = false;

            bloc.addIngredients(value);
            _animationController.forward(from: 0.0);
            _createAnimationIngredients();
          },
          onWillAccept: (value) {
            bloc.pizzaFocusedNotifier.value = true;

            return !bloc.isExistAlready(value);
          },
          onLeave: (value) {
            print('ON LEAVE  VALUE :  $value');

            bloc.pizzaFocusedNotifier.value = false;
          },
          builder: (context, candidateData, rejets) {
            return LayoutBuilder(builder: (context, constraints) {
              _pizzaBoxContraint = constraints;
              return ValueListenableBuilder<PizzaMetadata>(
                  valueListenable: bloc.notifierImagePizza,
                  builder: (context, data, child) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: data != null ? 0.0 : 1,
                      child: ValueListenableBuilder<PizzaSizeState>(
                          valueListenable: bloc.pizzaSizeNotifier,
                          builder: (context, value, _) {
                            print("LISNER : $data");
                            if (data != null) {
                              Future.microtask(() => _pizzaBoxAniation(data));
                            }

                            return RepaintBoundary(
                              key: _keyPizza,
                              child: RotationTransition(
                                turns: CurvedAnimation(
                                    parent: _animationRotateController,
                                    curve: Curves.elasticOut),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: ValueListenableBuilder(
                                        valueListenable:
                                            bloc.pizzaFocusedNotifier,
                                        builder: (context, focused, _) {
                                          return Stack(
                                            children: [
                                              Center(
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  height: focused
                                                      ? constraints.maxHeight *
                                                          value.factor
                                                      : constraints.maxHeight *
                                                              value.factor -
                                                          20,
                                                  // width: focused
                                                  //     ? constraints.maxWidth * value.factor
                                                  //     : constraints.maxWidth *
                                                  //             value.factor -
                                                  //         20,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 20,
                                                              color:
                                                                  Colors.grey)
                                                        ]),
                                                    child: Image.asset(
                                                      'assets/pizza_1.png',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ValueListenableBuilder(
                                                  valueListenable:
                                                      bloc.deletedIngredient,
                                                  builder:
                                                      (context, deleteItem, _) {
                                                    _animateDeletedIngredient(
                                                        deleteItem);
                                                    return AnimatedBuilder(
                                                      animation:
                                                          _animationController,
                                                      builder: (context, _) {
                                                        return _buildIngredientWidget(
                                                            deleteItem);
                                                      },
                                                    );
                                                  })
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  });
            });
          },
        )),
        ValueListenableBuilder<double>(
            valueListenable: bloc.totalPrice,
            builder: (context, totalValue, _) {
              return AnimatedSwitcher(
                //
                duration: const Duration(
                  milliseconds: 300,
                ),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: Offset(0.0, 0.0),
                          end: Offset(0.0, animation.value),
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '\$ $totalValue',
                  key: UniqueKey(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              );
            }),
        SizedBox(
          height: 40,
        ),
        ValueListenableBuilder<PizzaSizeState>(
            valueListenable: bloc.pizzaSizeNotifier,
            builder: (context, pizzaSize, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PizzaSizeSelection(
                    text: 'S',
                    isSelected: pizzaSize.value == PizzaSizeValue.s,
                    onTap: () {
                      _updateSize(PizzaSizeValue.s);
                    },
                  ),
                  PizzaSizeSelection(
                    text: 'M',
                    isSelected: pizzaSize.value == PizzaSizeValue.m,
                    onTap: () {
                      _updateSize(PizzaSizeValue.m);
                    },
                  ),
                  PizzaSizeSelection(
                    text: 'L',
                    isSelected: pizzaSize.value == PizzaSizeValue.l,
                    onTap: () {
                      _updateSize(PizzaSizeValue.l);
                    },
                  ),
                ],
              );
            })
      ],
    );
  }

  Future<void> _animateDeletedIngredient(Ingredients deleteItem) async {
    if (deleteItem != null) {
      await _animationController.reverse(from: 1.0);
      final bloc = PizzaOrderProvider.of(context);
      bloc.refreshDeletedIngtediant();
    }
  }

  void _updateSize(PizzaSizeValue value) {
    final blc = PizzaOrderProvider.of(context);
    blc.pizzaSizeNotifier.value = PizzaSizeState(value);

    Future.delayed(const Duration(milliseconds: _pizzaAnimateTime), () {
      _animationRotateController.forward(from: 0.0);
    });
  }

  void _addPizzaToCart() {
    RenderRepaintBoundary boundary =
        _keyPizza.currentContext.findRenderObject();

    final blc = PizzaOrderProvider.of(context);
    blc.transferToImage(boundary);
  }

  OverlayEntry _overlayEntry;
  void _pizzaBoxAniation(PizzaMetadata data) {
    print("pizzaBoxAniation");
    if (null == _overlayEntry) {
      final blc = PizzaOrderProvider.of(context);
      print("_overlayEntry");
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return PizzaOrderAnimation(
            metadata: data,
            onComplete: () {
              _overlayEntry.remove();
              _overlayEntry = null;
              blc.reset();
            },
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry);
    }
  }
}

class PizzaOrderAnimation extends StatefulWidget {
  final PizzaMetadata metadata;
  final VoidCallback onComplete;

  const PizzaOrderAnimation({Key key, this.metadata, this.onComplete})
      : super(key: key);
  @override
  _PizzaOrderAnimationState createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _pizzaScaleAnimation;
  Animation<double> _pizzaOpacityAnimation;
  Animation<double> _boxEnterScaleAnimation;
  Animation<double> _boxExitScaleAnimation;
  Animation<double> _boxExitToCartAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pizzaScaleAnimation = Tween(begin: 1.0, end: 0.4).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.2),
    ));

    _pizzaOpacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.4),
    );

    _boxEnterScaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.2),
    );

    _boxExitScaleAnimation = Tween(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 0.7),
      ),
    );

    _boxExitToCartAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.7, 1.0),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.metadata.offset.dy,
      left: widget.metadata.offset.dx,
      width: widget.metadata.size.width,
      height: widget.metadata.size.height,
      child: GestureDetector(
        onTap: () {
          widget.onComplete();
        },
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, snapshot) {
              final moveToX = _boxExitToCartAnimation.value > 0
                  ? widget.metadata.offset.dx +
                      widget.metadata.size.width /
                          2 *
                          _boxExitToCartAnimation.value
                  : 0.0;
              final moveToY = _boxExitToCartAnimation.value > 0
                  ? -widget.metadata.size.height /
                      1.5 *
                      _boxExitToCartAnimation.value
                  : 0.0;
              return Opacity(
                opacity: 1 - _boxExitToCartAnimation.value,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(moveToX, moveToY)
                    ..rotateZ(_boxExitToCartAnimation.value)
                    ..scale(_boxExitScaleAnimation.value),
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: 1 - _boxExitToCartAnimation.value,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        _buildBox(),
                        Opacity(
                          opacity: 1 - _pizzaOpacityAnimation.value,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(_pizzaScaleAnimation.value)
                              ..translate(
                                  0.0, 20 * (1 - _pizzaOpacityAnimation.value)),
                            child: Image.memory(widget.metadata.imageBytes),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildBox() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxHeight = constraints.maxHeight / 2;
        final boxWidth = constraints.maxWidth / 2;
        print(boxWidth);
        final minAngle = -45.0;
        final maxAngle = -110.0;
        final boxClosingValue =
            lerpDouble(minAngle, maxAngle, 1 - _pizzaOpacityAnimation.value);
        return Opacity(
          opacity: _boxEnterScaleAnimation.value,
          child: Transform.scale(
            scale: _boxEnterScaleAnimation.value,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0020)
                      ..rotateX(degreeToRADS(minAngle)),
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/box_inside.png',
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
                Center(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0020)
                      ..rotateX(degreeToRADS(boxClosingValue)),
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/box_inside.png',
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
                if (boxClosingValue >= -90)
                  Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0020)
                        ..rotateX(degreeToRADS(boxClosingValue)),
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/box_cover.png',
                        height: boxHeight,
                        width: boxWidth,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

num degreeToRADS(num deg) => (deg * pi) / 180.0;

const int _pizzaAnimateTime = 200;
