import 'package:flutter/cupertino.dart';

class Ingredients {
  final String image;
  final List<Offset> positions;

  const Ingredients(this.image, this.positions);

  bool compare(Ingredients ingredients) => ingredients.image == image;
}

final ingredientsListMain = const <Ingredients>[
  Ingredients('assets/patato.png', <Offset>[
    Offset(0.40, 0.40),
    Offset(0.6, 0.50),
    Offset(0.41, 0.70),
    Offset(0.35, 0.55),
    Offset(0.5, 0.2),
  ]),
  Ingredients('assets/red_chili.png', <Offset>[
    Offset(0.65, 0.55),
    Offset(0.6, 0.4),
    Offset(0.45, 0.40),
    Offset(0.35, 0.20),
    Offset(0.30, 0.65),
  ]),
  Ingredients('assets/tomato.png', <Offset>[
    Offset(0.55, 0.30),
    Offset(0.70, 0.45),
    Offset(0.50, 0.65),
    Offset(0.30, 0.45),
    Offset(0.40, 0.20),
  ]),
  Ingredients('assets/onion.png', <Offset>[
    Offset(0.25, 0.25),
    Offset(0.65, 0.30),
    Offset(0.45, 0.5),
    Offset(0.60, 0.65),
    Offset(0.20, 0.52),
  ]),
  Ingredients('assets/grapes.png', <Offset>[
    Offset(0.40, 0.30),
    Offset(0.55, 0.35),
    Offset(0.20, 0.36),
    Offset(0.45, 0.61),
    Offset(0.23, 0.62),
  ]),
];
