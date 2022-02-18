import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/provider/count_store.dart';
import '../component/list_cell.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    final count1 = context.select((Count1Store store) => store.count);
    final count2 = context.select((Count2Store store) => store.count);
    final count3 = context.select((Count3Store store) => store.count);
    // final count4 = context.select((Count1Store store) => store.count);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListCell(
              title: "count1: ${count1}",
              buttonTitle: "count1を+1",
              handler: () {
                context.read<Count1Store>().increament();
                print("button1 tapped");
              }
            ),
            ListCell(
              // title: "count2: ${count2}, count1が変化したら2倍して上書き",
              title: "count2: ${count2}",
              buttonTitle: "count2を+1",
              handler: () {
                context.read<Count2Store>().increament();
                print("button2 tapped");
              }
            ),
            ListCell(
              // title: "count3: ${count3}, count1or2が変化したら2つを合計",
              title: "count3: ${count3}",
              buttonTitle: "count3を+1",
              handler: () {
                context.read<Count3Store>().increament();
                print("button3 tapped");
              }
            ),
            // ListCell(
            //   title: "count4: ${count4}",
            //   buttonTitle: "count4を+1",
            //   handler: () {
            //     context.read<Count1Store>().increament();
            //     print("button4 tapped");
            //   }
            // ),
          ],
        ),
      ),
    );
  }
}
