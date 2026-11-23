import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../di/di.dart';
import '../../app.dart';

/// Второй экран приложения — детальная информация об элементе списка.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.id});

  final int id;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _details = getIt<DetailsBloc>();
  void loadDetails() => _details.add(DetailsLoad(id: widget.id));

  @override
  void initState() {
    loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        bloc: _details,
        builder: (context, state) {
          return switch (state) {
            DetailsInitial() => _buildDetailsInitial(),
            DetailsLoadInProgress() => _buildDetailsLoadInProgress(),
            DetailsLoadSuccess() => _buildDetailsLoadSuccess(state),
            DetailsLoadFailure() => _buildDetailsLoadFailure(state),
          };
        },
      ),
    );
  }

  Widget _buildDetailsInitial() => SizedBox.shrink();

  Widget _buildDetailsLoadInProgress() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildDetailsLoadSuccess(DetailsLoadSuccess state) {
    final content = state.content;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              content.image,
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 350,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          20.ph,
          Text(
            content.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          8.ph,
          Text(
            content.author,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          12.ph,
          const Divider(height: 1, color: Color.fromRGBO(0, 0, 0, 0.08)),
          16.ph,
          Text(
            content.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsLoadFailure(DetailsLoadFailure state) {
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
              onPressed: () => loadDetails(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
