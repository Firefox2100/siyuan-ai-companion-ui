import 'package:siyuan_ai_companion_ui/l10n/localizations.dart';

class LocalizationService {
  static late AppLocalizations _l10n;
  static AppLocalizations get l10n => _l10n;

  static void update(AppLocalizations newL10n) {
    _l10n = newL10n;
  }
}