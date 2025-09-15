import 'dart:io';
import 'package:flutter/material.dart';

/// Manages Git repository status and state
class GitStatusManager {
  GitStatusManager(this.workingDirectory);

  final String workingDirectory;

  bool _isGitRepository = false;
  String _currentBranch = 'main';
  List<String> _changedFiles = [];

  bool get isGitRepository => _isGitRepository;
  String get currentBranch => _currentBranch;
  List<String> get changedFiles => _changedFiles;

  /// Check if current directory is a Git repository and update status
  Future<void> checkGitStatus() async {
    // Don't check git status if working directory is current project directory
    if (workingDirectory == '.') {
      _isGitRepository = false;
      _currentBranch = '';
      _changedFiles = [];
      return;
    }

    try {
      // Check if we're in a Git repository
      final gitDirResult = await Process.run(
        'git',
        ['rev-parse', '--git-dir'],
        workingDirectory: workingDirectory,
      );

      _isGitRepository = gitDirResult.exitCode == 0;

      if (_isGitRepository) {
        // Get current branch
        final branchResult = await Process.run(
          'git',
          ['rev-parse', '--abbrev-ref', 'HEAD'],
          workingDirectory: workingDirectory,
        );

        if (branchResult.exitCode == 0) {
          _currentBranch = branchResult.stdout.toString().trim();
        }

        // Get changed files
        final statusResult = await Process.run(
          'git',
          ['status', '--porcelain'],
          workingDirectory: workingDirectory,
        );

        if (statusResult.exitCode == 0) {
          final statusLines = statusResult.stdout.toString().split('\n');
          _changedFiles = statusLines
              .where((line) => line.isNotEmpty)
              .map((line) => line.substring(3).trim()) // Remove status codes
              .toList();
        }
      } else {
        _currentBranch = '';
        _changedFiles = [];
      }
    } catch (e) {
      // Git not available or other error
      _isGitRepository = false;
      _currentBranch = '';
      _changedFiles = [];
      debugPrint('Failed to check git status: $e');
    }
  }

  /// Refresh the status after operations
  Future<void> refreshStatus() async {
    await checkGitStatus();
  }
}
