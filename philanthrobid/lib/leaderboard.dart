import "package:flutter/material.dart";

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Leaderboard", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 246, 179, 202),
          centerTitle: true,
        ),
        body: LeaderList()

    );
  }
}


class LeaderList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            children: [
              /**Need for backend to get the items and put here using for loop and Card widget. Giving example here */
              for(var i=1; i<11; i++)
                Card (child: SizedBox(height: 100, child: Center(child: Text("$i. <User-Name> <Moneys Spent>"))))
            ],
          ),
        ),
      );
    });
  }
}