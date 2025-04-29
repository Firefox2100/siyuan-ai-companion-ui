import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_en.dart';
import 'localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SiYuan AI Companion'**
  String get appTitle;

  /// No description provided for @openAiApiSettings.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API Settings'**
  String get openAiApiSettings;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @apiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'API key to authenticate with the server'**
  String get apiKeyHint;

  /// No description provided for @orgId.
  ///
  /// In en, this message translates to:
  /// **'OpenAI Organization ID'**
  String get orgId;

  /// No description provided for @orgIdHint.
  ///
  /// In en, this message translates to:
  /// **'Optional if using self-hosted OpenAI API'**
  String get orgIdHint;

  /// No description provided for @openAiModel.
  ///
  /// In en, this message translates to:
  /// **'OpenAI Model'**
  String get openAiModel;

  /// No description provided for @openAiModelHint.
  ///
  /// In en, this message translates to:
  /// **'The model to use for generation'**
  String get openAiModelHint;

  /// No description provided for @openAiApiUrl.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API URL'**
  String get openAiApiUrl;

  /// No description provided for @openAiApiUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use the backend API'**
  String get openAiApiUrlHint;

  /// No description provided for @openAiSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'OpenAI System Prompt'**
  String get openAiSystemPrompt;

  /// No description provided for @openAiSystemPromptHint.
  ///
  /// In en, this message translates to:
  /// **'The system prompt to use for generation'**
  String get openAiSystemPromptHint;

  /// No description provided for @chatSavingNotebook.
  ///
  /// In en, this message translates to:
  /// **'Chat Saving Notebook'**
  String get chatSavingNotebook;

  /// No description provided for @chatSavingNotebookHint.
  ///
  /// In en, this message translates to:
  /// **'Select a notebook to save chat history'**
  String get chatSavingNotebookHint;

  /// No description provided for @enableRag.
  ///
  /// In en, this message translates to:
  /// **'Enable RAG'**
  String get enableRag;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @newConversationName.
  ///
  /// In en, this message translates to:
  /// **'@New Conversation'**
  String get newConversationName;

  /// RAG prompt template
  ///
  /// In en, this message translates to:
  /// **'Context:\\n{context}\\nAnswer the question: {question}\\nAnswer:'**
  String ragPrompt(String context, String question);

  /// No description provided for @defaultSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are an assistant whose primary role is to answer user questions and provide writing assistance.\n  Always prioritize any context explicitly provided with the user prompt.\n  If something is unclear, ambiguous, or outside your knowledge, clearly communicate this to the user instead of making assumptions.\n  Maintain a helpful, accurate, and concise tone.\n  When providing writing assistance, ensure clarity, structure, and relevance to the user\'s request.'**
  String get defaultSystemPrompt;

  /// No description provided for @logoLabel.
  ///
  /// In en, this message translates to:
  /// **'SiYuan AI Companion Logo'**
  String get logoLabel;

  /// No description provided for @transcribe.
  ///
  /// In en, this message translates to:
  /// **'Transcribe'**
  String get transcribe;

  /// No description provided for @noAudioAssetMessage.
  ///
  /// In en, this message translates to:
  /// **'No audio assets found'**
  String get noAudioAssetMessage;

  /// No description provided for @noTranscription.
  ///
  /// In en, this message translates to:
  /// **'No transcription'**
  String get noTranscription;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @renameSession.
  ///
  /// In en, this message translates to:
  /// **'Rename Session'**
  String get renameSession;

  /// No description provided for @newName.
  ///
  /// In en, this message translates to:
  /// **'New Name'**
  String get newName;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @deleteSessionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this session?'**
  String get deleteSessionConfirmation;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SiYuan AI Companion'**
  String get welcomeMessage;

  /// No description provided for @calendarPrompt.
  ///
  /// In en, this message translates to:
  /// **'What is in my calendar today?'**
  String get calendarPrompt;

  /// No description provided for @authenticatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to continue'**
  String get authenticatePrompt;

  /// No description provided for @authenticate.
  ///
  /// In en, this message translates to:
  /// **'Authenticate'**
  String get authenticate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
