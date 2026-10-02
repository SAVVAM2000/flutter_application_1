import 'package:flutter/material.dart';
import '../../app.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Header',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) => const ContentCard(),
                separatorBuilder: (context, index) => 16.ph,
              ),

          ],
        ),
      ),
    );
  }
}
