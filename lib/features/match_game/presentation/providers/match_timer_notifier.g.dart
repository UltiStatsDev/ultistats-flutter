// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_timer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MatchTimer)
final matchTimerProvider = MatchTimerFamily._();

final class MatchTimerProvider
    extends $NotifierProvider<MatchTimer, MatchTimerState> {
  MatchTimerProvider._({
    required MatchTimerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'matchTimerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchTimerHash();

  @override
  String toString() {
    return r'matchTimerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MatchTimer create() => MatchTimer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchTimerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchTimerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MatchTimerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchTimerHash() => r'8995754ce16a9e556073c23ab337d56c912c0470';

final class MatchTimerFamily extends $Family
    with
        $ClassFamilyOverride<
          MatchTimer,
          MatchTimerState,
          MatchTimerState,
          MatchTimerState,
          String
        > {
  MatchTimerFamily._()
    : super(
        retry: null,
        name: r'matchTimerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MatchTimerProvider call(String matchId) =>
      MatchTimerProvider._(argument: matchId, from: this);

  @override
  String toString() => r'matchTimerProvider';
}

abstract class _$MatchTimer extends $Notifier<MatchTimerState> {
  late final _$args = ref.$arg as String;
  String get matchId => _$args;

  MatchTimerState build(String matchId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MatchTimerState, MatchTimerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MatchTimerState, MatchTimerState>,
              MatchTimerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
