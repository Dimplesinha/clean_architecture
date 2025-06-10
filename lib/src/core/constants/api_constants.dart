library api_constants;

class ApiConstant {
  static String baseUri = 'https://workapp-2.azurewebsites.net';
  static String baseUriDynamic = 'https://workappdynamic-2-web.azurewebsites.net';
  static String baseUrl = '$baseUri/api/';

  //For contact list
  static String mockBaseUrl = 'http://demo2676340.mockable.io/api/';
  static String mockContactList = 'user/contact-list';

  static String login = 'user/login';
  static String signUp = 'user';
  static String getUserId = 'user/';
  static String changePassword = 'user/password';
  static String forgetPassword = 'user/otp/send/';
  static String otpVerify = 'user/otp/verify';
  static String resetPassword = 'user/password/reset';
  static String resendEmailOtp = 'user/otppassword/resend';
  static String resendChangeEmailOtp = 'user/otppassword/resend';
  static String resendSubAccountOtp = 'user/otppassword/resend';
  static String emailChange = 'user/emailchange';
  static String emailChangeOtp = 'user/emailchange/otp/resend';
  static String emailChangeOtpVerify = 'user/emailchange/otp/verify';
  static String successStr = 'success';
  static String emptyStr = '';
  static String profileBasicDetailsStr = 'profile/basicDetails';
  static String allListingStr = 'listing/all';
  static String countryAllListingStr = 'country/all';
  static String passwordSet = 'user/password/set';
  static String accountType = 'user/accounttype';
  static String myListingWithPagination = 'listing/mylisting/dynamicpaginated';
  static String faqAll = 'faq/all';

  static String myListingBookmarkWithPagination = 'listing/dynamic/bookmark/paginated';
  static String myListingBookmarkUnBookmark = 'listing/bookmark';
  static String myListingLikeUnlike = 'listing/postlike';
  static String imageUpload = 'user/update-profile-image';
  static String searchListing = 'home/dynamic/listing/keyword/paginated/elastic';
  static String spamItem = 'spam';
  static String spamUser = 'user-spam';
  static String deleteAccount = 'user/';

  ///Subscription API Constants
  static String subscriberHistory = 'subscriber/user/{userID}/history';
  static String subscriberPlan = 'subscription/paginated';
  static String subAccountOtpVerify = 'user/subaccount/otp/verify';
  static String noSubscriptionAccounts = 'subscription/subaccounts/without-subscription';
  static String activeListingCountOfSubscriber = 'subscription/dynamic/{account1}/switchaccount/{account2}/listingcount';
  static String mySubscription = 'subscription/user/{account1}/mysubscription';
  static String subscriptionActiveListingList = 'subscription/dynamic/switchaccount/{switchAccount}/activelisting/list';
  static String transferSubscriptionPlan = 'subscription/dynamic/{subscriptionId}/switchaccount/{switchUserId}/confirmlisting';
  static String buySubscriptionPlan = 'subscriber';
  static String isUpgradable = 'subscriber/upgradable';
  static String cancelSubscription = 'subscriber/cancel';

  ///Apply Promo Code
  static String promoCodeList = 'promo-code/subscription/mypromocodelist';
  static String promoCodeValidate = 'promo-code/subscription/validate';
  static String promoCodeData = 'subscriber/details/';

  /// Google Location API Constants
  static String googleApiBaseUrl = 'https://maps.googleapis.com/maps/api/';
  static String googleGeocodeAPIBaseURL = 'https://maps.googleapis.com/maps/api/';
  static String placesApiStr = 'place/autocomplete/json';
  static String geocodeApiStr = 'geocode/json';
  static String placesApiKey = 'AIzaSyDe9vWCE5th5pe8zvQZHGJ9SbLIpBV0-QA';

  ///Add Business Listing Forms
  static String insertBusinessStr = 'business-profile';
  static String updateBusinessStr = 'business-profile/';
  static String getBusinessProfileDetails = 'business-profile/';
  static String allCategoryBusinessList = 'business-profile/all/category/';

  ///Contact-Us Api
  static String contactUsApi = 'contact-us';

  ///Advance search api
  static String advanceSearchApi = 'home/dynamic/advancesearch/paginated';

  ///Link-Account Api
  static String linkAccount = '${getUserId}link-account';

  static String allCategoryCommunityList = 'community/all';

  ///currencyListApi
  static String currencyListApi = 'currency';

  ///Delete my listing item
  static String deleteSearchStr = 'home/search';
  static String getListingDetails = 'response/dynamic/';
  static String deleteWaitingListingDetails = 'response/{Id}/{ishistory}';

  /// Add Listing
  static String addListingApi = 'response/dynamic-listing';

  ///My Listing Status
  static String listingBoost = 'common/response-boost/';
  static String listingStatus = 'common/dynamic/listing-status/';
  static String listingCount = 'listing/dynamic/related/listingcount';
  static String listingMyRating = 'listing/dynamic/myrating';
  static String listingEditMyRating = 'listing/rating/';
  static String ratingList = 'listing/ratinglist';
  static String reviewList = 'listing/reviewlist';
  static String addEditrating = 'listing/dynamic/rating';
  static String relatedItemList = 'listing/dynamic/relateditem/paginated';

  ///Connection String
  static String containerString = 'workappmedia';
  static String containerLogoString = 'workapplistinglogo';
  static String containerLogoThumbString = 'workapplistinglogothumb';

  static String imageBaseUrl = '';

  ///Home Screen
  static String homePaginated = 'home/dynamic/listing/paginated/elastic';
  static String homePremiumListings = 'home/dynamic/listing/subscriptiondata';

  ///CMS type
  static String cmsType = 'cms/type/';

  /// Add Sub Account
  static String subAccount = 'user/subaccount';

  /// Switch Account
  static String switchAccountOtpSend = 'user/switchaccount/otp/send';
  static String switchAccount = 'user/switchAccount';

  ///Master APIs
  static String getWorkerSkills = 'master/skill/all';
  static String getBusinessType = 'master/businesstype/all';
  static String communityListingType = 'master/communitylistingtype/all';
  static String getAllPropertyType = 'master/propertytype/all';
  static String getAutoTypeStr = 'master/autotype/all';
  static String promoCategoryType = 'master/promocategory/all';
  static String industryType = 'master/industrytype/all';
  static String chatListing = 'chat/get-message-list';
  static String chatHistory = 'chat/get-chat-history';
  static String markMessagesRead = 'chat/mark-messages-read';
  static String blockUnBlockUser = 'chat/block-unblock-user';
  static String deleteChat = 'chat/delete-message';
  static String addToContact = 'chat/add-contact';
  static String messageDetail = 'chat/user-chat-details';
  static String sendMessage = 'chat/send-message';
  static String getMessageInfo = 'chat/get-message-info';
  static String getChatUnreadCount  = 'chat/get-chat-unread-count';
  static String addConnectionIdToUser = 'chat/AddConnectionId-ToUser';

  ///Account Type Change
  static String activeListingCount = 'listing/dynamic/accounttype/activelistingcount';
  static String activeListingList = 'listing/dynamic/accounttype/activelisting/list';
  static String changeAccountType = 'listing/dynamic/accounttype/{accountType}/confirmlisting';

  /// My Listing Insight
  static String listingInsight = 'listing/insight/DynamicPaginated';
  static String insightCount = 'listing/dynamic-insight-count';
  static String activityTracking = 'listing/dynamic/visitor/activitytracking';

  /// Statistics
  static String statisticsInsight = 'listing/{{listingId}}/category/{{categoryId}}/insight';
  static String statisticsRatings = 'listing/{{listingId}}/category/{{categoryId}}/ratinglist/paginated';
  static String statisticsEnquiries = 'listing/{{listingId}}/enquiries/paginated';

  /// CMS Enum
  static int privacyPolicyInt = 1;
  static int termConditionsInt = 2;
  static int aboutUsInt = 3;

  /// Contact Apis
  static String contactList = 'user/contact-list';
  static String deleteContact = 'user/contact/';
  static String contactProfile = 'user/contact-profile/';
  static String inviteContact = 'user/invite';
  static String inviteValidate = 'user/invite/validate';
  static String allActiveListing = 'listing/dynamic/allactivelisting';
  static String pastListing = 'listing/dynamic/pastlisting';

  ///Dynamic Listing Api
  static String dynamicAddListingCategoryList = 'dynamic-form/GetFormList';
  static String dynamicFormData = 'response/dynamic-form/{formId}/listing/operation';
  static String dynamicFileUpload = 'listing/dynamic/uploadfile/stream';
  static String getInheritedListing = 'listing/dynamic/getactivelisting';

  ///Spam Listing
  static String reportSpamList = 'master/userspam-reporttype/all';

  //Deep link API
  static String encodeLink = 'listing/';
  static String decodeLink = 'listing/redirect/';
}
