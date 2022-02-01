import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  createState() => HomeState();
}

class HomeState extends State<Home> {
  bool expand = false;
  int? tapped;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Expandable List"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              debugPrint('List item $index tapped $expand');
              setState(() {
                /// XOR operand returns when either or both conditions are true
                /// `tapped == null` on initial app start, [tapped] is null
                /// `index == tapped` initiate action only on tapped item
                /// `!expand` should check previous expand action
                expand = ((tapped == null) || ((index == tapped) || !expand)) ? !expand : expand;
                /// This tracks which index was tapped
                tapped = index;
                debugPrint('current expand state: $expand');
              });
            },
            /// We set ExpandableListView to be a Widget
            /// for Home StatefulWidget to be able to manage
            /// ExpandableListView expand/retract actions
            child: expandableListView(
              index,
              "Title $index",
              index == tapped? expand: false,
            ),
            // child: ExpandableListView(
            //   title: "Title $index",
            //   isExpanded: expand,
            // ),
          );
        },
        itemCount: 5,
      ),
    );
  }

  Widget expandableListView(int index, String title, bool isExpanded) {
    debugPrint('List item build $index $isExpanded');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // setState(() {
                      //   expandFlag = !expandFlag;
                      // });
                    }),
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          ExpandableContainer(
              expanded: isExpanded,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        color: Colors.black),
                    child: ListTile(
                      title: Text(
                        "Cool $index",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.local_pizza,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: 15,
              ))
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
        decoration:
        BoxDecoration(border: Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}