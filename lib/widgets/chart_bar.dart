import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctofTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctofTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                    child: Text(
                        "\$${spendingAmount.toStringAsFixed(0)}"))), //shrinks the text ad makes sure it is fit in the card.it fits according to fit as present in the flexible widget
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctofTotal,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    )),
                  )
                ],
              ), //allows us to keep widgets in the top of each other. Here FractionallySized box is on the top of container
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            FittedBox(child: Container(height: constraints.maxHeight * 0.15, child: Text(label))),
          ],
        );
      },
    );
  }
}
