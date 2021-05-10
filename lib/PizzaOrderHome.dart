import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:pizza_selection_app/pizza_details.dart';
import 'package:pizza_selection_app/state_managment/pizza_order_bloc.dart';
import 'package:pizza_selection_app/state_managment/pizza_order_provider.dart';
import 'package:pizza_selection_app/widgets/pizza_cart_button.dart';
import 'package:pizza_selection_app/widgets/pizza_cart_icon.dart';
import 'package:pizza_selection_app/widgets/pizza_ingredients.dart';

const _PizzaCartButtonSize = 50.0;

class PizzaOrderHome extends StatefulWidget {
  @override
  _PizzaOrderHomeState createState() => _PizzaOrderHomeState();
}

final main_bloc = PizzaOrderBLoc();

class _PizzaOrderHomeState extends State<PizzaOrderHome> {
  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      bloc: main_bloc,
      child: Scaffold(
          appBar: AppBar(
            actions: [PizzaCartIcon()],
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Customize Pizza',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                left: 10,
                right: 10,
                bottom: 50,
                top: 10,
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 6,
                        child: PizzaDetails(),
                      ),
                      Expanded(
                        flex: 3,
                        child: PizzaIngredients(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                height: _PizzaCartButtonSize,
                width: _PizzaCartButtonSize,
                left: MediaQuery.of(context).size.width / 2 -
                    _PizzaCartButtonSize / 2,
                child: PizzaCartButton(
                  onTap: () {
                    print("BUTTON PRESSED");
                    main_bloc.startPizzaBoxAnimation();
                  },
                ),
              )
            ],
          )),
    );
  }
}
