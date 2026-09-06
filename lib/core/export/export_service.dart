import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../backup/backup_service.dart';
import '../utils/labels.dart';

/// Writes exports to temp files and hands them to the share sheet.
/// The temp directory is injected so tests stay plugin-free.
class ExportService {
  ExportService(this._db, this._share, this._tempDir,
      {PhotoService? photos})
      : _photos = photos; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final ShareLauncher _share;
  final Future<Directory> Function() _tempDir;
  final PhotoService? _photos;

  /// Every round as a CSV row, joined with its course. Returns the
  /// written file (mainly for tests).
  Future<File> shareRoundsCsv({DateTime? now}) async {
    final courses = await _db.select(_db.courses).get();
    final byId = {for (final c in courses) c.id: c};
    final rounds = await (_db.select(_db.rounds)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
    final entries = {
      for (final e in await _db.select(_db.appJournalEntries).get()) e.id: e,
    };

    final csv = buildCsv([
      [
        'course', 'city', 'state', 'country', 'date', 'score',
        'holes', 'tees', 'walked_or_cart', 'partners', 'weather',
        'rating', 'story',
      ],
      for (final r in rounds)
        [
          byId[r.courseId]?.name,
          byId[r.courseId]?.city,
          byId[r.courseId]?.state,
          byId[r.courseId]?.country,
          r.date.toIso8601String().substring(0, 10),
          r.totalScore,
          r.holesPlayed.label,
          r.tees,
          r.walkedOrCart?.label,
          r.partners,
          r.weather,
          entries[r.journalEntryId]?.rating,
          entries[r.journalEntryId]?.notes,
        ],
    ]);

    return shareStampedFile(
      share: _share,
      tempDir: _tempDir,
      baseName: 'courseledger-rounds',
      extension: 'csv',
      mimeType: 'text/csv',
      shareText: 'Course Ledger rounds',
      text: csv,
      now: now,
    );
  }

  /// The full ledger as one zip: export JSON plus round photo files.
  Future<File> shareBackup({required int lifetimeCourses, DateTime? now}) async {
    final store = _photos;
    final bytes = buildBackupArchive(
      exportData: await buildExportData(_db,
          lifetimeCourses: lifetimeCourses, now: now),
      media: store == null
          ? const {}
          : await _db.journal().collectMedia(store),
    );
    return shareStampedFile(
      share: _share,
      tempDir: _tempDir,
      baseName: 'courseledger-backup',
      extension: 'zip',
      mimeType: 'application/zip',
      shareText: 'Course Ledger backup',
      bytes: bytes,
      now: now,
    );
  }
}
