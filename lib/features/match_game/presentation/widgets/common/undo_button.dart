import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/match_game/presentation/providers/match_game_notifier.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';

/// Кнопка отмены последнего действия матча.
///
/// Отмена доступна только один раз: после успешного отката кнопка гаснет до
/// следующего действия.
class UndoButton extends ConsumerStatefulWidget {
  const UndoButton({super.key, required this.match});

  final MatchDetail match;

  @override
  ConsumerState<UndoButton> createState() => _UndoButtonState();
}

class _UndoButtonState extends ConsumerState<UndoButton> {
  bool _isBusy = false;

  Future<void> _undo() async {
    if (_isBusy) return;

    setState(() => _isBusy = true);
    final messenger = ScaffoldMessenger.of(context);
    final success = await ref
        .read(matchGameProvider(widget.match).notifier)
        .undo();

    if (!mounted) return;

    setState(() => _isBusy = false);

    if (!success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Не удалось отменить действие')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Пересчитываем доступность отмены после каждого изменения игры.
    ref.watch(matchGameProvider(widget.match));
    final notifier = ref.read(matchGameProvider(widget.match).notifier);
    final canUndo = notifier.canUndo && !_isBusy;

    return IconButton(
      onPressed: canUndo ? _undo : null,
      tooltip: 'Отменить последнее действие',
      visualDensity: VisualDensity.compact,
      icon: _isBusy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.undo),
      disabledColor: Theme.of(context).disabledColor,
    );
  }
}
