// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MatchDetailNotifier)
final matchDetailProvider = MatchDetailNotifierFamily._();

final class MatchDetailNotifierProvider
    extends $NotifierProvider<MatchDetailNotifier, MatchDetailState> {
  MatchDetailNotifierProvider._({
    required MatchDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'matchDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchDetailNotifierHash();

  @override
  String toString() {
    return r'matchDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MatchDetailNotifier create() => MatchDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MatchDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchDetailNotifierHash() =>
    r'4a01e8dd2a8d76e6b2722bacf3becb988b6b3944';

final class MatchDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MatchDetailNotifier,
          MatchDetailState,
          MatchDetailState,
          MatchDetailState,
          String
        > {
  MatchDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'matchDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MatchDetailNotifierProvider call(String id) =>
      MatchDetailNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'matchDetailProvider';
}

abstract class _$MatchDetailNotifier extends $Notifier<MatchDetailState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  MatchDetailState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MatchDetailState, MatchDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MatchDetailState, MatchDetailState>,
              MatchDetailState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
