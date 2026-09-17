// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_preparation_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MatchPreparationNotifier)
final matchPreparationProvider = MatchPreparationNotifierFamily._();

final class MatchPreparationNotifierProvider
    extends $NotifierProvider<MatchPreparationNotifier, MatchPreparationState> {
  MatchPreparationNotifierProvider._({
    required MatchPreparationNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'matchPreparationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchPreparationNotifierHash();

  @override
  String toString() {
    return r'matchPreparationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MatchPreparationNotifier create() => MatchPreparationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchPreparationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchPreparationState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MatchPreparationNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchPreparationNotifierHash() =>
    r'21eff44a36f4ac9cf4dc38d85892a69b8809e0b6';

final class MatchPreparationNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MatchPreparationNotifier,
          MatchPreparationState,
          MatchPreparationState,
          MatchPreparationState,
          String
        > {
  MatchPreparationNotifierFamily._()
    : super(
        retry: null,
        name: r'matchPreparationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MatchPreparationNotifierProvider call(String matchId) =>
      MatchPreparationNotifierProvider._(argument: matchId, from: this);

  @override
  String toString() => r'matchPreparationProvider';
}

abstract class _$MatchPreparationNotifier
    extends $Notifier<MatchPreparationState> {
  late final _$args = ref.$arg as String;
  String get matchId => _$args;

  MatchPreparationState build(String matchId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MatchPreparationState, MatchPreparationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MatchPreparationState, MatchPreparationState>,
              MatchPreparationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
