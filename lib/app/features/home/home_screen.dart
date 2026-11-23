import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _home = getIt<HomeBloc>();
  void loadHome() => _home.add(HomeLoad());

  @override
  void initState() {
    loadHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _home,
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => _buildHomeInitial(),
            HomeLoadInProgress() => _buildHomeLoadInProgress(),
            HomeLoadSuccess() => _buildHomeLoadSuccess(state),
            HomeLoadFailure() => _buildHomeLoadFailure(state),
          };
        },
      ),
    );
  }

  Widget _buildHomeInitial() => SizedBox.shrink();

  Widget _buildHomeLoadInProgress() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildHomeLoadSuccess(HomeLoadSuccess state) {
    final content = state.content;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Header',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: content.length,
            itemBuilder: (_, index) => ContentCard(
              content: content[index],
            ),
            separatorBuilder: (_, _) => 16.ph,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeLoadFailure(HomeLoadFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.exception.toString(),
              textAlign: TextAlign.center,
            ),
            16.ph,
            ElevatedButton(
              onPressed: () => loadHome(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
