// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Accessing Teacher Classrooms`
  String get accessingTeacherClassrooms {
    return Intl.message(
      'Accessing Teacher Classrooms',
      name: 'accessingTeacherClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `Account details`
  String get accountDetails {
    return Intl.message(
      'Account details',
      name: 'accountDetails',
      desc: '',
      args: [],
    );
  }

  /// `Completed Plans`
  String get achievementsCompletedPlans {
    return Intl.message(
      'Completed Plans',
      name: 'achievementsCompletedPlans',
      desc: '',
      args: [],
    );
  }

  /// `No completed Plans found`
  String get achievementsNoCompletedPlans {
    return Intl.message(
      'No completed Plans found',
      name: 'achievementsNoCompletedPlans',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `All attempts`
  String get allAttempts {
    return Intl.message(
      'All attempts',
      name: 'allAttempts',
      desc: '',
      args: [],
    );
  }

  /// `amount`
  String get amount {
    return Intl.message(
      'amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `App language`
  String get appLanguage {
    return Intl.message(
      'App language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Ask AI`
  String get askAi {
    return Intl.message(
      'Ask AI',
      name: 'askAi',
      desc: '',
      args: [],
    );
  }

  /// `Author's messages`
  String get authorNotifications {
    return Intl.message(
      'Author\'s messages',
      name: 'authorNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Beginning`
  String get beginning {
    return Intl.message(
      'Beginning',
      name: 'beginning',
      desc: '',
      args: [],
    );
  }

  /// `Benefits of Playlists`
  String get benefitsOfPlaylists {
    return Intl.message(
      'Benefits of Playlists',
      name: 'benefitsOfPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message(
      'Cancelled',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `4 seasons`
  String get category4Seasons {
    return Intl.message(
      '4 seasons',
      name: 'category4Seasons',
      desc: '',
      args: [],
    );
  }

  /// `5 senses`
  String get category5Senses {
    return Intl.message(
      '5 senses',
      name: 'category5Senses',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get categoryAddress {
    return Intl.message(
      'Address',
      name: 'categoryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Agile Methodology`
  String get categoryAgileMethodology {
    return Intl.message(
      'Agile Methodology',
      name: 'categoryAgileMethodology',
      desc: '',
      args: [],
    );
  }

  /// `Airport`
  String get categoryAirport {
    return Intl.message(
      'Airport',
      name: 'categoryAirport',
      desc: '',
      args: [],
    );
  }

  /// `All categories`
  String get categoryAllCategories {
    return Intl.message(
      'All categories',
      name: 'categoryAllCategories',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet`
  String get categoryAlphabet {
    return Intl.message(
      'Alphabet',
      name: 'categoryAlphabet',
      desc: '',
      args: [],
    );
  }

  /// `Animals`
  String get categoryAnimals {
    return Intl.message(
      'Animals',
      name: 'categoryAnimals',
      desc: '',
      args: [],
    );
  }

  /// `Appointments`
  String get categoryAppointments {
    return Intl.message(
      'Appointments',
      name: 'categoryAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Aquatic, semi-aquatic animals`
  String get categoryAquaticSemiAquaticAnimals {
    return Intl.message(
      'Aquatic, semi-aquatic animals',
      name: 'categoryAquaticSemiAquaticAnimals',
      desc: '',
      args: [],
    );
  }

  /// `Basics`
  String get categoryBasics {
    return Intl.message(
      'Basics',
      name: 'categoryBasics',
      desc: '',
      args: [],
    );
  }

  /// `Being polite`
  String get categoryBeingPolite {
    return Intl.message(
      'Being polite',
      name: 'categoryBeingPolite',
      desc: '',
      args: [],
    );
  }

  /// `Body`
  String get categoryBody {
    return Intl.message(
      'Body',
      name: 'categoryBody',
      desc: '',
      args: [],
    );
  }

  /// `Body parts`
  String get categoryBodyParts {
    return Intl.message(
      'Body parts',
      name: 'categoryBodyParts',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get categoryBusiness {
    return Intl.message(
      'Business',
      name: 'categoryBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Celebrations`
  String get categoryCelebrations {
    return Intl.message(
      'Celebrations',
      name: 'categoryCelebrations',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get categoryClothing {
    return Intl.message(
      'Clothing',
      name: 'categoryClothing',
      desc: '',
      args: [],
    );
  }

  /// `Community`
  String get categoryCommunity {
    return Intl.message(
      'Community',
      name: 'categoryCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Community helpers`
  String get categoryCommunityHelpers {
    return Intl.message(
      'Community helpers',
      name: 'categoryCommunityHelpers',
      desc: '',
      args: [],
    );
  }

  /// `Conflict`
  String get categoryConflict {
    return Intl.message(
      'Conflict',
      name: 'categoryConflict',
      desc: '',
      args: [],
    );
  }

  /// `Cooking`
  String get categoryCooking {
    return Intl.message(
      'Cooking',
      name: 'categoryCooking',
      desc: '',
      args: [],
    );
  }

  /// `Countries, continents`
  String get categoryCountriesContinents {
    return Intl.message(
      'Countries, continents',
      name: 'categoryCountriesContinents',
      desc: '',
      args: [],
    );
  }

  /// `Culture`
  String get categoryCulture {
    return Intl.message(
      'Culture',
      name: 'categoryCulture',
      desc: '',
      args: [],
    );
  }

  /// `Days, months, years`
  String get categoryDaysMonthsYears {
    return Intl.message(
      'Days, months, years',
      name: 'categoryDaysMonthsYears',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get categoryDirections {
    return Intl.message(
      'Directions',
      name: 'categoryDirections',
      desc: '',
      args: [],
    );
  }

  /// `Domestic animals/pets`
  String get categoryDomesticAnimalsPets {
    return Intl.message(
      'Domestic animals/pets',
      name: 'categoryDomesticAnimalsPets',
      desc: '',
      args: [],
    );
  }

  /// `Emails`
  String get categoryEmails {
    return Intl.message(
      'Emails',
      name: 'categoryEmails',
      desc: '',
      args: [],
    );
  }

  /// `Environmental issues`
  String get categoryEnvironmentalIssues {
    return Intl.message(
      'Environmental issues',
      name: 'categoryEnvironmentalIssues',
      desc: '',
      args: [],
    );
  }

  /// `Extended family`
  String get categoryExtendedFamily {
    return Intl.message(
      'Extended family',
      name: 'categoryExtendedFamily',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get categoryFamily {
    return Intl.message(
      'Family',
      name: 'categoryFamily',
      desc: '',
      args: [],
    );
  }

  /// `Feelings, emotions`
  String get categoryFeelingsEmotions {
    return Intl.message(
      'Feelings, emotions',
      name: 'categoryFeelingsEmotions',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get categoryFood {
    return Intl.message(
      'Food',
      name: 'categoryFood',
      desc: '',
      args: [],
    );
  }

  /// `Government`
  String get categoryGovernment {
    return Intl.message(
      'Government',
      name: 'categoryGovernment',
      desc: '',
      args: [],
    );
  }

  /// `Grammar`
  String get categoryGrammar {
    return Intl.message(
      'Grammar',
      name: 'categoryGrammar',
      desc: '',
      args: [],
    );
  }

  /// `Greetings`
  String get categoryGreetings {
    return Intl.message(
      'Greetings',
      name: 'categoryGreetings',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get categoryHealth {
    return Intl.message(
      'Health',
      name: 'categoryHealth',
      desc: '',
      args: [],
    );
  }

  /// `Holiday greetings`
  String get categoryHolidayGreetings {
    return Intl.message(
      'Holiday greetings',
      name: 'categoryHolidayGreetings',
      desc: '',
      args: [],
    );
  }

  /// `Holidays`
  String get categoryHolidays {
    return Intl.message(
      'Holidays',
      name: 'categoryHolidays',
      desc: '',
      args: [],
    );
  }

  /// `Immediate family`
  String get categoryImmediateFamily {
    return Intl.message(
      'Immediate family',
      name: 'categoryImmediateFamily',
      desc: '',
      args: [],
    );
  }

  /// `Immigration`
  String get categoryImmigration {
    return Intl.message(
      'Immigration',
      name: 'categoryImmigration',
      desc: '',
      args: [],
    );
  }

  /// `Indoor, outdoor activities`
  String get categoryIndoorOutdoorActivates {
    return Intl.message(
      'Indoor, outdoor activities',
      name: 'categoryIndoorOutdoorActivates',
      desc: '',
      args: [],
    );
  }

  /// `Information Technology`
  String get categoryInformationTechnology {
    return Intl.message(
      'Information Technology',
      name: 'categoryInformationTechnology',
      desc: '',
      args: [],
    );
  }

  /// `International, domestic travel`
  String get categoryInternationalDomesticTravel {
    return Intl.message(
      'International, domestic travel',
      name: 'categoryInternationalDomesticTravel',
      desc: '',
      args: [],
    );
  }

  /// `Interviewing`
  String get categoryInterviewing {
    return Intl.message(
      'Interviewing',
      name: 'categoryInterviewing',
      desc: '',
      args: [],
    );
  }

  /// `Introductions`
  String get categoryIntroductions {
    return Intl.message(
      'Introductions',
      name: 'categoryIntroductions',
      desc: '',
      args: [],
    );
  }

  /// `Job descriptions`
  String get categoryJobDescriptions {
    return Intl.message(
      'Job descriptions',
      name: 'categoryJobDescriptions',
      desc: '',
      args: [],
    );
  }

  /// `Landmarks`
  String get categoryLandmarks {
    return Intl.message(
      'Landmarks',
      name: 'categoryLandmarks',
      desc: '',
      args: [],
    );
  }

  /// `Language testing`
  String get categoryLanguageTesting {
    return Intl.message(
      'Language testing',
      name: 'categoryLanguageTesting',
      desc: '',
      args: [],
    );
  }

  /// `Leading meetings`
  String get categoryLeadingMeetings {
    return Intl.message(
      'Leading meetings',
      name: 'categoryLeadingMeetings',
      desc: '',
      args: [],
    );
  }

  /// `Life`
  String get categoryLife {
    return Intl.message(
      'Life',
      name: 'categoryLife',
      desc: '',
      args: [],
    );
  }

  /// `Life Abroad`
  String get categoryLifeAbroad {
    return Intl.message(
      'Life Abroad',
      name: 'categoryLifeAbroad',
      desc: '',
      args: [],
    );
  }

  /// `Math terms`
  String get categoryMathTerms {
    return Intl.message(
      'Math terms',
      name: 'categoryMathTerms',
      desc: '',
      args: [],
    );
  }

  /// `Mathematics`
  String get categoryMathematics {
    return Intl.message(
      'Mathematics',
      name: 'categoryMathematics',
      desc: '',
      args: [],
    );
  }

  /// `Meals`
  String get categoryMeals {
    return Intl.message(
      'Meals',
      name: 'categoryMeals',
      desc: '',
      args: [],
    );
  }

  /// `Meeting new people`
  String get categoryMeetingNewPeople {
    return Intl.message(
      'Meeting new people',
      name: 'categoryMeetingNewPeople',
      desc: '',
      args: [],
    );
  }

  /// `Mental health`
  String get categoryMentalHealth {
    return Intl.message(
      'Mental health',
      name: 'categoryMentalHealth',
      desc: '',
      args: [],
    );
  }

  /// `Money and Finances`
  String get categoryMoneyAndFinances {
    return Intl.message(
      'Money and Finances',
      name: 'categoryMoneyAndFinances',
      desc: '',
      args: [],
    );
  }

  /// `Movements`
  String get categoryMovements {
    return Intl.message(
      'Movements',
      name: 'categoryMovements',
      desc: '',
      args: [],
    );
  }

  /// `Negotiations`
  String get categoryNegotiations {
    return Intl.message(
      'Negotiations',
      name: 'categoryNegotiations',
      desc: '',
      args: [],
    );
  }

  /// `Neighborhood`
  String get categoryNeighborhood {
    return Intl.message(
      'Neighborhood',
      name: 'categoryNeighborhood',
      desc: '',
      args: [],
    );
  }

  /// `Numbers`
  String get categoryNumbers {
    return Intl.message(
      'Numbers',
      name: 'categoryNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Ordering out`
  String get categoryOrderingOut {
    return Intl.message(
      'Ordering out',
      name: 'categoryOrderingOut',
      desc: '',
      args: [],
    );
  }

  /// `Our world`
  String get categoryOurWorld {
    return Intl.message(
      'Our world',
      name: 'categoryOurWorld',
      desc: '',
      args: [],
    );
  }

  /// `Past, present, future`
  String get categoryPastPresentFuture {
    return Intl.message(
      'Past, present, future',
      name: 'categoryPastPresentFuture',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get categoryPhoneNumber {
    return Intl.message(
      'Phone number',
      name: 'categoryPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phonetics`
  String get categoryPhonetics {
    return Intl.message(
      'Phonetics',
      name: 'categoryPhonetics',
      desc: '',
      args: [],
    );
  }

  /// `Phonics`
  String get categoryPhonics {
    return Intl.message(
      'Phonics',
      name: 'categoryPhonics',
      desc: '',
      args: [],
    );
  }

  /// `Phrases`
  String get categoryPhrases {
    return Intl.message(
      'Phrases',
      name: 'categoryPhrases',
      desc: '',
      args: [],
    );
  }

  /// `Pollution`
  String get categoryPollution {
    return Intl.message(
      'Pollution',
      name: 'categoryPollution',
      desc: '',
      args: [],
    );
  }

  /// `Professional roles`
  String get categoryProfessionalRoles {
    return Intl.message(
      'Professional roles',
      name: 'categoryProfessionalRoles',
      desc: '',
      args: [],
    );
  }

  /// `Public transportation`
  String get categoryPublicTransportation {
    return Intl.message(
      'Public transportation',
      name: 'categoryPublicTransportation',
      desc: '',
      args: [],
    );
  }

  /// `Religion`
  String get categoryReligion {
    return Intl.message(
      'Religion',
      name: 'categoryReligion',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants`
  String get categoryRestaurants {
    return Intl.message(
      'Restaurants',
      name: 'categoryRestaurants',
      desc: '',
      args: [],
    );
  }

  /// `Safety`
  String get categorySafety {
    return Intl.message(
      'Safety',
      name: 'categorySafety',
      desc: '',
      args: [],
    );
  }

  /// `School`
  String get categorySchool {
    return Intl.message(
      'School',
      name: 'categorySchool',
      desc: '',
      args: [],
    );
  }

  /// `Sharing information`
  String get categorySharingInformation {
    return Intl.message(
      'Sharing information',
      name: 'categorySharingInformation',
      desc: '',
      args: [],
    );
  }

  /// `Shopping`
  String get categoryShopping {
    return Intl.message(
      'Shopping',
      name: 'categoryShopping',
      desc: '',
      args: [],
    );
  }

  /// `Small talk`
  String get categorySmallTalk {
    return Intl.message(
      'Small talk',
      name: 'categorySmallTalk',
      desc: '',
      args: [],
    );
  }

  /// `Sports, play`
  String get categorySportsPlay {
    return Intl.message(
      'Sports, play',
      name: 'categorySportsPlay',
      desc: '',
      args: [],
    );
  }

  /// `Storytelling`
  String get categoryStorytelling {
    return Intl.message(
      'Storytelling',
      name: 'categoryStorytelling',
      desc: '',
      args: [],
    );
  }

  /// `Subjects`
  String get categorySubjects {
    return Intl.message(
      'Subjects',
      name: 'categorySubjects',
      desc: '',
      args: [],
    );
  }

  /// `Technology`
  String get categoryTechnology {
    return Intl.message(
      'Technology',
      name: 'categoryTechnology',
      desc: '',
      args: [],
    );
  }

  /// `The weather`
  String get categoryTheWeather {
    return Intl.message(
      'The weather',
      name: 'categoryTheWeather',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get categoryTime {
    return Intl.message(
      'Time',
      name: 'categoryTime',
      desc: '',
      args: [],
    );
  }

  /// `Traditions`
  String get categoryTraditions {
    return Intl.message(
      'Traditions',
      name: 'categoryTraditions',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get categoryTravel {
    return Intl.message(
      'Travel',
      name: 'categoryTravel',
      desc: '',
      args: [],
    );
  }

  /// `Vehicles`
  String get categoryVehicles {
    return Intl.message(
      'Vehicles',
      name: 'categoryVehicles',
      desc: '',
      args: [],
    );
  }

  /// `Vocabulary`
  String get categoryVocabulary {
    return Intl.message(
      'Vocabulary',
      name: 'categoryVocabulary',
      desc: '',
      args: [],
    );
  }

  /// `Wild animals`
  String get categoryWildAnimals {
    return Intl.message(
      'Wild animals',
      name: 'categoryWildAnimals',
      desc: '',
      args: [],
    );
  }

  /// `Work`
  String get categoryWork {
    return Intl.message(
      'Work',
      name: 'categoryWork',
      desc: '',
      args: [],
    );
  }

  /// `Working-out`
  String get categoryWorkingOut {
    return Intl.message(
      'Working-out',
      name: 'categoryWorkingOut',
      desc: '',
      args: [],
    );
  }

  /// `Yoga`
  String get categoryYoga {
    return Intl.message(
      'Yoga',
      name: 'categoryYoga',
      desc: '',
      args: [],
    );
  }

  /// `Challenges you liked`
  String get challengesYouLiked {
    return Intl.message(
      'Challenges you liked',
      name: 'challengesYouLiked',
      desc: '',
      args: [],
    );
  }

  /// `Channel Content`
  String get channelContent {
    return Intl.message(
      'Channel Content',
      name: 'channelContent',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get chatUsers {
    return Intl.message(
      'Users',
      name: 'chatUsers',
      desc: '',
      args: [],
    );
  }

  /// `Choose a different payment`
  String get chooseDifferentPayment {
    return Intl.message(
      'Choose a different payment',
      name: 'chooseDifferentPayment',
      desc: '',
      args: [],
    );
  }

  /// `Choose a different payment`
  String get chooseDifferentPaymentPlan {
    return Intl.message(
      'Choose a different payment',
      name: 'chooseDifferentPaymentPlan',
      desc: '',
      args: [],
    );
  }

  /// `Ask to join`
  String get classroomAsk2Join {
    return Intl.message(
      'Ask to join',
      name: 'classroomAsk2Join',
      desc: '',
      args: [],
    );
  }

  /// `Campuses`
  String get classroomCampuses {
    return Intl.message(
      'Campuses',
      name: 'classroomCampuses',
      desc: '',
      args: [],
    );
  }

  /// `Can delete`
  String get classroomCanDelete {
    return Intl.message(
      'Can delete',
      name: 'classroomCanDelete',
      desc: '',
      args: [],
    );
  }

  /// `Can update`
  String get classroomCanUpdate {
    return Intl.message(
      'Can update',
      name: 'classroomCanUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Cancel invitation`
  String get classroomCancelInvitation {
    return Intl.message(
      'Cancel invitation',
      name: 'classroomCancelInvitation',
      desc: '',
      args: [],
    );
  }

  /// `canceled`
  String get classroomCancelled {
    return Intl.message(
      'canceled',
      name: 'classroomCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Classroom`
  String get classroomClassroom {
    return Intl.message(
      'Classroom',
      name: 'classroomClassroom',
      desc: '',
      args: [],
    );
  }

  /// `confirmed`
  String get classroomConfirmed {
    return Intl.message(
      'confirmed',
      name: 'classroomConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Create classroom`
  String get classroomCreateCr {
    return Intl.message(
      'Create classroom',
      name: 'classroomCreateCr',
      desc: '',
      args: [],
    );
  }

  /// `Create new classroom`
  String get classroomCreateNewCr {
    return Intl.message(
      'Create new classroom',
      name: 'classroomCreateNewCr',
      desc: '',
      args: [],
    );
  }

  /// `Current classroom`
  String get classroomCurrentCr {
    return Intl.message(
      'Current classroom',
      name: 'classroomCurrentCr',
      desc: '',
      args: [],
    );
  }

  /// `Element count`
  String get classroomElementCount {
    return Intl.message(
      'Element count',
      name: 'classroomElementCount',
      desc: '',
      args: [],
    );
  }

  /// `Enter classroom name`
  String get classroomEnterCrName {
    return Intl.message(
      'Enter classroom name',
      name: 'classroomEnterCrName',
      desc: '',
      args: [],
    );
  }

  /// `Invitations`
  String get classroomInvitations {
    return Intl.message(
      'Invitations',
      name: 'classroomInvitations',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get classroomInvite {
    return Intl.message(
      'Invite',
      name: 'classroomInvite',
      desc: '',
      args: [],
    );
  }

  /// `invited`
  String get classroomInvited {
    return Intl.message(
      'invited',
      name: 'classroomInvited',
      desc: '',
      args: [],
    );
  }

  /// `Join the classroom`
  String get classroomJoinCr {
    return Intl.message(
      'Join the classroom',
      name: 'classroomJoinCr',
      desc: '',
      args: [],
    );
  }

  /// `Keep it between 2 and 42 characters`
  String get classroomNameLength {
    return Intl.message(
      'Keep it between 2 and 42 characters',
      name: 'classroomNameLength',
      desc: '',
      args: [],
    );
  }

  /// `owner`
  String get classroomOwner {
    return Intl.message(
      'owner',
      name: 'classroomOwner',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get classroomPeople {
    return Intl.message(
      'People',
      name: 'classroomPeople',
      desc: '',
      args: [],
    );
  }

  /// `Person`
  String get classroomPerson {
    return Intl.message(
      'Person',
      name: 'classroomPerson',
      desc: '',
      args: [],
    );
  }

  /// `Plans`
  String get classroomPlans {
    return Intl.message(
      'Plans',
      name: 'classroomPlans',
      desc: '',
      args: [],
    );
  }

  /// `Rejected invitations`
  String get classroomRejectedInv {
    return Intl.message(
      'Rejected invitations',
      name: 'classroomRejectedInv',
      desc: '',
      args: [],
    );
  }

  /// `requested`
  String get classroomRequested {
    return Intl.message(
      'requested',
      name: 'classroomRequested',
      desc: '',
      args: [],
    );
  }

  /// `Search Classroom`
  String get classroomSearchClassroom {
    return Intl.message(
      'Search Classroom',
      name: 'classroomSearchClassroom',
      desc: '',
      args: [],
    );
  }

  /// `You requested to join`
  String get classroomYouRequested2Join {
    return Intl.message(
      'You requested to join',
      name: 'classroomYouRequested2Join',
      desc: '',
      args: [],
    );
  }

  /// `You were invited`
  String get classroomYouWereInvited {
    return Intl.message(
      'You were invited',
      name: 'classroomYouWereInvited',
      desc: '',
      args: [],
    );
  }

  /// `Color theme`
  String get colorTheme {
    return Intl.message(
      'Color theme',
      name: 'colorTheme',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Challenge`
  String get contentChallenge {
    return Intl.message(
      'Challenge',
      name: 'contentChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Playlist`
  String get contentPlaylist {
    return Intl.message(
      'Playlist',
      name: 'contentPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Story`
  String get contentStory {
    return Intl.message(
      'Story',
      name: 'contentStory',
      desc: '',
      args: [],
    );
  }

  /// `Current Class of the Organization`
  String get currentClassOrganization {
    return Intl.message(
      'Current Class of the Organization',
      name: 'currentClassOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Daily Progress`
  String get dailyProgress {
    return Intl.message(
      'Daily Progress',
      name: 'dailyProgress',
      desc: '',
      args: [],
    );
  }

  /// `Autonomous`
  String get discoveryAutonomous {
    return Intl.message(
      'Autonomous',
      name: 'discoveryAutonomous',
      desc: '',
      args: [],
    );
  }

  /// `Classrooms and Topics`
  String get discoveryAutonomousSubtitle {
    return Intl.message(
      'Classrooms and Topics',
      name: 'discoveryAutonomousSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Challenges`
  String get discoveryChallenges {
    return Intl.message(
      'Challenges',
      name: 'discoveryChallenges',
      desc: '',
      args: [],
    );
  }

  /// `Repeat after the mentor`
  String get discoveryChallengesSubtitle {
    return Intl.message(
      'Repeat after the mentor',
      name: 'discoveryChallengesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Channels`
  String get discoveryChannels {
    return Intl.message(
      'Channels',
      name: 'discoveryChannels',
      desc: '',
      args: [],
    );
  }

  /// `Place where content lives`
  String get discoveryChannelsSubtitle {
    return Intl.message(
      'Place where content lives',
      name: 'discoveryChannelsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get discoveryPlaylists {
    return Intl.message(
      'Playlists',
      name: 'discoveryPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Many challenges together`
  String get discoveryPlaylistsSubtitle {
    return Intl.message(
      'Many challenges together',
      name: 'discoveryPlaylistsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Stories`
  String get discoveryStories {
    return Intl.message(
      'Stories',
      name: 'discoveryStories',
      desc: '',
      args: [],
    );
  }

  /// `Repeat after the character`
  String get discoveryStoriesSubtitle {
    return Intl.message(
      'Repeat after the character',
      name: 'discoveryStoriesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Duet`
  String get duet {
    return Intl.message(
      'Duet',
      name: 'duet',
      desc: '',
      args: [],
    );
  }

  /// `Elementary`
  String get elementary {
    return Intl.message(
      'Elementary',
      name: 'elementary',
      desc: '',
      args: [],
    );
  }

  /// `Aggressiveness`
  String get emotion2Aggressiveness {
    return Intl.message(
      'Aggressiveness',
      name: 'emotion2Aggressiveness',
      desc: '',
      args: [],
    );
  }

  /// `Awe`
  String get emotion2Awe {
    return Intl.message(
      'Awe',
      name: 'emotion2Awe',
      desc: '',
      args: [],
    );
  }

  /// `Contempt`
  String get emotion2Contempt {
    return Intl.message(
      'Contempt',
      name: 'emotion2Contempt',
      desc: '',
      args: [],
    );
  }

  /// `Disapproval`
  String get emotion2Disapproval {
    return Intl.message(
      'Disapproval',
      name: 'emotion2Disapproval',
      desc: '',
      args: [],
    );
  }

  /// `Love`
  String get emotion2Love {
    return Intl.message(
      'Love',
      name: 'emotion2Love',
      desc: '',
      args: [],
    );
  }

  /// `Neutral`
  String get emotion2Neutral {
    return Intl.message(
      'Neutral',
      name: 'emotion2Neutral',
      desc: '',
      args: [],
    );
  }

  /// `Optimism`
  String get emotion2Optimism {
    return Intl.message(
      'Optimism',
      name: 'emotion2Optimism',
      desc: '',
      args: [],
    );
  }

  /// `Remorse`
  String get emotion2Remorse {
    return Intl.message(
      'Remorse',
      name: 'emotion2Remorse',
      desc: '',
      args: [],
    );
  }

  /// `Submission`
  String get emotion2Submission {
    return Intl.message(
      'Submission',
      name: 'emotion2Submission',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgAw {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgAw',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgCo {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgCo',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgDi {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgDi',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgLo {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgLo',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgNe {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgNe',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgOp {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3AgRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3AgRe',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AgSu {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AgSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3AwAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3AwAg',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3AwCo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3AwCo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3AwDi {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3AwDi',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3AwLo {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3AwLo',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3AwNe {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3AwNe',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3AwOp {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3AwOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3AwRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3AwRe',
      desc: '',
      args: [],
    );
  }

  /// `Encounter with something inspiring or humbling`
  String get emotion3AwSu {
    return Intl.message(
      'Encounter with something inspiring or humbling',
      name: 'emotion3AwSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3CoAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3CoAg',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3CoAw {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3CoAw',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3CoDi {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3CoDi',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3CoLo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3CoLo',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3CoNe {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3CoNe',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3CoOp {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3CoOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3CoRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3CoRe',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3CoSu {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3CoSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3DiAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3DiAg',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3DiAw {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3DiAw',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3DiCo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3DiCo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3DiLo {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3DiLo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3DiNe {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3DiNe',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3DiOp {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3DiOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3DiRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3DiRe',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3DiSu {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3DiSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3LoAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3LoAg',
      desc: '',
      args: [],
    );
  }

  /// `Encounter with something inspiring or humbling`
  String get emotion3LoAw {
    return Intl.message(
      'Encounter with something inspiring or humbling',
      name: 'emotion3LoAw',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3LoCo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3LoCo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3LoDi {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3LoDi',
      desc: '',
      args: [],
    );
  }

  /// `Person cools down and lost love to you`
  String get emotion3LoNe {
    return Intl.message(
      'Person cools down and lost love to you',
      name: 'emotion3LoNe',
      desc: '',
      args: [],
    );
  }

  /// `Positive outlook on situation or future`
  String get emotion3LoOp {
    return Intl.message(
      'Positive outlook on situation or future',
      name: 'emotion3LoOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3LoRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3LoRe',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3LoSu {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3LoSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3NeAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3NeAg',
      desc: '',
      args: [],
    );
  }

  /// `Encounter with something inspiring or humbling`
  String get emotion3NeAw {
    return Intl.message(
      'Encounter with something inspiring or humbling',
      name: 'emotion3NeAw',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3NeCo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3NeCo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3NeDi {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3NeDi',
      desc: '',
      args: [],
    );
  }

  /// `Person becomes more attached and interested`
  String get emotion3NeLo {
    return Intl.message(
      'Person becomes more attached and interested',
      name: 'emotion3NeLo',
      desc: '',
      args: [],
    );
  }

  /// `Positive outlook on situation or future`
  String get emotion3NeOp {
    return Intl.message(
      'Positive outlook on situation or future',
      name: 'emotion3NeOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3NeRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3NeRe',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3NeSu {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3NeSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3OpAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3OpAg',
      desc: '',
      args: [],
    );
  }

  /// `Encounter with something inspiring or humbling`
  String get emotion3OpAw {
    return Intl.message(
      'Encounter with something inspiring or humbling',
      name: 'emotion3OpAw',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3OpCo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3OpCo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3OpDi {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3OpDi',
      desc: '',
      args: [],
    );
  }

  /// `Positive outlook on situation or future`
  String get emotion3OpLo {
    return Intl.message(
      'Positive outlook on situation or future',
      name: 'emotion3OpLo',
      desc: '',
      args: [],
    );
  }

  /// `Positive outlook on situation or future`
  String get emotion3OpNe {
    return Intl.message(
      'Positive outlook on situation or future',
      name: 'emotion3OpNe',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3OpRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3OpRe',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3OpSu {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3OpSu',
      desc: '',
      args: [],
    );
  }

  /// `Desire to assert oneself or dominate`
  String get emotion3SuAg {
    return Intl.message(
      'Desire to assert oneself or dominate',
      name: 'emotion3SuAg',
      desc: '',
      args: [],
    );
  }

  /// `Encounter with something inspiring or humbling`
  String get emotion3SuAw {
    return Intl.message(
      'Encounter with something inspiring or humbling',
      name: 'emotion3SuAw',
      desc: '',
      args: [],
    );
  }

  /// `Negative opinion or disdain`
  String get emotion3SuCo {
    return Intl.message(
      'Negative opinion or disdain',
      name: 'emotion3SuCo',
      desc: '',
      args: [],
    );
  }

  /// `Recognition of something negative or disappointing`
  String get emotion3SuDi {
    return Intl.message(
      'Recognition of something negative or disappointing',
      name: 'emotion3SuDi',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3SuLo {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3SuLo',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3SuNe {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3SuNe',
      desc: '',
      args: [],
    );
  }

  /// `Realization of manipulation or injustice`
  String get emotion3SuOp {
    return Intl.message(
      'Realization of manipulation or injustice',
      name: 'emotion3SuOp',
      desc: '',
      args: [],
    );
  }

  /// `Recognition and regret of a mistake or wrongdoing`
  String get emotion3SuRe {
    return Intl.message(
      'Recognition and regret of a mistake or wrongdoing',
      name: 'emotion3SuRe',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get emotionAlert {
    return Intl.message(
      'Alert',
      name: 'emotionAlert',
      desc: '',
      args: [],
    );
  }

  /// `Emotion Analysis`
  String get emotionAnalysis {
    return Intl.message(
      'Emotion Analysis',
      name: 'emotionAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Analyze the Stream of Emotions`
  String get emotionAnalyzeStreamOfEmotions {
    return Intl.message(
      'Analyze the Stream of Emotions',
      name: 'emotionAnalyzeStreamOfEmotions',
      desc: '',
      args: [],
    );
  }

  /// `Anger`
  String get emotionAnger {
    return Intl.message(
      'Anger',
      name: 'emotionAnger',
      desc: '',
      args: [],
    );
  }

  /// `Bored`
  String get emotionBored {
    return Intl.message(
      'Bored',
      name: 'emotionBored',
      desc: '',
      args: [],
    );
  }

  /// `Calm`
  String get emotionCalm {
    return Intl.message(
      'Calm',
      name: 'emotionCalm',
      desc: '',
      args: [],
    );
  }

  /// `Contempt`
  String get emotionContempt {
    return Intl.message(
      'Contempt',
      name: 'emotionContempt',
      desc: '',
      args: [],
    );
  }

  /// `Contented`
  String get emotionContented {
    return Intl.message(
      'Contented',
      name: 'emotionContented',
      desc: '',
      args: [],
    );
  }

  /// `Depressed`
  String get emotionDepressed {
    return Intl.message(
      'Depressed',
      name: 'emotionDepressed',
      desc: '',
      args: [],
    );
  }

  /// `Emotions`
  String get emotionEmotions {
    return Intl.message(
      'Emotions',
      name: 'emotionEmotions',
      desc: '',
      args: [],
    );
  }

  /// `Enthusiastic`
  String get emotionEnthusiastic {
    return Intl.message(
      'Enthusiastic',
      name: 'emotionEnthusiastic',
      desc: '',
      args: [],
    );
  }

  /// `Excited`
  String get emotionExcited {
    return Intl.message(
      'Excited',
      name: 'emotionExcited',
      desc: '',
      args: [],
    );
  }

  /// `Happy`
  String get emotionHappy {
    return Intl.message(
      'Happy',
      name: 'emotionHappy',
      desc: '',
      args: [],
    );
  }

  /// `Joy`
  String get emotionJoy {
    return Intl.message(
      'Joy',
      name: 'emotionJoy',
      desc: '',
      args: [],
    );
  }

  /// `Nervous`
  String get emotionNervous {
    return Intl.message(
      'Nervous',
      name: 'emotionNervous',
      desc: '',
      args: [],
    );
  }

  /// `Relaxed`
  String get emotionRelaxed {
    return Intl.message(
      'Relaxed',
      name: 'emotionRelaxed',
      desc: '',
      args: [],
    );
  }

  /// `Sad`
  String get emotionSad {
    return Intl.message(
      'Sad',
      name: 'emotionSad',
      desc: '',
      args: [],
    );
  }

  /// `Sadness`
  String get emotionSadness {
    return Intl.message(
      'Sadness',
      name: 'emotionSadness',
      desc: '',
      args: [],
    );
  }

  /// `Serene`
  String get emotionSerene {
    return Intl.message(
      'Serene',
      name: 'emotionSerene',
      desc: '',
      args: [],
    );
  }

  /// `Sluggish`
  String get emotionSluggish {
    return Intl.message(
      'Sluggish',
      name: 'emotionSluggish',
      desc: '',
      args: [],
    );
  }

  /// `Speak freely in your own voice`
  String get emotionSpeakFreely {
    return Intl.message(
      'Speak freely in your own voice',
      name: 'emotionSpeakFreely',
      desc: '',
      args: [],
    );
  }

  /// `Stressed`
  String get emotionStressed {
    return Intl.message(
      'Stressed',
      name: 'emotionStressed',
      desc: '',
      args: [],
    );
  }

  /// `Tense`
  String get emotionTense {
    return Intl.message(
      'Tense',
      name: 'emotionTense',
      desc: '',
      args: [],
    );
  }

  /// `Upset`
  String get emotionUpset {
    return Intl.message(
      'Upset',
      name: 'emotionUpset',
      desc: '',
      args: [],
    );
  }

  /// `We'll analyze your tone for insights`
  String get emotionWeWillAnalyze {
    return Intl.message(
      'We\'ll analyze your tone for insights',
      name: 'emotionWeWillAnalyze',
      desc: '',
      args: [],
    );
  }

  /// `enter code`
  String get enterCode {
    return Intl.message(
      'enter code',
      name: 'enterCode',
      desc: '',
      args: [],
    );
  }

  /// `Clear Search history`
  String get feedClearSearch {
    return Intl.message(
      'Clear Search history',
      name: 'feedClearSearch',
      desc: '',
      args: [],
    );
  }

  /// `Do you wan to delete entire search history?`
  String get feedOperationDelete {
    return Intl.message(
      'Do you wan to delete entire search history?',
      name: 'feedOperationDelete',
      desc: '',
      args: [],
    );
  }

  /// `All authors`
  String get filterAllAuthors {
    return Intl.message(
      'All authors',
      name: 'filterAllAuthors',
      desc: '',
      args: [],
    );
  }

  /// `All source languages`
  String get filterAllSourceLanguages {
    return Intl.message(
      'All source languages',
      name: 'filterAllSourceLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get filterApply {
    return Intl.message(
      'Apply',
      name: 'filterApply',
      desc: '',
      args: [],
    );
  }

  /// `Apply filters`
  String get filterApplyFilters {
    return Intl.message(
      'Apply filters',
      name: 'filterApplyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get filterAuthor {
    return Intl.message(
      'Author',
      name: 'filterAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Author's name`
  String get filterAuthorsName {
    return Intl.message(
      'Author\'s name',
      name: 'filterAuthorsName',
      desc: '',
      args: [],
    );
  }

  /// `Filter By Author`
  String get filterByAuthor {
    return Intl.message(
      'Filter By Author',
      name: 'filterByAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get filterCategory {
    return Intl.message(
      'Category',
      name: 'filterCategory',
      desc: '',
      args: [],
    );
  }

  /// `Choose level`
  String get filterChooseLevel {
    return Intl.message(
      'Choose level',
      name: 'filterChooseLevel',
      desc: '',
      args: [],
    );
  }

  /// `Choose period`
  String get filterChoosePeriod {
    return Intl.message(
      'Choose period',
      name: 'filterChoosePeriod',
      desc: '',
      args: [],
    );
  }

  /// `Choose story mode`
  String get filterChooseStoryMode {
    return Intl.message(
      'Choose story mode',
      name: 'filterChooseStoryMode',
      desc: '',
      args: [],
    );
  }

  /// `Date from:`
  String get filterDateFrom {
    return Intl.message(
      'Date from:',
      name: 'filterDateFrom',
      desc: '',
      args: [],
    );
  }

  /// `Date to:`
  String get filterDateTo {
    return Intl.message(
      'Date to:',
      name: 'filterDateTo',
      desc: '',
      args: [],
    );
  }

  /// `Search by`
  String get filterFilters {
    return Intl.message(
      'Search by',
      name: 'filterFilters',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get filterLanguage {
    return Intl.message(
      'Language',
      name: 'filterLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get filterLevel {
    return Intl.message(
      'Level',
      name: 'filterLevel',
      desc: '',
      args: [],
    );
  }

  /// `Only in my source languages`
  String get filterMySourceLanguages {
    return Intl.message(
      'Only in my source languages',
      name: 'filterMySourceLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get filterPeriod {
    return Intl.message(
      'Period',
      name: 'filterPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Custom period`
  String get filterPeriodCustom {
    return Intl.message(
      'Custom period',
      name: 'filterPeriodCustom',
      desc: '',
      args: [],
    );
  }

  /// `Last 30 days`
  String get filterPeriodLast30 {
    return Intl.message(
      'Last 30 days',
      name: 'filterPeriodLast30',
      desc: '',
      args: [],
    );
  }

  /// `Last 7 days`
  String get filterPeriodLast7 {
    return Intl.message(
      'Last 7 days',
      name: 'filterPeriodLast7',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get filterPeriodToday {
    return Intl.message(
      'Today',
      name: 'filterPeriodToday',
      desc: '',
      args: [],
    );
  }

  /// `Whenever`
  String get filterPeriodWhenever {
    return Intl.message(
      'Whenever',
      name: 'filterPeriodWhenever',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get filterPeriodYesterday {
    return Intl.message(
      'Yesterday',
      name: 'filterPeriodYesterday',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get filterReset {
    return Intl.message(
      'Reset',
      name: 'filterReset',
      desc: '',
      args: [],
    );
  }

  /// `Select date`
  String get filterSelectDate {
    return Intl.message(
      'Select date',
      name: 'filterSelectDate',
      desc: '',
      args: [],
    );
  }

  /// `Select Languages`
  String get filterSelectLanguages {
    return Intl.message(
      'Select Languages',
      name: 'filterSelectLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Story mode`
  String get filterStoryMode {
    return Intl.message(
      'Story mode',
      name: 'filterStoryMode',
      desc: '',
      args: [],
    );
  }

  /// `Any`
  String get filterStoryModeAny {
    return Intl.message(
      'Any',
      name: 'filterStoryModeAny',
      desc: '',
      args: [],
    );
  }

  /// `Certification`
  String get filterStoryModeCertification {
    return Intl.message(
      'Certification',
      name: 'filterStoryModeCertification',
      desc: '',
      args: [],
    );
  }

  /// `Play by roles`
  String get filterStoryModeRoles {
    return Intl.message(
      'Play by roles',
      name: 'filterStoryModeRoles',
      desc: '',
      args: [],
    );
  }

  /// `Finish plan`
  String get finishPlan {
    return Intl.message(
      'Finish plan',
      name: 'finishPlan',
      desc: '',
      args: [],
    );
  }

  /// `This action will complete the current plan. Are you sure?`
  String get finishPlanConfirmation {
    return Intl.message(
      'This action will complete the current plan. Are you sure?',
      name: 'finishPlanConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get genericAll {
    return Intl.message(
      'All',
      name: 'genericAll',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing...`
  String get genericAnalyzing {
    return Intl.message(
      'Analyzing...',
      name: 'genericAnalyzing',
      desc: '',
      args: [],
    );
  }

  /// `This app needs microphone access`
  String get genericAppNeedsMicAccess {
    return Intl.message(
      'This app needs microphone access',
      name: 'genericAppNeedsMicAccess',
      desc: '',
      args: [],
    );
  }

  /// `Attempts`
  String get genericAttempts {
    return Intl.message(
      'Attempts',
      name: 'genericAttempts',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get genericAuthor {
    return Intl.message(
      'Author',
      name: 'genericAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Breath`
  String get genericBreath {
    return Intl.message(
      'Breath',
      name: 'genericBreath',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get genericCancel {
    return Intl.message(
      'Cancel',
      name: 'genericCancel',
      desc: '',
      args: [],
    );
  }

  /// `Channel`
  String get genericChannel {
    return Intl.message(
      'Channel',
      name: 'genericChannel',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get genericChat {
    return Intl.message(
      'Chat',
      name: 'genericChat',
      desc: '',
      args: [],
    );
  }

  /// `Clear Filters`
  String get genericClearFilters {
    return Intl.message(
      'Clear Filters',
      name: 'genericClearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get genericCompleted {
    return Intl.message(
      'Completed',
      name: 'genericCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get genericContinue {
    return Intl.message(
      'Continue',
      name: 'genericContinue',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get genericCopy {
    return Intl.message(
      'Copy',
      name: 'genericCopy',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get genericCreate {
    return Intl.message(
      'Create',
      name: 'genericCreate',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get genericDelete {
    return Intl.message(
      'Delete',
      name: 'genericDelete',
      desc: '',
      args: [],
    );
  }

  /// `Deny`
  String get genericDeny {
    return Intl.message(
      'Deny',
      name: 'genericDeny',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get genericDone {
    return Intl.message(
      'Done',
      name: 'genericDone',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get genericDownloading {
    return Intl.message(
      'Downloading...',
      name: 'genericDownloading',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get genericEdit {
    return Intl.message(
      'Edit',
      name: 'genericEdit',
      desc: '',
      args: [],
    );
  }

  /// `Editing`
  String get genericEditing {
    return Intl.message(
      'Editing',
      name: 'genericEditing',
      desc: '',
      args: [],
    );
  }

  /// `Emotion`
  String get genericEmotion {
    return Intl.message(
      'Emotion',
      name: 'genericEmotion',
      desc: '',
      args: [],
    );
  }

  /// `Energy`
  String get genericEnergy {
    return Intl.message(
      'Energy',
      name: 'genericEnergy',
      desc: '',
      args: [],
    );
  }

  /// `excellent`
  String get genericExcellentResult {
    return Intl.message(
      'excellent',
      name: 'genericExcellentResult',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get genericFailed {
    return Intl.message(
      'Error',
      name: 'genericFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get genericFailed1 {
    return Intl.message(
      'Failed',
      name: 'genericFailed1',
      desc: '',
      args: [],
    );
  }

  /// `fair`
  String get genericFairResult {
    return Intl.message(
      'fair',
      name: 'genericFairResult',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get genericFinish {
    return Intl.message(
      'Finish',
      name: 'genericFinish',
      desc: '',
      args: [],
    );
  }

  /// `good`
  String get genericGoodResult {
    return Intl.message(
      'good',
      name: 'genericGoodResult',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get genericHello {
    return Intl.message(
      'Hello',
      name: 'genericHello',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get genericLeave {
    return Intl.message(
      'Leave',
      name: 'genericLeave',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get genericListen {
    return Intl.message(
      'Listen',
      name: 'genericListen',
      desc: '',
      args: [],
    );
  }

  /// `Listen to my attempt`
  String get genericListenMyAttempt {
    return Intl.message(
      'Listen to my attempt',
      name: 'genericListenMyAttempt',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get genericMessage {
    return Intl.message(
      'Message',
      name: 'genericMessage',
      desc: '',
      args: [],
    );
  }

  /// `Microphone permission`
  String get genericMicPermission {
    return Intl.message(
      'Microphone permission',
      name: 'genericMicPermission',
      desc: '',
      args: [],
    );
  }

  /// `more`
  String get genericMore {
    return Intl.message(
      'more',
      name: 'genericMore',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get genericMy {
    return Intl.message(
      'My',
      name: 'genericMy',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get genericNext {
    return Intl.message(
      'Next',
      name: 'genericNext',
      desc: '',
      args: [],
    );
  }

  /// `Not found`
  String get genericNotFound {
    return Intl.message(
      'Not found',
      name: 'genericNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Not Shared`
  String get genericNotShared {
    return Intl.message(
      'Not Shared',
      name: 'genericNotShared',
      desc: '',
      args: [],
    );
  }

  /// `online`
  String get genericOnline {
    return Intl.message(
      'online',
      name: 'genericOnline',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get genericParticipants {
    return Intl.message(
      'Participants',
      name: 'genericParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Pass`
  String get genericPass {
    return Intl.message(
      'Pass',
      name: 'genericPass',
      desc: '',
      args: [],
    );
  }

  /// `Pitch`
  String get genericPitch {
    return Intl.message(
      'Pitch',
      name: 'genericPitch',
      desc: '',
      args: [],
    );
  }

  /// `Play attempt & reference together`
  String get genericPlayAttemptWRef {
    return Intl.message(
      'Play attempt & reference together',
      name: 'genericPlayAttemptWRef',
      desc: '',
      args: [],
    );
  }

  /// `Prepare...`
  String get genericPrepare {
    return Intl.message(
      'Prepare...',
      name: 'genericPrepare',
      desc: '',
      args: [],
    );
  }

  /// `Preparing...`
  String get genericPreparing {
    return Intl.message(
      'Preparing...',
      name: 'genericPreparing',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get genericPrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'genericPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Pronunciation`
  String get genericPronunciation {
    return Intl.message(
      'Pronunciation',
      name: 'genericPronunciation',
      desc: '',
      args: [],
    );
  }

  /// `Recently viewed`
  String get genericRecentlyViewed {
    return Intl.message(
      'Recently viewed',
      name: 'genericRecentlyViewed',
      desc: '',
      args: [],
    );
  }

  /// `recents`
  String get genericRecents {
    return Intl.message(
      'recents',
      name: 'genericRecents',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get genericRecord {
    return Intl.message(
      'Record',
      name: 'genericRecord',
      desc: '',
      args: [],
    );
  }

  /// `Recording...`
  String get genericRecording {
    return Intl.message(
      'Recording...',
      name: 'genericRecording',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get genericRepeat {
    return Intl.message(
      'Repeat',
      name: 'genericRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get genericReturn {
    return Intl.message(
      'Return',
      name: 'genericReturn',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get genericSave {
    return Intl.message(
      'Save',
      name: 'genericSave',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get genericSearch {
    return Intl.message(
      'Search',
      name: 'genericSearch',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get genericSettings {
    return Intl.message(
      'Settings',
      name: 'genericSettings',
      desc: '',
      args: [],
    );
  }

  /// `Shared with All Users`
  String get genericSharedWithAllUsers {
    return Intl.message(
      'Shared with All Users',
      name: 'genericSharedWithAllUsers',
      desc: '',
      args: [],
    );
  }

  /// `Shared with Author`
  String get genericSharedWithAuthor {
    return Intl.message(
      'Shared with Author',
      name: 'genericSharedWithAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get genericSkip {
    return Intl.message(
      'Skip',
      name: 'genericSkip',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get genericSomethingWrong {
    return Intl.message(
      'Something went wrong',
      name: 'genericSomethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `Start again`
  String get genericStartAgain {
    return Intl.message(
      'Start again',
      name: 'genericStartAgain',
      desc: '',
      args: [],
    );
  }

  /// `Started`
  String get genericStarted {
    return Intl.message(
      'Started',
      name: 'genericStarted',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get genericStop {
    return Intl.message(
      'Stop',
      name: 'genericStop',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Listen`
  String get genericTap2Listen {
    return Intl.message(
      'Tap to Listen',
      name: 'genericTap2Listen',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Record`
  String get genericTap2Record {
    return Intl.message(
      'Tap to Record',
      name: 'genericTap2Record',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get genericTermsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'genericTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Thinking`
  String get genericThinking {
    return Intl.message(
      'Thinking',
      name: 'genericThinking',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get genericTitle {
    return Intl.message(
      'Title',
      name: 'genericTitle',
      desc: '',
      args: [],
    );
  }

  /// `Total Results`
  String get genericTotalResults {
    return Intl.message(
      'Total Results',
      name: 'genericTotalResults',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get genericTryAgain {
    return Intl.message(
      'Try again',
      name: 'genericTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Try to change search criteria`
  String get genericTryChangeSearch {
    return Intl.message(
      'Try to change search criteria',
      name: 'genericTryChangeSearch',
      desc: '',
      args: [],
    );
  }

  /// `Type here ...`
  String get genericTypeHere {
    return Intl.message(
      'Type here ...',
      name: 'genericTypeHere',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get genericView {
    return Intl.message(
      'View',
      name: 'genericView',
      desc: '',
      args: [],
    );
  }

  /// `Voice Included`
  String get genericVoiceIncluded {
    return Intl.message(
      'Voice Included',
      name: 'genericVoiceIncluded',
      desc: '',
      args: [],
    );
  }

  /// `Was skipped`
  String get genericWasSkiped {
    return Intl.message(
      'Was skipped',
      name: 'genericWasSkiped',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get genericYou {
    return Intl.message(
      'You',
      name: 'genericYou',
      desc: '',
      args: [],
    );
  }

  /// `Go to channel`
  String get goToChannel {
    return Intl.message(
      'Go to channel',
      name: 'goToChannel',
      desc: '',
      args: [],
    );
  }

  /// `Guide`
  String get guide {
    return Intl.message(
      'Guide',
      name: 'guide',
      desc: '',
      args: [],
    );
  }

  /// `Learn by plan`
  String get guideByPlan {
    return Intl.message(
      'Learn by plan',
      name: 'guideByPlan',
      desc: '',
      args: [],
    );
  }

  /// `Learn by topic`
  String get guideByTopic {
    return Intl.message(
      'Learn by topic',
      name: 'guideByTopic',
      desc: '',
      args: [],
    );
  }

  /// `Choose a category to practice`
  String get guideChooseCategory {
    return Intl.message(
      'Choose a category to practice',
      name: 'guideChooseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Choose or continue your plan`
  String get guideChoosePlan {
    return Intl.message(
      'Choose or continue your plan',
      name: 'guideChoosePlan',
      desc: '',
      args: [],
    );
  }

  /// `Classrooms`
  String get guideClassrooms {
    return Intl.message(
      'Classrooms',
      name: 'guideClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `How Often Is the Content Updated?`
  String get howOftenIsTheContentUpdated {
    return Intl.message(
      'How Often Is the Content Updated?',
      name: 'howOftenIsTheContentUpdated',
      desc: '',
      args: [],
    );
  }

  /// `How to Learn a Language with Voccent`
  String get howToLearnALanguageWithVoccent {
    return Intl.message(
      'How to Learn a Language with Voccent',
      name: 'howToLearnALanguageWithVoccent',
      desc: '',
      args: [],
    );
  }

  /// `Improving Pronunciation`
  String get improvingPronunciation {
    return Intl.message(
      'Improving Pronunciation',
      name: 'improvingPronunciation',
      desc: '',
      args: [],
    );
  }

  /// `Interacting with Teachers`
  String get interactingWithTeachers {
    return Intl.message(
      'Interacting with Teachers',
      name: 'interactingWithTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Interacting with Users`
  String get interactingWithUsers {
    return Intl.message(
      'Interacting with Users',
      name: 'interactingWithUsers',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermediate',
      name: 'intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message(
      'Join',
      name: 'join',
      desc: '',
      args: [],
    );
  }

  /// `Acquire spoken languages`
  String get landingAcquire {
    return Intl.message(
      'Acquire spoken languages',
      name: 'landingAcquire',
      desc: '',
      args: [],
    );
  }

  /// `Keep going!`
  String get landingKeepGoing {
    return Intl.message(
      'Keep going!',
      name: 'landingKeepGoing',
      desc: '',
      args: [],
    );
  }

  /// `Let's go!`
  String get landingLetsgo {
    return Intl.message(
      'Let\'s go!',
      name: 'landingLetsgo',
      desc: '',
      args: [],
    );
  }

  /// `language level`
  String get languageLevel {
    return Intl.message(
      'language level',
      name: 'languageLevel',
      desc: '',
      args: [],
    );
  }

  /// `Languages Available`
  String get languagesAvailable {
    return Intl.message(
      'Languages Available',
      name: 'languagesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Languages to learn`
  String get languagesToLearn {
    return Intl.message(
      'Languages to learn',
      name: 'languagesToLearn',
      desc: '',
      args: [],
    );
  }

  /// `Languages you speak`
  String get languagesYouSpeak {
    return Intl.message(
      'Languages you speak',
      name: 'languagesYouSpeak',
      desc: '',
      args: [],
    );
  }

  /// `last month`
  String get lastMonth {
    return Intl.message(
      'last month',
      name: 'lastMonth',
      desc: '',
      args: [],
    );
  }

  /// `Last updated`
  String get lastUpdated {
    return Intl.message(
      'Last updated',
      name: 'lastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Avg result`
  String get lensCardAvgResult {
    return Intl.message(
      'Avg result',
      name: 'lensCardAvgResult',
      desc: '',
      args: [],
    );
  }

  /// `Choose category`
  String get lensChooseCategory {
    return Intl.message(
      'Choose category',
      name: 'lensChooseCategory',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get lensInProgress {
    return Intl.message(
      'In progress',
      name: 'lensInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Recommendations`
  String get lensRecommendations {
    return Intl.message(
      'Recommendations',
      name: 'lensRecommendations',
      desc: '',
      args: [],
    );
  }

  /// `Let's get started`
  String get letsGetStarted {
    return Intl.message(
      'Let\'s get started',
      name: 'letsGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get level {
    return Intl.message(
      'Level',
      name: 'level',
      desc: '',
      args: [],
    );
  }

  /// `List of completed plans`
  String get listOfCompletedPlans {
    return Intl.message(
      'List of completed plans',
      name: 'listOfCompletedPlans',
      desc: '',
      args: [],
    );
  }

  /// `Listen to #playlists`
  String get listenToPlaylists {
    return Intl.message(
      'Listen to #playlists',
      name: 'listenToPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Analyze`
  String get loginDemoAnalyze {
    return Intl.message(
      'Analyze',
      name: 'loginDemoAnalyze',
      desc: '',
      args: [],
    );
  }

  /// `Try more`
  String get loginDemoFail {
    return Intl.message(
      'Try more',
      name: 'loginDemoFail',
      desc: '',
      args: [],
    );
  }

  /// `How it works`
  String get loginDemoHowItWorks {
    return Intl.message(
      'How it works',
      name: 'loginDemoHowItWorks',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get loginDemoListen {
    return Intl.message(
      'Listen',
      name: 'loginDemoListen',
      desc: '',
      args: [],
    );
  }

  /// `Doing great`
  String get loginDemoPass {
    return Intl.message(
      'Doing great',
      name: 'loginDemoPass',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get loginDemoRepeat {
    return Intl.message(
      'Repeat',
      name: 'loginDemoRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with`
  String get loginDemoSignInWith {
    return Intl.message(
      'Sign in with',
      name: 'loginDemoSignInWith',
      desc: '',
      args: [],
    );
  }

  /// `Similarity Results`
  String get loginDemoSimilarityResults {
    return Intl.message(
      'Similarity Results',
      name: 'loginDemoSimilarityResults',
      desc: '',
      args: [],
    );
  }

  /// `Start practicing`
  String get loginDemoStartPracticing {
    return Intl.message(
      'Start practicing',
      name: 'loginDemoStartPracticing',
      desc: '',
      args: [],
    );
  }

  /// `Step`
  String get loginDemoStep {
    return Intl.message(
      'Step',
      name: 'loginDemoStep',
      desc: '',
      args: [],
    );
  }

  /// `Try a demo!`
  String get loginTryDemo {
    return Intl.message(
      'Try a demo!',
      name: 'loginTryDemo',
      desc: '',
      args: [],
    );
  }

  /// `Messenger`
  String get messenger {
    return Intl.message(
      'Messenger',
      name: 'messenger',
      desc: '',
      args: [],
    );
  }

  /// `minimum 5 characters`
  String get minimum5Characters {
    return Intl.message(
      'minimum 5 characters',
      name: 'minimum5Characters',
      desc: '',
      args: [],
    );
  }

  /// `Mixer will show you what to improve`
  String get mixerAbout1 {
    return Intl.message(
      'Mixer will show you what to improve',
      name: 'mixerAbout1',
      desc: '',
      args: [],
    );
  }

  /// `To receive the first list you need to practice everyday.`
  String get mixerAbout2 {
    return Intl.message(
      'To receive the first list you need to practice everyday.',
      name: 'mixerAbout2',
      desc: '',
      args: [],
    );
  }

  /// `You can modify your preferences in your profile settings.`
  String get modifyYourPreferences {
    return Intl.message(
      'You can modify your preferences in your profile settings.',
      name: 'modifyYourPreferences',
      desc: '',
      args: [],
    );
  }

  /// `My achievements`
  String get myAchievements {
    return Intl.message(
      'My achievements',
      name: 'myAchievements',
      desc: '',
      args: [],
    );
  }

  /// `My classrooms`
  String get myClassrooms {
    return Intl.message(
      'My classrooms',
      name: 'myClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `My languages`
  String get myLanguages {
    return Intl.message(
      'My languages',
      name: 'myLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Discovery`
  String get navItemDiscovery {
    return Intl.message(
      'Discovery',
      name: 'navItemDiscovery',
      desc: '',
      args: [],
    );
  }

  /// `Lens`
  String get navItemLens {
    return Intl.message(
      'Lens',
      name: 'navItemLens',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get navItemProfile {
    return Intl.message(
      'Profile',
      name: 'navItemProfile',
      desc: '',
      args: [],
    );
  }

  /// `You have new message`
  String get notificationNewChatMessage {
    return Intl.message(
      'You have new message',
      name: 'notificationNewChatMessage',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Organizations`
  String get organizations {
    return Intl.message(
      'Organizations',
      name: 'organizations',
      desc: '',
      args: [],
    );
  }

  /// `Other content Voccent`
  String get otherContentVoccent {
    return Intl.message(
      'Other content Voccent',
      name: 'otherContentVoccent',
      desc: '',
      args: [],
    );
  }

  /// `Pass the story`
  String get passTheStory {
    return Intl.message(
      'Pass the story',
      name: 'passTheStory',
      desc: '',
      args: [],
    );
  }

  /// `Pay settings`
  String get paySettings {
    return Intl.message(
      'Pay settings',
      name: 'paySettings',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get payments {
    return Intl.message(
      'Payments',
      name: 'payments',
      desc: '',
      args: [],
    );
  }

  /// `Campus name`
  String get planCampusName {
    return Intl.message(
      'Campus name',
      name: 'planCampusName',
      desc: '',
      args: [],
    );
  }

  /// `Element Count`
  String get planElementCount {
    return Intl.message(
      'Element Count',
      name: 'planElementCount',
      desc: '',
      args: [],
    );
  }

  /// `Plan Description`
  String get planPlanDescription {
    return Intl.message(
      'Plan Description',
      name: 'planPlanDescription',
      desc: '',
      args: [],
    );
  }

  /// `Plan name`
  String get planPlanName {
    return Intl.message(
      'Plan name',
      name: 'planPlanName',
      desc: '',
      args: [],
    );
  }

  /// `Play #Stories`
  String get playStories {
    return Intl.message(
      'Play #Stories',
      name: 'playStories',
      desc: '',
      args: [],
    );
  }

  /// `Autoplay mode`
  String get playlistAutoplay {
    return Intl.message(
      'Autoplay mode',
      name: 'playlistAutoplay',
      desc: '',
      args: [],
    );
  }

  /// `Go next`
  String get playlistGoNext {
    return Intl.message(
      'Go next',
      name: 'playlistGoNext',
      desc: '',
      args: [],
    );
  }

  /// `Playlist is empty`
  String get playlistIsEmpty {
    return Intl.message(
      'Playlist is empty',
      name: 'playlistIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get playlistLanguage {
    return Intl.message(
      'Language',
      name: 'playlistLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get playlistLevel {
    return Intl.message(
      'Level',
      name: 'playlistLevel',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get playlistListen {
    return Intl.message(
      'Listen',
      name: 'playlistListen',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get playlistLoading {
    return Intl.message(
      'Loading...',
      name: 'playlistLoading',
      desc: '',
      args: [],
    );
  }

  /// `Start Playlist`
  String get playlistStartPlaylist {
    return Intl.message(
      'Start Playlist',
      name: 'playlistStartPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Please select the authorization method`
  String get pleaseSelectAuthorizationMethod {
    return Intl.message(
      'Please select the authorization method',
      name: 'pleaseSelectAuthorizationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Please set your username`
  String get pleaseSetYourUsername {
    return Intl.message(
      'Please set your username',
      name: 'pleaseSetYourUsername',
      desc: '',
      args: [],
    );
  }

  /// `practice in #classrooms`
  String get practiceInClassrooms {
    return Intl.message(
      'practice in #classrooms',
      name: 'practiceInClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `#Practice phrases`
  String get practicePhrases {
    return Intl.message(
      '#Practice phrases',
      name: 'practicePhrases',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get preferencesDarkTheme {
    return Intl.message(
      'Dark theme',
      name: 'preferencesDarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get preferencesTheme {
    return Intl.message(
      'Theme',
      name: 'preferencesTheme',
      desc: '',
      args: [],
    );
  }

  /// `Now click on any Challenge on the list to start.`
  String get productTourChallenge {
    return Intl.message(
      'Now click on any Challenge on the list to start.',
      name: 'productTourChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Try a simple exercise or 'Challenge'`
  String get productTourDiscovery {
    return Intl.message(
      'Try a simple exercise or \'Challenge\'',
      name: 'productTourDiscovery',
      desc: '',
      args: [],
    );
  }

  /// `Try a simple exercise. Click on 'Challenges'`
  String get productTourDiscovery1 {
    return Intl.message(
      'Try a simple exercise. Click on \'Challenges\'',
      name: 'productTourDiscovery1',
      desc: '',
      args: [],
    );
  }

  /// `Click 'Listen' to hear the phrase. You can do it as many times as needed.`
  String get productTourListen {
    return Intl.message(
      'Click \'Listen\' to hear the phrase. You can do it as many times as needed.',
      name: 'productTourListen',
      desc: '',
      args: [],
    );
  }

  /// `Click 'Repeat' to repeat the phrase you've just heard. You can re-record your attempt for better results`
  String get productTourRepeat {
    return Intl.message(
      'Click \'Repeat\' to repeat the phrase you\'ve just heard. You can re-record your attempt for better results',
      name: 'productTourRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Click the result icon for details. `
  String get productTourResults {
    return Intl.message(
      'Click the result icon for details. ',
      name: 'productTourResults',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get productTourStep0 {
    return Intl.message(
      'Got it',
      name: 'productTourStep0',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get productTourStep1 {
    return Intl.message(
      'Got it',
      name: 'productTourStep1',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get productTourStep2 {
    return Intl.message(
      'Got it',
      name: 'productTourStep2',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get productTourStep3 {
    return Intl.message(
      'Got it',
      name: 'productTourStep3',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get productTourStep4 {
    return Intl.message(
      'Got it',
      name: 'productTourStep4',
      desc: '',
      args: [],
    );
  }

  /// `Click 'Try again' to re-record your attempt and get new results.`
  String get productTourTryAgain {
    return Intl.message(
      'Click \'Try again\' to re-record your attempt and get new results.',
      name: 'productTourTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Proficient`
  String get proficient {
    return Intl.message(
      'Proficient',
      name: 'proficient',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get profileFirstName {
    return Intl.message(
      'First Name',
      name: 'profileFirstName',
      desc: '',
      args: [],
    );
  }

  /// `I can speak`
  String get profileICanSpeak {
    return Intl.message(
      'I can speak',
      name: 'profileICanSpeak',
      desc: '',
      args: [],
    );
  }

  /// `I want to speak`
  String get profileIWantToSpeak {
    return Intl.message(
      'I want to speak',
      name: 'profileIWantToSpeak',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get profileLastName {
    return Intl.message(
      'Last Name',
      name: 'profileLastName',
      desc: '',
      args: [],
    );
  }

  /// `Profile settings`
  String get profileSettings {
    return Intl.message(
      'Profile settings',
      name: 'profileSettings',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get profileTabAbout {
    return Intl.message(
      'About',
      name: 'profileTabAbout',
      desc: '',
      args: [],
    );
  }

  /// `About the application`
  String get profileTabAboutApp {
    return Intl.message(
      'About the application',
      name: 'profileTabAboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Exit from your account`
  String get profileTabExit {
    return Intl.message(
      'Exit from your account',
      name: 'profileTabExit',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get profileTabLogout {
    return Intl.message(
      'Log Out',
      name: 'profileTabLogout',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get profileTabPreferences {
    return Intl.message(
      'Preferences',
      name: 'profileTabPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTabProfile {
    return Intl.message(
      'Profile',
      name: 'profileTabProfile',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get profileTabSubscriptions {
    return Intl.message(
      'Subscriptions',
      name: 'profileTabSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get profileUserName {
    return Intl.message(
      'Username',
      name: 'profileUserName',
      desc: '',
      args: [],
    );
  }

  /// `QR Code Scanner`
  String get qrCodeScanner {
    return Intl.message(
      'QR Code Scanner',
      name: 'qrCodeScanner',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get rawLanguage_ar_AR {
    return Intl.message(
      'Arabic',
      name: 'rawLanguage_ar_AR',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get rawLanguage_de_DE {
    return Intl.message(
      'German',
      name: 'rawLanguage_de_DE',
      desc: '',
      args: [],
    );
  }

  /// `English (US)`
  String get rawLanguage_en_US {
    return Intl.message(
      'English (US)',
      name: 'rawLanguage_en_US',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get rawLanguage_es_ES {
    return Intl.message(
      'Spanish',
      name: 'rawLanguage_es_ES',
      desc: '',
      args: [],
    );
  }

  /// `Persian`
  String get rawLanguage_fa_IR {
    return Intl.message(
      'Persian',
      name: 'rawLanguage_fa_IR',
      desc: '',
      args: [],
    );
  }

  /// `Finnish`
  String get rawLanguage_fi_FI {
    return Intl.message(
      'Finnish',
      name: 'rawLanguage_fi_FI',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get rawLanguage_fr_FR {
    return Intl.message(
      'French',
      name: 'rawLanguage_fr_FR',
      desc: '',
      args: [],
    );
  }

  /// `Hebrew`
  String get rawLanguage_he_IL {
    return Intl.message(
      'Hebrew',
      name: 'rawLanguage_he_IL',
      desc: '',
      args: [],
    );
  }

  /// `Hindi`
  String get rawLanguage_hi_IN {
    return Intl.message(
      'Hindi',
      name: 'rawLanguage_hi_IN',
      desc: '',
      args: [],
    );
  }

  /// `Armenian`
  String get rawLanguage_hy_AM {
    return Intl.message(
      'Armenian',
      name: 'rawLanguage_hy_AM',
      desc: '',
      args: [],
    );
  }

  /// `Indonesian`
  String get rawLanguage_id_ID {
    return Intl.message(
      'Indonesian',
      name: 'rawLanguage_id_ID',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get rawLanguage_it_IT {
    return Intl.message(
      'Italian',
      name: 'rawLanguage_it_IT',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get rawLanguage_ja_JP {
    return Intl.message(
      'Japanese',
      name: 'rawLanguage_ja_JP',
      desc: '',
      args: [],
    );
  }

  /// `Georgian`
  String get rawLanguage_ka_GE {
    return Intl.message(
      'Georgian',
      name: 'rawLanguage_ka_GE',
      desc: '',
      args: [],
    );
  }

  /// `Kikuyu`
  String get rawLanguage_kik_KI {
    return Intl.message(
      'Kikuyu',
      name: 'rawLanguage_kik_KI',
      desc: '',
      args: [],
    );
  }

  /// `Kazakh`
  String get rawLanguage_kk_KZ {
    return Intl.message(
      'Kazakh',
      name: 'rawLanguage_kk_KZ',
      desc: '',
      args: [],
    );
  }

  /// `Korean`
  String get rawLanguage_ko_KR {
    return Intl.message(
      'Korean',
      name: 'rawLanguage_ko_KR',
      desc: '',
      args: [],
    );
  }

  /// `Latin`
  String get rawLanguage_la_LA {
    return Intl.message(
      'Latin',
      name: 'rawLanguage_la_LA',
      desc: '',
      args: [],
    );
  }

  /// `Ganda`
  String get rawLanguage_lug_LG {
    return Intl.message(
      'Ganda',
      name: 'rawLanguage_lug_LG',
      desc: '',
      args: [],
    );
  }

  /// `Mandinka`
  String get rawLanguage_mnk_GN {
    return Intl.message(
      'Mandinka',
      name: 'rawLanguage_mnk_GN',
      desc: '',
      args: [],
    );
  }

  /// `Norwegian`
  String get rawLanguage_no_NO {
    return Intl.message(
      'Norwegian',
      name: 'rawLanguage_no_NO',
      desc: '',
      args: [],
    );
  }

  /// `Polish`
  String get rawLanguage_pl_PL {
    return Intl.message(
      'Polish',
      name: 'rawLanguage_pl_PL',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get rawLanguage_pt_BR {
    return Intl.message(
      'Portuguese',
      name: 'rawLanguage_pt_BR',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get rawLanguage_ru_RU {
    return Intl.message(
      'Russian',
      name: 'rawLanguage_ru_RU',
      desc: '',
      args: [],
    );
  }

  /// `Swedish`
  String get rawLanguage_sv_SV {
    return Intl.message(
      'Swedish',
      name: 'rawLanguage_sv_SV',
      desc: '',
      args: [],
    );
  }

  /// `Swahili`
  String get rawLanguage_swa_SW {
    return Intl.message(
      'Swahili',
      name: 'rawLanguage_swa_SW',
      desc: '',
      args: [],
    );
  }

  /// `Thai`
  String get rawLanguage_th_TH {
    return Intl.message(
      'Thai',
      name: 'rawLanguage_th_TH',
      desc: '',
      args: [],
    );
  }

  /// `Turkish`
  String get rawLanguage_tr_TR {
    return Intl.message(
      'Turkish',
      name: 'rawLanguage_tr_TR',
      desc: '',
      args: [],
    );
  }

  /// `Tatar`
  String get rawLanguage_tt_RU {
    return Intl.message(
      'Tatar',
      name: 'rawLanguage_tt_RU',
      desc: '',
      args: [],
    );
  }

  /// `Ukrainian`
  String get rawLanguage_uk_UA {
    return Intl.message(
      'Ukrainian',
      name: 'rawLanguage_uk_UA',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Chinese`
  String get rawLanguage_zh_CN {
    return Intl.message(
      'Simplified Chinese',
      name: 'rawLanguage_zh_CN',
      desc: '',
      args: [],
    );
  }

  /// `Traditional Chinese`
  String get rawLanguage_zh_TW {
    return Intl.message(
      'Traditional Chinese',
      name: 'rawLanguage_zh_TW',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message(
      'Reject',
      name: 'reject',
      desc: '',
      args: [],
    );
  }

  /// `#repeat don't forget`
  String get repeatDoNotForget {
    return Intl.message(
      '#repeat don\'t forget',
      name: 'repeatDoNotForget',
      desc: '',
      args: [],
    );
  }

  /// `Please note that this operation will change the application's local language. For the application to function properly, we recommend restarting it.`
  String get restart {
    return Intl.message(
      'Please note that this operation will change the application\'s local language. For the application to function properly, we recommend restarting it.',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to start this plan over?`
  String get restartPlan {
    return Intl.message(
      'Would you like to start this plan over?',
      name: 'restartPlan',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR-Code`
  String get scanQRCode {
    return Intl.message(
      'Scan QR-Code',
      name: 'scanQRCode',
      desc: '',
      args: [],
    );
  }

  /// `Challenges`
  String get searchTabChallenges {
    return Intl.message(
      'Challenges',
      name: 'searchTabChallenges',
      desc: '',
      args: [],
    );
  }

  /// `Channels`
  String get searchTabChannels {
    return Intl.message(
      'Channels',
      name: 'searchTabChannels',
      desc: '',
      args: [],
    );
  }

  /// `Feed`
  String get searchTabFeed {
    return Intl.message(
      'Feed',
      name: 'searchTabFeed',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get searchTabPlaylists {
    return Intl.message(
      'Playlists',
      name: 'searchTabPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Stories`
  String get searchTabStories {
    return Intl.message(
      'Stories',
      name: 'searchTabStories',
      desc: '',
      args: [],
    );
  }

  /// ` Kindly select the languages you are already proficient in and wish to explore.`
  String get selectTheLanguages {
    return Intl.message(
      ' Kindly select the languages you are already proficient in and wish to explore.',
      name: 'selectTheLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Smart #Recommendations`
  String get smartRecommendations {
    return Intl.message(
      'Smart #Recommendations',
      name: 'smartRecommendations',
      desc: '',
      args: [],
    );
  }

  /// `Speak`
  String get speak {
    return Intl.message(
      'Speak',
      name: 'speak',
      desc: '',
      args: [],
    );
  }

  /// `Start new`
  String get startNew {
    return Intl.message(
      'Start new',
      name: 'startNew',
      desc: '',
      args: [],
    );
  }

  /// `Start new story`
  String get startNewStory {
    return Intl.message(
      'Start new story',
      name: 'startNewStory',
      desc: '',
      args: [],
    );
  }

  /// `Start over?`
  String get startOver {
    return Intl.message(
      'Start over?',
      name: 'startOver',
      desc: '',
      args: [],
    );
  }

  /// `Start talking for emotional analysis`
  String get startTalking {
    return Intl.message(
      'Start talking for emotional analysis',
      name: 'startTalking',
      desc: '',
      args: [],
    );
  }

  /// `Average`
  String get storyAverage {
    return Intl.message(
      'Average',
      name: 'storyAverage',
      desc: '',
      args: [],
    );
  }

  /// `Choose characters to play`
  String get storyChooseCharacters {
    return Intl.message(
      'Choose characters to play',
      name: 'storyChooseCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Choose next act`
  String get storyChooseNextAct {
    return Intl.message(
      'Choose next act',
      name: 'storyChooseNextAct',
      desc: '',
      args: [],
    );
  }

  /// `Compare result`
  String get storyCompareResult {
    return Intl.message(
      'Compare result',
      name: 'storyCompareResult',
      desc: '',
      args: [],
    );
  }

  /// `Invite others (type username or email)`
  String get storyInvite {
    return Intl.message(
      'Invite others (type username or email)',
      name: 'storyInvite',
      desc: '',
      args: [],
    );
  }

  /// `Invite players`
  String get storyInvitePlayers {
    return Intl.message(
      'Invite players',
      name: 'storyInvitePlayers',
      desc: '',
      args: [],
    );
  }

  /// `Listen to other players attempt`
  String get storyListen2OtherPlayersAttempt {
    return Intl.message(
      'Listen to other players attempt',
      name: 'storyListen2OtherPlayersAttempt',
      desc: '',
      args: [],
    );
  }

  /// `Listen to your attempt`
  String get storyListenToYourAttempt {
    return Intl.message(
      'Listen to your attempt',
      name: 'storyListenToYourAttempt',
      desc: '',
      args: [],
    );
  }

  /// `Certification`
  String get storyModeCertification {
    return Intl.message(
      'Certification',
      name: 'storyModeCertification',
      desc: '',
      args: [],
    );
  }

  /// `The current story does not have any mode`
  String get storyModeNoAnyMode {
    return Intl.message(
      'The current story does not have any mode',
      name: 'storyModeNoAnyMode',
      desc: '',
      args: [],
    );
  }

  /// `Play by roles`
  String get storyModePlayByRoles {
    return Intl.message(
      'Play by roles',
      name: 'storyModePlayByRoles',
      desc: '',
      args: [],
    );
  }

  /// `Repeat after audio`
  String get storyRepeatAfterAudio {
    return Intl.message(
      'Repeat after audio',
      name: 'storyRepeatAfterAudio',
      desc: '',
      args: [],
    );
  }

  /// `Story result`
  String get storyResult {
    return Intl.message(
      'Story result',
      name: 'storyResult',
      desc: '',
      args: [],
    );
  }

  /// `Share link`
  String get storyShareLink {
    return Intl.message(
      'Share link',
      name: 'storyShareLink',
      desc: '',
      args: [],
    );
  }

  /// `Share link with users`
  String get storyShareLinkWithUsers {
    return Intl.message(
      'Share link with users',
      name: 'storyShareLinkWithUsers',
      desc: '',
      args: [],
    );
  }

  /// `Start story`
  String get storyStart {
    return Intl.message(
      'Start story',
      name: 'storyStart',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for other players turn`
  String get storyWaitingForOtherPlayersTurn {
    return Intl.message(
      'Waiting for other players turn',
      name: 'storyWaitingForOtherPlayersTurn',
      desc: '',
      args: [],
    );
  }

  /// `Your turn to speak`
  String get storyYourTurn {
    return Intl.message(
      'Your turn to speak',
      name: 'storyYourTurn',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe to`
  String get subscribeTo {
    return Intl.message(
      'Subscribe to',
      name: 'subscribeTo',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe to #Channels`
  String get subscribeToChannels {
    return Intl.message(
      'Subscribe to #Channels',
      name: 'subscribeToChannels',
      desc: '',
      args: [],
    );
  }

  /// `Current. Thank you!`
  String get subscriptionActive {
    return Intl.message(
      'Current. Thank you!',
      name: 'subscriptionActive',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get subscriptionAdvanced {
    return Intl.message(
      'Advanced',
      name: 'subscriptionAdvanced',
      desc: '',
      args: [],
    );
  }

  /// `Advanced plan`
  String get subscriptionAdvancedPlan {
    return Intl.message(
      'Advanced plan',
      name: 'subscriptionAdvancedPlan',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get subscriptionBasic {
    return Intl.message(
      'Basic',
      name: 'subscriptionBasic',
      desc: '',
      args: [],
    );
  }

  /// `Basic plan`
  String get subscriptionBasicPlan {
    return Intl.message(
      'Basic plan',
      name: 'subscriptionBasicPlan',
      desc: '',
      args: [],
    );
  }

  /// `You can cancel within 7 days`
  String get subscriptionDescription7DaysGrace {
    return Intl.message(
      'You can cancel within 7 days',
      name: 'subscriptionDescription7DaysGrace',
      desc: '',
      args: [],
    );
  }

  /// `Join private Classrooms, collaborate with favorite teachers and content authors, share with friends and families.`
  String get subscriptionDescriptionAdvancedPlan {
    return Intl.message(
      'Join private Classrooms, collaborate with favorite teachers and content authors, share with friends and families.',
      name: 'subscriptionDescriptionAdvancedPlan',
      desc: '',
      args: [],
    );
  }

  /// `All the content available, limited amount of Classrooms, fewer attempts per day.`
  String get subscriptionDescriptionBasicPlan {
    return Intl.message(
      'All the content available, limited amount of Classrooms, fewer attempts per day.',
      name: 'subscriptionDescriptionBasicPlan',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy full access for 400 days - completely free.`
  String get subscriptionDescriptionFreePlan1 {
    return Intl.message(
      'Enjoy full access for 400 days - completely free.',
      name: 'subscriptionDescriptionFreePlan1',
      desc: '',
      args: [],
    );
  }

  /// `No trial period, no payment required.`
  String get subscriptionDescriptionFreePlan2 {
    return Intl.message(
      'No trial period, no payment required.',
      name: 'subscriptionDescriptionFreePlan2',
      desc: '',
      args: [],
    );
  }

  /// `After 400 days, you have the option to continue with unlimited access by activating a subscription plan.`
  String get subscriptionDescriptionFreePlan3 {
    return Intl.message(
      'After 400 days, you have the option to continue with unlimited access by activating a subscription plan.',
      name: 'subscriptionDescriptionFreePlan3',
      desc: '',
      args: [],
    );
  }

  /// `Choose from our Basic, Standard, or Advanced plans to keep learning without limits.`
  String get subscriptionDescriptionFreePlan4 {
    return Intl.message(
      'Choose from our Basic, Standard, or Advanced plans to keep learning without limits.',
      name: 'subscriptionDescriptionFreePlan4',
      desc: '',
      args: [],
    );
  }

  /// `Until then, enjoy up to 1000 attempts per month and access to 3 stories every day - free of charge.`
  String get subscriptionDescriptionFreePlan5 {
    return Intl.message(
      'Until then, enjoy up to 1000 attempts per month and access to 3 stories every day - free of charge.',
      name: 'subscriptionDescriptionFreePlan5',
      desc: '',
      args: [],
    );
  }

  /// `More Classrooms, more attempts, and access to a wider range of features.`
  String get subscriptionDescriptionStandardPlan {
    return Intl.message(
      'More Classrooms, more attempts, and access to a wider range of features.',
      name: 'subscriptionDescriptionStandardPlan',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get subscriptionFree {
    return Intl.message(
      'Free',
      name: 'subscriptionFree',
      desc: '',
      args: [],
    );
  }

  /// `Free plan`
  String get subscriptionFreePlan {
    return Intl.message(
      'Free plan',
      name: 'subscriptionFreePlan',
      desc: '',
      args: [],
    );
  }

  /// ` /month`
  String get subscriptionMonth {
    return Intl.message(
      ' /month',
      name: 'subscriptionMonth',
      desc: '',
      args: [],
    );
  }

  /// `Standard`
  String get subscriptionStandard {
    return Intl.message(
      'Standard',
      name: 'subscriptionStandard',
      desc: '',
      args: [],
    );
  }

  /// `Standard plan`
  String get subscriptionStandardPlan {
    return Intl.message(
      'Standard plan',
      name: 'subscriptionStandardPlan',
      desc: '',
      args: [],
    );
  }

  /// `Activate`
  String get subscriptionSwitch {
    return Intl.message(
      'Activate',
      name: 'subscriptionSwitch',
      desc: '',
      args: [],
    );
  }

  /// `tap for details`
  String get tapForDetails {
    return Intl.message(
      'tap for details',
      name: 'tapForDetails',
      desc: '',
      args: [],
    );
  }

  /// `Tap to translate`
  String get tapToTranslate {
    return Intl.message(
      'Tap to translate',
      name: 'tapToTranslate',
      desc: '',
      args: [],
    );
  }

  /// `The Common European Framework of Reference for Languages (CEFR) is an international standard for describing language ability. It describes language ability on a six-point scale, from A1 for beginners, up to C2 for those who have mastered a language.`
  String get theCommonEuropeanFrameworkOfReference {
    return Intl.message(
      'The Common European Framework of Reference for Languages (CEFR) is an international standard for describing language ability. It describes language ability on a six-point scale, from A1 for beginners, up to C2 for those who have mastered a language.',
      name: 'theCommonEuropeanFrameworkOfReference',
      desc: '',
      args: [],
    );
  }

  /// `The Role of Stories and Practicing phrases`
  String get theRoleOfStoriesAndChallenges {
    return Intl.message(
      'The Role of Stories and Practicing phrases',
      name: 'theRoleOfStoriesAndChallenges',
      desc: '',
      args: [],
    );
  }

  /// `You are currently not a member of any organization.\nGet invited or create your own organization.`
  String get thereAreNoOrganizations {
    return Intl.message(
      'You are currently not a member of any organization.\nGet invited or create your own organization.',
      name: 'thereAreNoOrganizations',
      desc: '',
      args: [],
    );
  }

  /// `this username is already taken or not available`
  String get thisUsernameIsNotAvailable {
    return Intl.message(
      'this username is already taken or not available',
      name: 'thisUsernameIsNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Time LEft:`
  String get timeLEft {
    return Intl.message(
      'Time LEft:',
      name: 'timeLEft',
      desc: '',
      args: [],
    );
  }

  /// `To open the current plan, go through the previous one`
  String get toOpenCurrentPlanPreviousOne {
    return Intl.message(
      'To open the current plan, go through the previous one',
      name: 'toOpenCurrentPlanPreviousOne',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message(
      'Translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Try another code`
  String get tryAnotherCode {
    return Intl.message(
      'Try another code',
      name: 'tryAnotherCode',
      desc: '',
      args: [],
    );
  }

  /// `Upper Intermediate`
  String get upperIntermediate {
    return Intl.message(
      'Upper Intermediate',
      name: 'upperIntermediate',
      desc: '',
      args: [],
    );
  }

  /// `Users' messages`
  String get usersNotifications {
    return Intl.message(
      'Users\' messages',
      name: 'usersNotifications',
      desc: '',
      args: [],
    );
  }

  /// `valid characters`
  String get validCharacters {
    return Intl.message(
      'valid characters',
      name: 'validCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Wait`
  String get wait {
    return Intl.message(
      'Wait',
      name: 'wait',
      desc: '',
      args: [],
    );
  }

  /// `Wait for {playerName}'s turn`
  String waitPlayerTurn(Object playerName) {
    return Intl.message(
      'Wait for $playerName\'s turn',
      name: 'waitPlayerTurn',
      desc: '',
      args: [playerName],
    );
  }

  /// `You are invited to join the organization`
  String get weInviteUouJoinOrganization {
    return Intl.message(
      'You are invited to join the organization',
      name: 'weInviteUouJoinOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcomeTo {
    return Intl.message(
      'Welcome to',
      name: 'welcomeTo',
      desc: '',
      args: [],
    );
  }

  /// `What is Voccent?`
  String get whatIsVoccent {
    return Intl.message(
      'What is Voccent?',
      name: 'whatIsVoccent',
      desc: '',
      args: [],
    );
  }

  /// `You are already in the organization`
  String get youAreAlreadyInOrganization {
    return Intl.message(
      'You are already in the organization',
      name: 'youAreAlreadyInOrganization',
      desc: '',
      args: [],
    );
  }

  /// `You are currently a member of organization`
  String get youAreOrganization {
    return Intl.message(
      'You are currently a member of organization',
      name: 'youAreOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Your attempt`
  String get yourAttempt {
    return Intl.message(
      'Your attempt',
      name: 'yourAttempt',
      desc: '',
      args: [],
    );
  }

  /// `The classes you are part of`
  String get yourClassrooms {
    return Intl.message(
      'The classes you are part of',
      name: 'yourClassrooms',
      desc: '',
      args: [],
    );
  }

  /// `You haven't given any likes yet`
  String get yourHaveNotGivenLikes {
    return Intl.message(
      'You haven\'t given any likes yet',
      name: 'yourHaveNotGivenLikes',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hy'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ka'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'la'),
      Locale.fromSubtags(languageCode: 'no'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'tt'),
      Locale.fromSubtags(languageCode: 'uk'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
