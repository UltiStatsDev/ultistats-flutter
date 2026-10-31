# Match Pauses Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement this plan. Steps use checkbox syntax for tracking.

**Goal:** Replace timeout and halftime dialogs with two match states and their screen widgets.
**Architecture:** MatchGameNotifier owns pause transitions, events and the main timer. MatchScreen renders pause widgets through its existing switch; a shared counter widget displays elapsed wall time from the state's timestamp.
**Tech Stack:** Flutter 3.41.6, Dart, Riverpod, flutter_test.
**Spec:** docs/superpowers/specs/2026-10-31-match-pauses-design.md

## Global Constraints

- Preserve existing labels, start eligibility and manual finish behavior.
- Preserve exact playing/lineup state after a pause and block back during pauses.
- Do not change API contracts, persistence, dependencies or unrelated match mechanics.

## Review Focus

- Duplicate start/end and cross-pause commands must not emit extra events.
- Gameplay and lineup changes must be unavailable during the corresponding pause.
- Main timer must stop during both pauses and resume without counting pause time.
- Rebuilding a pause widget must retain the pause start time; short screens must scroll.
- Back must not silently end a pause or discard its state.

## Task 1: State transitions and screens

**Files:** modify match_game_state.dart, match_game_notifier.dart, match_screen.dart and timer_widget.dart; replace timeout_dialog.dart/halftime_dialog.dart with timeout_widget.dart, halftime_widget.dart and common/pause_widget.dart; add test/features/matches/match_pauses_test.dart and test fixtures.

**Interfaces:** GameStateTimeout stores GameStatePlaying resumeState, MatchTeam team, DateTime startedAt; GameStateHalftime stores GameStateLineupSelection resumeState and DateTime startedAt. Existing startTimeout(team), endTimeout(team), startHalftime(), endHalftime() remain callable. Widgets consume those states and invoke notifier end methods.

- [x] Add behavioral tests using real providers, a recording repository, state restoration, timer freeze/resume, guards and both screen flows.
- [x] Run flutter test; observe failures caused by absent pause transitions and dialog-based presentation.
- [x] Implement state transitions and timer ownership, pause widgets, switch cases, and back blocking; remove obsolete dialogs.
- [x] Run flutter test, format changed Dart files, flutter analyze; compare any existing analyzer findings against main.
- [x] Run one read-only final reviewer and resolve Important/Critical findings. Result: no findings.

Delivery: commit, push the feature branch and create a PR against main.
