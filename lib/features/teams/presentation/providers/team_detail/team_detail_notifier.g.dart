// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TeamDetailNotifier)
final teamDetailProvider = TeamDetailNotifierFamily._();

final class TeamDetailNotifierProvider
    extends $NotifierProvider<TeamDetailNotifier, TeamDetailState> {
  TeamDetailNotifierProvider._({
    required TeamDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'teamDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$teamDetailNotifierHash();

  @override
  String toString() {
    return r'teamDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TeamDetailNotifier create() => TeamDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeamDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeamDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TeamDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teamDetailNotifierHash() =>
    r'b66727dd652d706110e7f1a6a440bec1f9859574';

final class TeamDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TeamDetailNotifier,
          TeamDetailState,
          TeamDetailState,
          TeamDetailState,
          String
        > {
  TeamDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'teamDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TeamDetailNotifierProvider call(String id) =>
      TeamDetailNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'teamDetailProvider';
}

abstract class _$TeamDetailNotifier extends $Notifier<TeamDetailState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  TeamDetailState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TeamDetailState, TeamDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TeamDetailState, TeamDetailState>,
              TeamDetailState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
