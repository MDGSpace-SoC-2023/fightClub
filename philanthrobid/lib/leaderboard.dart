import "package:flutter/material.dart";

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
            Card(
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text("<User-Name> <Moneys Spent>"))))
        ],
      ),
    );
  }
}
