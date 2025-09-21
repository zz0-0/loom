import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Export format enumeration
enum ExportFormat {
  pdf('pdf'),
  html('html'),
  markdown('markdown'),
  plainText('plainText');

  const ExportFormat(this.key);
  final String key;

  String displayName(AppLocalizations localizations) {
    switch (this) {
      case ExportFormat.pdf:
        return localizations.pdf;
      case ExportFormat.html:
        return localizations.html;
      case ExportFormat.markdown:
        return localizations.markdown;
      case ExportFormat.plainText:
        return localizations.plainText;
    }
  }
}
