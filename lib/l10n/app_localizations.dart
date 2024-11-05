import 'package:flutter/material.dart';
import 'package:velocity_app/l10n/app_localizations_ja.dart';
import 'package:velocity_app/l10n/app_localizations_vi.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

abstract class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get title;
  String get welcomeMessage;
  String get helloWorld;
  String get letsGetStarted;
  String get home;
  String get explore;
  String get myBooking;
  String get profile;
  String get editProfile;
  String get myPaymentOptions;
  String get myCards;
  String get payYourBookingInOneSingleTap;
  String get myReceipts;
  String get viewYourBookingReceiptsAndHistory;
  String get myRewards;
  String get myMissions;
  String get completeMoreMissions;
  String get coupons;
  String get viewCoupons;
  String get rewards;
  String get trackRewards;
  String get advancedOptions;
  String get helpCenter;
  String get findTheBestAnswerToYourQuestions;
  String get contactUs;
  String get getHelpFromOurCustomerService;
  String get settings;
  String get manageYourAccountSettings;
  String get accountAndSecurity;
  String get accountInformation;
  String get passwordAndSecurity;
  String get profilePrivacy;
  String get preferences;
  String get language;
  String get termsAndConditions;
  String get privacyPolicy;
  String get aboutUs;
  String get logOut;
  String get selectLanguage;
  String get areYouSureYouWantToLogOut;
  String get cancel;
  String get bookATour;
  String get bookAHotel;
  String get bookAFlight;
  String get bookACar;
  String get tours;
  String get hotels;
  String get flights;
  String get carRentals;
  String get price;
  String get rating;
  String get duration;
  String get popularity;
  String get newest;
  String get description;
  String get overview;
  String get address;
  String get contact;
  String get chooseYourDate;
  String get chooseYourAmount;
  String get perTicket;
  String get allChargesIncluded;
  String get bookNow;
  String get booking;
  String get fillInDetails;
  String get payment;
  String get pleaseCheckYourBooking;
  String get amount;
  String get loggedInAs;
  String get guestDetails;
  String get name;
  String get phoneNumber;
  String get email;
  String get priceDetails;
  String get tax;
  String get total;
  String get continueToPayment;
  String get scanTheQRCodeToPay;
  String get completePayment;
  String get like;
  String get comment;
  String get share;
  String get likes;
  String get comments;
  String get shares;
  String get writeAComment;
  String get reply;
  String get posts;
  String get whatsOnYourMindQuestion;
  String get whatsOnYourMindSentence;
  String get createPost;
  String get post;
  String get pickImageFromGallery;
  String get pickVideoFromGallery;
  String get takePhoto;
  String get addLocation;
  String get addPeople;
  String get active;
  String get past;
  String get saved;
  String get bookmarkAdded;
  String get bookmarkRemoved;
  String get destination;
  String get city;
  String get capacity;
  String get origin;
  String get departureTime;
  String get arrivalTime;
  String get airline;
  String get location;
  String get carType;
  String get savePost;
  String get saveThisPostToYourSavedPosts;
  String get hidePost;
  String get seeFewerPostsLikeThis;
  String get reportPost;
  String get reportThisPostToTheAdmin;
  String get deletePost;
  String get deleteThisPost;
  String get areYouSureYouWantToDeleteThisPost;
  String get delete;
  String get postHasBeenDeletedSuccessfully;
  String get shareYourThoughts;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'vi', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'es':
        return AppLocalizationsEs();
      case 'fr':
        return AppLocalizationsFr();
      case 'vi':
        return AppLocalizationsVi();
      case 'ja':
        return AppLocalizationsJa();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
