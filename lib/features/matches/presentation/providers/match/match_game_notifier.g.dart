// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MatchGameNotifier)
final matchGameProvider = MatchGameNotifierFamily._();

final class MatchGameNotifierProvider
    extends $NotifierProvider<MatchGameNotifier, MatchGameState> {
  MatchGameNotifierProvider._({
    required MatchGameNotifierFamily super.from,
    required MatchDetail super.argument,
  }) : super(
         retry: null,
         name: r'matchGameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchGameNotifierHash();

  @override
  String toString() {
    return r'matchGameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MatchGameNotifier create() => MatchGameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchGameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchGameState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MatchGameNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchGameNotifierHash() => r'ed76c2c15d49dec07e0bdbab3bdbb26c89dd947d';

final class MatchGameNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MatchGameNotifier,
          MatchGameState,
          MatchGameState,
          MatchGameState,
          MatchDetail
        > {
  MatchGameNotifierFamily._()
    : super(
        retry: null,
        name: r'matchGameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MatchGameNotifierProvider call(MatchDetail match) =>
      MatchGameNotifierProvider._(argument: match, from: this);

  @override
  String toString() => r'matchGameProvider';
}

abstract class _$MatchGameNotifier extends $Notifier<MatchGameState> {
  late final _$args = ref.$arg as MatchDetail;
  MatchDetail get match => _$args;

  MatchGameState build(MatchDetail match);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MatchGameState, MatchGameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MatchGameState, MatchGameState>,
              MatchGameState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
