import 'dart:ffi';

import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/common_widgets/linkedin_login.dart';
import 'package:workapp/src/presentation/common_widgets/video_player.dart';
import 'package:workapp/src/presentation/modules/account_type_change/cubit/account_type_change_cubit.dart';
import 'package:workapp/src/presentation/modules/account_type_change/view/active_lisiting.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/view/add_listing_form_view.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/view/advance_search_screen_view.dart';
import 'package:workapp/src/presentation/modules/change_password/view/change_password.dart';
import 'package:workapp/src/presentation/modules/contact_us/view/contact_us_view.dart';
import 'package:workapp/src/presentation/modules/dynamic_add_listing_form/view/dynamic_form_view.dart';
import 'package:workapp/src/presentation/modules/email_verification/view/email_verification_view.dart';
import 'package:workapp/src/presentation/modules/faq/view/faq_screen.dart';
import 'package:workapp/src/presentation/modules/filter/view/filter_view.dart';
import 'package:workapp/src/presentation/modules/forgot_password/view/forgot_password_view.dart';
import 'package:workapp/src/presentation/modules/invite_contacts_form_view/view/invite_contact_form_view.dart';
import 'package:workapp/src/presentation/modules/item_details/view/image_preview_view.dart';
import 'package:workapp/src/presentation/modules/item_details/view/item_details_views.dart';
import 'package:workapp/src/presentation/modules/listing_statistics/view/listing_statistics_view.dart';
import 'package:workapp/src/presentation/modules/message_chat/view/message_chat.dart';
import 'package:workapp/src/presentation/modules/modules.dart';
import 'package:workapp/src/presentation/modules/my_contact_user_listing/view/my_contact_user_listing_tab.dart';
import 'package:workapp/src/presentation/modules/my_profile/view/my_profile.dart';
import 'package:workapp/src/presentation/modules/new_message/view/contact_view/new_message_view.dart';
import 'package:workapp/src/presentation/modules/new_password/view/new_password_view.dart';
import 'package:workapp/src/presentation/modules/otp_verify_screen/view/otp_verify_view.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/view/basic_details_view.dart';
import 'package:workapp/src/presentation/modules/profile_listings/view/profile_listing_view.dart';
import 'package:workapp/src/presentation/modules/profile_personal_details/view/personal_details_view.dart';
import 'package:workapp/src/presentation/modules/review_screen/view/review_screen.dart';
import 'package:workapp/src/presentation/modules/search/view/search_view.dart';
import 'package:workapp/src/presentation/modules/settings/view/settings_screen.dart';
import 'package:workapp/src/presentation/modules/sign_up/view/sign_up_view.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';
import 'package:workapp/src/presentation/modules/subscription/view/choose_active_listing.dart';
import 'package:workapp/src/presentation/modules/subscription/view/promo_code_apply_screen.dart';
import 'package:workapp/src/presentation/modules/subscription/view/subscription_history_view.dart';
import 'package:workapp/src/presentation/modules/subscription/view/subscription_list.dart';
import 'package:workapp/src/presentation/modules/terms_condition/view/terms_condition_screen.dart';
import 'package:workapp/src/presentation/modules/verified/view/verified_view.dart';
import 'package:workapp/src/presentation/my_contact_profile/view/my_contact_profile.dart';
import 'package:workapp/src/presentation/widgets/in_app_web_view.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 04/09/24
/// @Message : [AppRouter]
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        switch (settings.name) {
          case AppRoutes.signInViewRoute:
            return const SignInView();
          case AppRoutes.appRoot:
            return const SplashScreen();
          case AppRoutes.notificationRoute:
            return const LocalNotification();
          case AppRoutes.homeScreenRoute:
            return const LandingPage(title: AppConstants.demoHomeStr);
          case AppRoutes.changePasswordRoute:
            return const ChangePasswordScreen();
          case AppRoutes.settingScreenRoute:
            return const SettingScreen();
          case AppRoutes.contactUsRoute:
            return const ContactUsView();
          case AppRoutes.forgotPasswordScreenRoute:
            return const ForgotPassword();
          case AppRoutes.myProfileScreenRoute:
            final args = settings.arguments as Map<String, dynamic>;
            bool isFromProfile = args[ModelKeys.isFromProfile] ?? true;
            return MyProfile(isFromProfile: isFromProfile);
          case AppRoutes.myContactProfileScreenRoute:
            final args = settings.arguments as Map<String, dynamic>;
            int contactId = args[ModelKeys.contactId] ?? 0;
            return MyContactProfile(contactId: contactId);
          case AppRoutes.inviteContactFormView:
            return const InviteContactFormView();
          case AppRoutes.myContactUserListing:
            final args = settings.arguments as Map<String, dynamic>;
            String title = args[ModelKeys.title] ?? '';
            int userId = args[ModelKeys.userId] ?? 0;
            return MyContactUserListingTab(
              title: title,
              userId: userId,
            );
          case AppRoutes.advanceSearchScreenRoute:
            final args = settings.arguments as AdvanceSearchScreen?;
            return AdvanceSearchScreen(
              categoriesList: args?.categoriesList,
              locationController: args?.locationController,
              keywordController: args?.keywordController,
              oldFormData: args?.oldFormData,
            );
          case AppRoutes.emailVerificationScreenRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            final String? email = args?[ModelKeys.email];
            final String? newEmail = args?[ModelKeys.newEmail];
            final int? otpType = args?[ModelKeys.otpType];
            final bool? isFromSignUp = args?[ModelKeys.isFromSignUp];
            final bool? isFromChangeEmail = args?[ModelKeys.isFromChangeEmail];
            return EmailVerificationScreen(
              email: email ?? '',
              newEmail: newEmail ?? '',
              otpType: otpType ?? 0,
              isFromSignUp: isFromSignUp ?? false,
              isFromChangeEmail: isFromChangeEmail ?? false,
            );
          case AppRoutes.newPasswordScreenRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            String? token = args?[ModelKeys.token];
            bool? isForSetPassword = args?[ModelKeys.isForSetPassword];
            return NewPasswordScreen(
              token: token ?? '',
              isForSetPassword: isForSetPassword ?? false,
            );
          case AppRoutes.verifiedScreenRoute:
            final args = settings.arguments as Map<String, dynamic>;
            String? token = args[ModelKeys.token];
            bool isFromSignUp = args[ModelKeys.isFromSignUp] ?? false;
            return VerifiedScreen(
              token: token ?? '',
              isFromSignUp: isFromSignUp,
            );
          case AppRoutes.signUpScreenRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            String? firstName = args?[ModelKeys.firstName];
            String? lastName = args?[ModelKeys.lastName];
            String? email = args?[ModelKeys.email];
            String? socialMediaUserId = args?[ModelKeys.socialMediaUserId];
            bool? isFromSocialAuth = args?[ModelKeys.isFromSocialAuth];
            return SignUpView(
              firstName: firstName ?? '',
              lastName: lastName ?? '',
              email: email ?? '',
              socialMediaUserId: socialMediaUserId ?? '',
              isFromSocialAuth: isFromSocialAuth ?? false,
            );
          case AppRoutes.filterScreenRoute:
            return const FilterViewScreen();
          case AppRoutes.profileBasicDetailsScreenRoute:
            return const BasicDetailsScreen();
          case AppRoutes.profilePersonalDetailsScreenRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            bool isFromProfile = args?[ModelKeys.isFromProfile] ?? false;
            bool isFromBasicDetails = args?[ModelKeys.isFromBasicDetails] ?? false;
            String? firstName = args?[ModelKeys.firstName];
            String? lastName = args?[ModelKeys.lastName];
            int? dob = args?[ModelKeys.birthYear];
            String? gender = args?[ModelKeys.gender];
            String? accountType = args?[ModelKeys.accountType];
            return PersonalDetailsScreen(
              isFromProfile: isFromProfile,
              firstName: firstName ?? '',
              lastName: lastName ?? '',
              dob: dob ?? 0,
              gender: gender ?? '',
              accountType: accountType ?? '',
              isFromBasicDetails: isFromBasicDetails,
            );
          case AppRoutes.listingStatisticsInsightRoute:
            final args = settings.arguments as Map<String, dynamic>;
            var listingId = args[ModelKeys.listingId];
            var categoryId = args[ModelKeys.categoryId];
            var isActiveListing = args[ModelKeys.isActiveListing];
            return ListingStatisticsView(
              listingId: listingId,
              categoryId: categoryId,
              isActiveListing: isActiveListing,
            );
          case AppRoutes.profileListingsScreenRoute:
            return const ProfileListingsScreen();
          case AppRoutes.subscriptionRoute:
            return const SubscriptionListView();
          case AppRoutes.subscriptionHistory:
            return const SubscriptionHistoryView();
          case AppRoutes.searchScreenRoute:
            final args = settings.arguments as Map<String, dynamic>;
            var categoriesList = args[ModelKeys.categoriesList];
            return SearchScreen(categoriesList: categoriesList ?? []);
          case AppRoutes.reviewScreenRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            var itemId = args?[ModelKeys.itemId];
            var categoryId = args?[ModelKeys.categoryId];
            var itemName = args?[ModelKeys.itemName];
            var isFromMyRatings = args?[ModelKeys.isFromMyRatings];
            return ReviewScreen(
              itemId: itemId,
              categoryId: categoryId,
              itemName: itemName,
              isFromMyRatings: isFromMyRatings ?? false,
            );
          case AppRoutes.messageChatScreenRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            int? receiverId = args?[ModelKeys.receiverId];
            String? senderName = args?[ModelKeys.senderName];
            int? senderId = args?[ModelKeys.senderId];
            int? latestMessageId = args?[ModelKeys.lastMessageId];
            int? messageListId = args?[ModelKeys.messageListId];
            int? itemId = args?[ModelKeys.itemId];
            int? itemListId = args?[ModelKeys.itemListId];
            int? businessCategoryId = args?[ModelKeys.categoryId];
            String? initialMessageText = '${args?[ModelKeys.initialMessageText]}';
            return MessageChatScreen(
              receiverId: receiverId,
              senderId: senderId,
              senderName: senderName,
              latestMessageId: latestMessageId,
              messageListId: messageListId,
              itemId: itemId,
              itemListId: itemListId,
              businessCategoryId: businessCategoryId,
              initialMessageText: initialMessageText,
            );
          case AppRoutes.newMessageScreenRoute:
            return const NewMessageView();
          case AppRoutes.itemDetailsViewRoute:
            final args = settings.arguments as Map<String, dynamic>?;
            var itemId = args?[ModelKeys.itemId];
            var formId = args?[ModelKeys.formId];
            String? category = args?[ModelKeys.category];
            bool? isDraft = args?[ModelKeys.isDraft];
            bool? isAvailableHistory = args?[ModelKeys.isAvailableHistory];
            return ItemDetailsScreen(
              itemId: itemId,
              formId: formId,
              categoryName: category,
              isDraft: isDraft,
              isAvailableHistory: isAvailableHistory,
            );
          case AppRoutes.itemImagePreviewRoute:
            final args = settings.arguments as ImagePreviewView;
            return ImagePreviewView(
              imageUrls: args.imageUrls,
              initialIndex: args.initialIndex,
              itemDetailsCubit: args.itemDetailsCubit,
            );
          case AppRoutes.addListingFormView:
            final args = settings.arguments as AddListingFormView;
            return AddListingFormView(
              category: args.category,
              itemId: args.itemId,
              formId: args.formId,
              accountType: args.accountType ?? '',
              myListingCubit: args.myListingCubit,
              myListingLoadedState: args.myListingLoadedState,
            );
          case AppRoutes.addListingDynamicFormView:
            final args = settings.arguments as DynamicFormView;
            return DynamicFormView(
              formId: args.formId,
            );
          case AppRoutes.linkedinLoginView:
            final args = settings.arguments as LinkedinLoginView?;
            return LinkedinLoginView(title: args?.title);
          case AppRoutes.chooseActiveListing:
            final args = settings.arguments as Map<String, Object?>;
            return ChooseActiveListing(
              accountTypeChangeCubit: args[ModelKeys.accountTypeChangeCubit] as AccountTypeChangeCubit,
              accountType: args[ModelKeys.accountType] as int,
            );
          case AppRoutes.chooseSubscriptionActiveListing:
            final args = settings.arguments as Map<String, Object?>;
            return ChooseFreeActiveListing(
              subscriptionCubit: args[ModelKeys.subscriptionCubit] as SubscriptionCubit,
              selectedUserId: args[ModelKeys.selectedUserId] as int,
            );

          ///Terms Condition Screen Route Case
          case AppRoutes.termsConditionScreen:
            final args = settings.arguments as Map<String, dynamic>;
            final cmsType = args[ModelKeys.cmsTypeIdStr];
            return TermsConditionScreen(cmsTypeId: cmsType);
          case AppRoutes.inAppWebView:
            final args = settings.arguments as WorkAppWebView;
            return WorkAppWebView(url: args.url);
          case AppRoutes.videoPlayerScreen:
            final args = settings.arguments as String;
            return VideoPlayerScreen(videoUrl: args);
          case AppRoutes.faqScreen:
            return const FAQScreenView();
          case AppRoutes.otpVerify:
            final args = settings.arguments as OtpVerifyScreen;
            return OtpVerifyScreen(email: args.email, userUUID: args.userUUID);
          case AppRoutes.promoCodeApplyScreen:
            final args = settings.arguments as PromoCodeScreen;
            return PromoCodeScreen(
              subscriptionId: args.subscriptionId,
              price: args.price,
              subscriptionName: args.subscriptionName,
              duration: args.duration,
              symbol: args.symbol,
              isActivePlan: args.isActivePlan,
              iosSubscriptionPlanId: args.iosSubscriptionPlanId,
              androidSubscriptionPlanId: args.androidSubscriptionPlanId,
              countryId: args.countryId,
            );
          default:
              return const LandingPage(title: AppConstants.demoHomeStr);
        }
      },
    );
  }

  static Future<Object?>? pushRemoveUntil(String route, {dynamic args}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(route, (route) => false, arguments: args);
  }

  static Future<Object?>? push(String route, {dynamic args}) {
    return navigatorKey.currentState?.pushNamed(route, arguments: args);
  }

  // static Future<Object?>? pushWithCallBack(
  //   String addListingFormView, {
  //     AddListingFormView? args,
  //   Function(String)? callback,
  // }) {
  //   return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => args??{})).then((result) {
  //     // Handle the result when the second page is popped
  //     if (result != null && result is String) {
  //       callback?.call(result);
  //     }
  //     return null;
  //   });
  // }

  static Future<Object?>? pushWithCallBack(
      String routeName, {
        required Widget args,
        Function(String)? callback,
      }) {
    return navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => args))
        .then((result) {
      if (result != null && result is String) {
        callback?.call(result);
      }
      return null;
    });
  }


  static Future<Object?>? pushReplacement(String route, {dynamic args}) {
    return navigatorKey.currentState?.pushReplacementNamed(route, arguments: args);
  }

  static void pop({dynamic res}) {
    navigatorKey.currentState?.pop(res);
  }

  static void popUntil({required String route}) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(route));
  }
}
