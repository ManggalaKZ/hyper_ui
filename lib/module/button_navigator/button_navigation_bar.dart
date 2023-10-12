import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class FloatMainNavigationView extends StatefulWidget {
  final int initialSelectedIndex;
  const FloatMainNavigationView({Key? key, required this.initialSelectedIndex})
      : super(key: key);

  @override
  State<FloatMainNavigationView> createState() =>
      _FloatMainNavigationViewState(initialSelectedIndex);
}

class _FloatMainNavigationViewState extends State<FloatMainNavigationView> {
  int selectedIndex;
  _FloatMainNavigationViewState(this.selectedIndex);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: selectedIndex,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: selectedIndex,
          children: [
            DashboardView2(),
            ExpenseListPage(),
            ReportPage(),
            ProfileView()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 248, 248, 248),
          notchMargin: 4,
          child: SizedBox(
            height: 71.0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 35.0,
                right: 35.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                    child: Column(children: <Widget>[
                      Expanded(
                        child: ImageIcon(
                          AssetImage(
                            "assets/aset/Overview.png",
                          ),
                          color: selectedIndex == 0
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          size: 40.0,
                        ),
                      ),
                      Text(
                        "Overview",
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                  InkWell(
                    onTap: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                    child: Column(children: <Widget>[
                      Expanded(
                        child: ImageIcon(
                          AssetImage(
                            "assets/aset/Payment.png",
                          ),
                          color: selectedIndex == 1
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          size: 40.0,
                        ),
                      ),
                      Text(
                        "Expense",
                        style: TextStyle(
                          color: selectedIndex == 1
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                  InkWell(
                    onTap: () {
                      selectedIndex = 2;
                      setState(() {});
                    },
                    child: Column(children: <Widget>[
                      Expanded(
                        child: ImageIcon(
                          AssetImage(
                            "assets/aset/Transaction.png",
                          ),
                          color: selectedIndex == 2
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          size: 40.0,
                        ),
                      ),
                      Text(
                        "Report",
                        style: TextStyle(
                          color: selectedIndex == 2
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                  InkWell(
                    onTap: () {
                      selectedIndex = 3;
                      setState(() {});
                    },
                    child: Column(children: <Widget>[
                      Expanded(
                        child: ImageIcon(
                          AssetImage(
                            "assets/aset/User.png",
                          ),
                          color: selectedIndex == 3
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          size: 40.0,
                        ),
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: selectedIndex == 3
                              ? Color(0xFF9B51E0)
                              : Colors.blueGrey[600],
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
