import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pizza_selection_app/models/ingrediants.dart';
import 'package:pizza_selection_app/widgets/pizza_size_state.dart';

class PizzaMetadata {
  PizzaMetadata(this.imageBytes, this.offset, this.size);
  final Uint8List imageBytes;
  final Offset offset;
  final Size size;
}

const initialTotal = 15.0;

class PizzaOrderBLoc extends ChangeNotifier {
  final selectedIngredients = <Ingredients>[];
  final pizzaSizeNotifier =
      ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));
  final deletedIngredient = ValueNotifier<Ingredients>(null);
  final pizzaFocusedNotifier = ValueNotifier(false);
  final totalPrice = ValueNotifier(initialTotal);
  final notifierPizaBoxAnimation = ValueNotifier(false);
  final notifierImagePizza = ValueNotifier<PizzaMetadata>(null);
  final notifierCartAnimationCountProduct = ValueNotifier(0);
  int totalCart = 0;
  void addIngredients(Ingredients ingredient) {
    selectedIngredients.add(ingredient);
    totalPrice.value++;
  }

  bool isExistAlready(Ingredients ingredient) {
    for (Ingredients item in selectedIngredients) {
      if (item.compare(ingredient)) {
        return true;
      }
    }

    return false;
  }

  void refreshDeletedIngtediant() {
    deletedIngredient.value = null;
  }

  void removeIngredient(Ingredients ingredient) {
    selectedIngredients.remove(ingredient);
    totalPrice.value--;
    deletedIngredient.value = ingredient;
  }

  void reset() {
    print("reset");
    notifierPizaBoxAnimation.value = false;
    notifierImagePizza.value = null;
    selectedIngredients.clear();
    totalPrice.value = initialTotal;
    notifierCartAnimationCountProduct.value++;
  }

  void startPizzaBoxAnimation() {
    print("startPizzaBoxAnimation");
    notifierPizaBoxAnimation.value = true;
    notifyListeners();
  }

  Future<void> transferToImage(RenderRepaintBoundary boundary) async {
    print("transferToImage");
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    print("transferToImageEND");
    notifierImagePizza.value =
        PizzaMetadata(byteData.buffer.asUint8List(), position, size);
  }
}
