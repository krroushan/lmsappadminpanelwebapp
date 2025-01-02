// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class WidgetTestingPage extends StatelessWidget {
  const WidgetTestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding:EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8
        ),
        itemBuilder: (context,index){
          return Card(
            color:Colors.white,
            child: Column(
              children: [
                //Image.asset('assets/images/static_images/eCommerce/pet.png')
                Text('lmfofsinfifnefnofr')
              ],
            ),
          );
        });

  }
}
