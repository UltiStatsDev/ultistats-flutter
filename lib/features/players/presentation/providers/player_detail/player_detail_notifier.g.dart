// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerDetailNotifier)
final playerDetailProvider = PlayerDetailNotifierFamily._();

final class PlayerDetailNotifierProvider
    extends $NotifierProvider<PlayerDetailNotifier, PlayerDetailState> {
  PlayerDetailNotifierProvider._({
    required PlayerDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playerDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerDetailNotifierHash();

  @override
  String toString() {
    return r'playerDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlayerDetailNotifier create() => PlayerDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerDetailNotifierHash() =>
    r'4ab820fb2fe5dbba0086dd5d5878736d850d51c2';

final class PlayerDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayerDetailNotifier,
          PlayerDetailState,
          PlayerDetailState,
          PlayerDetailState,
          String
        > {
  PlayerDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'playerDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerDetailNotifierProvider call(String id) =>
      PlayerDetailNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'playerDetailProvider';
}

abstract class _$PlayerDetailNotifier extends $Notifier<PlayerDetailState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  PlayerDetailState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerDetailState, PlayerDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerDetailState, PlayerDetailState>,
              PlayerDetailState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
