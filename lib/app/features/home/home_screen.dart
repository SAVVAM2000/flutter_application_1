import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Выйти',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthCubit>().signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Header',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              4.ph,
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthSuccess) {
                    final profile = authState.profile;
                    final created = profile == null
                        ? ''
                        : ' · профиль создан ${_formatDate(profile.createdAt)}';
                    return Text(
                      '${authState.email}$created',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: content.length,
            itemBuilder: (context, index) => ContentCard(
              content: content[index],
              onTap: () => context.push('/details/${content[index].id}'),
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

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day.$month.${local.year}';
  }
}
