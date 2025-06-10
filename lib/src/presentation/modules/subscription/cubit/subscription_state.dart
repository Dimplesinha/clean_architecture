part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {}

final class SubscriptionInitial extends SubscriptionState {
  @override
  List<Object?> get props => [];
}

final class SubscriptionLoadedState extends SubscriptionState {
  final bool isPersonalPlanChecked;
  final bool isWorkAppPlanChecked;
  final bool loader;
  final bool isUpgradable;
  final bool isCancelled;
  final List<SubscriptionList>? subscriptionData;
  final List<SubscriptionList>? mySubscriptionHistoryData;
  final List<NoSubscriptionAccountData>? noSubscriptionAccountData;
  final List<MyListingItems>? activeListingList;
  final List<MyListingItems> selectedListing;
  final List<PromoCodeItems>? promoCodeItems;
  final MySubscriptionData? mySubscriptionData;
  final PromoDetails? promoDetails;
  final String? selectedAccount;
  final String? promoCode;
  final String? purchaseToken;
  final int? selectedUserId;
  final int? listingCount;
  final int? totalCount;

  SubscriptionLoadedState({
    this.isPersonalPlanChecked = true,
    this.isWorkAppPlanChecked = false,
    this.loader = false,
    this.isUpgradable = false,
    this.isCancelled = false,
    this.subscriptionData,
    this.selectedAccount,
    this.selectedUserId,
    this.listingCount,
    this.mySubscriptionData,
    this.mySubscriptionHistoryData,
    this.activeListingList,
    this.promoCodeItems,
    this.promoCode,
    this.purchaseToken,
    this.promoDetails,
    this.selectedListing = const [],
    this.noSubscriptionAccountData,
    this.totalCount,
  });

  SubscriptionLoadedState copyWith({
    bool? isPersonalPlanChecked,
    bool? loader,
    bool? isUpgradable,
    bool? isCancelled,
    bool? isWorkAppPlanChecked,
    List<SubscriptionList>? subscriptionData,
    List<SubscriptionList>? mySubscriptionHistoryData,
    List<NoSubscriptionAccountData>? noSubscriptionAccountData,
    String? selectedAccount,
    String? promoCode,
    String? purchaseToken,
    MySubscriptionData? mySubscriptionData,
    PromoDetails? promoDetails,
    int? selectedUserId,
    List<MyListingItems>? activeListingList,
    List<MyListingItems>? selectedListing,
    List<PromoCodeItems>? promoCodeItems,
    int? listingCount,
    int? totalCount,
  }) {
    return SubscriptionLoadedState(
      loader: loader ?? this.loader,
      isPersonalPlanChecked: isPersonalPlanChecked ?? this.isPersonalPlanChecked,
      isUpgradable: isUpgradable ?? this.isUpgradable,
      isCancelled: isCancelled ?? this.isCancelled,
      isWorkAppPlanChecked: isWorkAppPlanChecked ?? this.isWorkAppPlanChecked,
      subscriptionData: subscriptionData ?? this.subscriptionData,
      mySubscriptionHistoryData: mySubscriptionHistoryData ?? this.mySubscriptionHistoryData,
      noSubscriptionAccountData: noSubscriptionAccountData ?? this.noSubscriptionAccountData,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      mySubscriptionData: mySubscriptionData ?? this.mySubscriptionData,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      listingCount: listingCount ?? this.listingCount,
      activeListingList: activeListingList ?? this.activeListingList,
      selectedListing: selectedListing ?? this.selectedListing,
      totalCount: totalCount ?? this.totalCount,
      promoCode: promoCode ?? this.promoCode,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      promoCodeItems: promoCodeItems ?? this.promoCodeItems,
      promoDetails: promoDetails ?? this.promoDetails,
    );
  }

  @override
  List<Object?> get props => [
        loader,
        isUpgradable,
    isCancelled,
        isPersonalPlanChecked,
        isWorkAppPlanChecked,
        subscriptionData,
        selectedAccount,
        noSubscriptionAccountData,
        mySubscriptionData,
        selectedUserId,
        listingCount,
        activeListingList,
        selectedListing,
        totalCount,
    purchaseToken,
        mySubscriptionHistoryData,
        promoCodeItems,
        promoCode,
        promoDetails,
        identityHashCode(this)
      ];
}
