import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  final Object exception;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    required this.exception,
    required this.stackTrace,
    this.onRetry,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDebugMode = kDebugMode;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Что-то пошло не так :(",
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (isDebugMode) ...[
                Text(
                  widget.exception.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  icon: Icon(_showDetails ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showDetails = !_showDetails),
                  label: Text(_showDetails ? "Скрыть детали" : "Показать детали"),
                ),
                if (_showDetails) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      widget.stackTrace.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ] else ...[
                const SizedBox(height: 24),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: Icon(Icons.refresh),
                onPressed: widget.onRetry,
                label: Text("Попробовать снова"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
