# Single Action Undo Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans. Execute inline with one final read-only reviewer.

**Goal:** Single-use undo across match screens and a continuous match timer.
**Architecture:** One nullable pre-action snapshot plus acknowledged event identity in MatchGameNotifier; no stack. Repository exposes created/deleted Event with response identity. A shared themed MatchUndoBar covers all match states.
**Tech Stack:** Flutter 3.41.6, Riverpod, Retrofit/Dio, flutter_test.
**Spec:** docs/superpowers/specs/2026-11-01-single-action-undo-design.md

## Global Constraints

- Target dev. No backend changes, new dependencies, hardcoded UI colors/fonts, or unbounded state history.
- Preserve distinct Timeout/Halftime states and their timestamps; common match time always advances.
- One undo consumes the buffer. Local lineup confirmation never sends undo to backend.
- Never automatically retry non-idempotent undo. Freeze competing writes while pending/uncertain.

## Review Focus

- Second tap, second completed undo, and failed/mismatched responses must not delete another event.
- Score/thrower/lineups and pause timestamps restore correctly; game time does not rewind.
- Local transition can be undone after a server undo without deleting another event.
- Lost create/undo responses, stale journal, disposal and refused writes must not leave UI silently divergent.
- Button remains accessible in every phase, on small devices, using theme styles.

## Task 1: API and single-use state transitions

Files: Event/ EventModel, MatchEventsRepository/Impl, EventsApi and generated source; MatchGameNotifier; repository and notifier tests.
Interfaces: addEvent(CreateEventParams) -> Future<Event>; undoLastEvent(String matchId) -> Future<Event>; response-only nullable id/sequenceNumber; notifier canUndo/isBusy/canInteract/message, undoLastAction() and checkPendingAction() for read-only reconciliation.

- [x] Write and run failing behavioral tests for API contract, single buffer, local confirm, event/goal/pause transitions, concurrency and failures.
- [x] Implement guarded optimistic actions and acknowledged single snapshot; verify remote event identity before undo and reconcile uncertain outcomes with GET only.
- [x] Update dependent fake repositories and existing tests to await acknowledged actions and continuous pause time; regenerate only affected outputs.

## Task 2: UI, validation and delivery

Files: MatchUndoBar, MatchScreen, MatchDetailScreen navigation listener, existing pause tests and widget/navigation tests.

- [x] Test and add shared themed control, pending/error feedback, disabled actions/Back, one-use availability and responsive layout.
- [x] Run full flutter test, flutter analyze (compare baseline), flutter build bundle, formatter and visual preview. Results: 62 tests pass; debug bundle succeeds; 18 existing analyzer warnings, no new diagnostics.
- [x] Run final read-only reviewer; fix Important/Critical findings. Result: one independent review, no findings.

Delivery: commit, push feat/match-undo and open a PR into dev.
