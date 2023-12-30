// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import "package:philanthrobid/addAListing.dart";
import "package:philanthrobid/settings.dart";
import "package:philanthrobid/leaderboard.dart";

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreen();
}

class _homeScreen extends State<homeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget page;
    String text;

    switch (_currentIndex) {
      case 0:
        page = HomePage();
        text = "Home";
        break;

      case 1:
        page = Leaderboard();
        text = "Leaderboard";
        break;

      case 2:
        page = settings();
        text = "Settings";
        break;

      default:
        throw UnimplementedError("No widget for selected Index");
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, //removes default backbutton since the homepage is not home according to flutter
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Column(children: [
        Expanded(
            child: Container(
          color: theme.colorScheme.background,
          child: page,
        )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          fixedColor: theme.colorScheme.primary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(children: [
      ListView(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: () {
                        _searchController.clear();
                      })),
            ),
          ),
          for (var i = 0; i < 10; i++)
            Column(
              children: const [
                Listing(),
                SizedBox(
                  height: 10,
                ),
              ],
            )
        ],
        //Rest of the body below this
      ),
      Positioned(
          top: 490,
          left: 290,
          child: CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primary,
              child: Center(
                  child: IconButton(
                iconSize: 40,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const addAListing();
                  }));
                }, //onPressed
              )))),
    ]);
  }
}

class Listing extends StatelessWidget {
  const Listing({super.key});

  void listingAdded() {
    print("Listing Added");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Title",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.clip,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 360,
                child: Text(
                  "This is a very long line. Please bear with it. Please I beg you to bear it",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Current Bid",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  print("Listing");
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  theme.colorScheme.background,
                )),
                child: Text(
                  "Place Bid",
                  style: TextStyle(
                      fontSize: 15, color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
