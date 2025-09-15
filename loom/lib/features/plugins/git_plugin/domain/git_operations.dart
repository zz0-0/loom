import 'dart:io';
import 'package:flutter/material.dart';

/// Service for executing Git operations
class GitOperations {
  GitOperations(this.workingDirectory);

  final String workingDirectory;

  /// Stage a file
  Future<bool> stageFile(String file) async {
    if (workingDirectory.isEmpty) return false;

    try {
      final result = await Process.run(
        'git',
        ['add', file],
        workingDirectory: workingDirectory,
      );
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Failed to stage file: $e');
      return false;
    }
  }

  /// Unstage a file
  Future<bool> unstageFile(String file) async {
    if (workingDirectory.isEmpty) return false;

    try {
      final result = await Process.run(
        'git',
        ['reset', 'HEAD', file],
        workingDirectory: workingDirectory,
      );
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Failed to unstage file: $e');
      return false;
    }
  }

  /// Commit changes with a message
  Future<bool> commitChanges(String message) async {
    if (workingDirectory.isEmpty) return false;

    try {
      final result = await Process.run(
        'git',
        ['commit', '-m', message],
        workingDirectory: workingDirectory,
      );
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Failed to commit changes: $e');
      return false;
    }
  }

  /// Push changes to remote
  Future<bool> pushChanges() async {
    if (workingDirectory.isEmpty) return false;

    try {
      final result = await Process.run(
        'git',
        ['push'],
        workingDirectory: workingDirectory,
      );
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Failed to push changes: $e');
      return false;
    }
  }

  /// Pull changes from remote
  Future<bool> pullChanges() async {
    if (workingDirectory.isEmpty) return false;

    try {
      final result = await Process.run(
        'git',
        ['pull'],
        workingDirectory: workingDirectory,
      );
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Failed to pull changes: $e');
      return false;
    }
  }

  /// Get Git status
  Future<String?> getStatus() async {
    if (workingDirectory.isEmpty) return null;

    try {
      final result = await Process.run(
        'git',
        ['status', '--porcelain'],
        workingDirectory: workingDirectory,
      );
      if (result.exitCode == 0) {
        return result.stdout.toString();
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get git status: $e');
      return null;
    }
  }

  /// Initialize a new Git repository
  Future<bool> initializeRepository() async {
    if (workingDirectory.isEmpty) return false;

    try {
      final result = await Process.run(
        'git',
        ['init'],
        workingDirectory: workingDirectory,
      );
      return result.exitCode == 0;
    } catch (e) {
      debugPrint('Failed to initialize git repository: $e');
      return false;
    }
  }
}
