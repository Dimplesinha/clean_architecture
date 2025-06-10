class EnumType {
  static int forgotPassword = 1;
  static int signUpPassword = 2;
  static int resendEmail = 4;
  static int changeEmailOtpVerify = 5;
  static int addSubAccountOtpVerify = 6;
  static int personalAccountType = 1;
  static int businessAccountType = 2;
  static int worldWide = 1;
  static int countryWide = 2;
  static int sale = 1;
  static int rent = 2;
  static int lease = 3;
  static int perDay = 2;
  static int myItemRating = 1;
  static int myRatings = 2;
  static String descOrder = 'DESC';
}

enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get stringValue {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
}

enum CurrentFileType { image, video, other }

enum CurrentFileOrigin { local, network }

enum MediaType {
  text,
  image,
  audio,
  video,
  document,
}

extension MediaTypeExtension on MediaType {
  int get value {
    switch (this) {
      case MediaType.text:
        return 1;
      case MediaType.image:
        return 2;
      case MediaType.audio:
        return 3;
      case MediaType.video:
        return 4;
      case MediaType.document:
        return 5;
    }
  }

  static MediaType fromValue(int value) {
    switch (value) {
      case 1:
        return MediaType.text;
      case 2:
        return MediaType.image;
      case 3:
        return MediaType.audio;
      case 4:
        return MediaType.video;
      case 5:
        return MediaType.document;
      default:
        throw Exception('Unknown MediaType value: $value');
    }
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

extension MessageStatusExtension on MessageStatus {
  int get value {
    switch (this) {
      case MessageStatus.sent:
        return 1;
      case MessageStatus.delivered:
        return 2;
      case MessageStatus.read:
        return 3;
    }
  }

  static MessageStatus fromValue(int value) {
    switch (value) {
      case 1:
        return MessageStatus.sent;
      case 2:
        return MessageStatus.delivered;
      case 3:
        return MessageStatus.read;
      default:
        throw Exception('Unknown MessageStatus value: $value');
    }
  }
}

enum FormFieldType {
  // 🔹 Master Fields
  contactEmail('contactEmail'),
  homePageLogo('homePageLogo'),
  listingDescription('listingDescription'),
  listingTitle('listingTitle'),
  location('location'),
  multipleImageVideo('multipleImageVideo'),
  phoneNumber('phoneNumber'),
  phoneCountryCode('phoneCountryCode'),
  phoneDialCode('phoneDialCode'),
  streetAddress('streetAddress'),
  visibility('visibility'),
  businessWebsite('businessWebsite'),
  contactName('contactName'),
  listingDateRange('listingDateRange'),
  listingExpiryDate('listingExpiryDate'),

  // 🔹 Default Fields
  checkbox('checkbox'),
  currency('currency'),
  date('date'),
  dateRange('dateRange'),
  duration('duration'),
  email('email'),
  file('file'),
  number('number'),
  price('price'),
  priceRange('priceRange'),
  radio('radio'),
  select('select'),
  tagInput('tagInput'),
  text('text'),
  textarea('textArea'),
  time('time'),
  timeRange('timeRange'),
  website('website'),
  hidden('hidden');

  final String value;
  const FormFieldType(this.value);
}

enum RecordStatus {
  active(1),
  waitingForApproval(5),
  draft(4),
  disapproved(6);

  final int value;
  const RecordStatus(this.value);
}
enum RecordStatusString {
  active('Active'),
  waitingForApproval('WaitingForApproval'),
  draft('Draft'),
  disapproved('Disapproved');

  final String value;
  const RecordStatusString(this.value);
}

enum DynamicSelectDropdownBindType {
  manual(1),
  master(2),
  inheritListing(3);

  final int value;
  const DynamicSelectDropdownBindType(this.value);
}

enum AccountType {
  personal('1'),
  business('2');

  final String value;
  const AccountType(this.value);
}
enum AppPlatform {
  android(3),
  ios(2);
  final int value;
  const AppPlatform(this.value);
}

