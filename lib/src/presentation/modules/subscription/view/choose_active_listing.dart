import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/active_listing_grid.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';

class ChooseFreeActiveListing extends StatefulWidget {
  final SubscriptionCubit subscriptionCubit;
  final int selectedUserId;

  const ChooseFreeActiveListing({super.key, required this.subscriptionCubit, required this.selectedUserId});

  @override
  State<ChooseFreeActiveListing> createState() => _ChooseFreeActiveListingState();
}

class _ChooseFreeActiveListingState extends State<ChooseFreeActiveListing> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.subscriptionCubit.activeListingList(selectedUserId: widget.selectedUserId, isRefresh: true);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            widget.subscriptionCubit.hasNextPage) {
          widget.subscriptionCubit.activeListingList(selectedUserId: widget.selectedUserId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          bloc: widget.subscriptionCubit,
          builder: (context, state) {
            if (state is SubscriptionLoadedState) {
              return Scaffold(
                appBar: MyAppBar(
                  title: AppConstants.selectListing,
                  backBtn: true,
                  shadowColor: AppColors.borderColor.withValues(alpha: 0.5),
                  actionList: [
                    Visibility(
                      visible: state.selectedListing.any((item) => item.isSelected == true),
                      child: InkWell(
                        onTap: () {
                          if (state.selectedListing.any((item) => item.isSelected == true)) {
                            for (var listing in state.selectedListing) {
                              listing.isSelected = false;
                              listing.selectAll = false;
                            }
                          }
                          widget.subscriptionCubit.clearSelectedListings(state.selectedListing);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 20.0,
                            width: 30.0,
                            child: Text(
                              AppConstants.clearAllStr,
                              style: FontTypography.chipStyle.copyWith(color: AppColors.errorColor),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                body: Stack(
                  children: [
                    RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        widget.subscriptionCubit.currentPage = 1;
                        await widget.subscriptionCubit
                            .activeListingList(selectedUserId: widget.selectedUserId, isRefresh: true);
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0, ),
                          child: state.activeListingList == null || state.activeListingList!.isEmpty
                              ? Center(
                                  child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text(
                                        AppConstants.planSwitchActiveListingStr
                                            .replaceAll(
                                                '{listingLimit}', state.activeListingList!.first.listingLimit.toString())
                                            .replaceAll('{subscriptionTitle}',
                                                state.activeListingList?.first.subscriptionTitle ?? ''),
                                        style: FontTypography.listingStatTxtStyle
                                            .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    sizedBox10Height(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          side: BorderSide(
                                            color: AppColors.checkboxColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: BorderSide(color: AppColors.primaryColor),
                                          ),
                                          activeColor: AppColors.primaryColor,
                                          value: state.selectedListing.isNotEmpty &&
                                              state.selectedListing.every((listing) => listing.isSelected ?? false),
                                          onChanged: (value) async {
                                            if (state.selectedListing.every((item) => item.isSelected == null) ||
                                                state.selectedListing.any((item) => item.isSelected == false)) {
                                              for (var listing in state.selectedListing) {
                                                listing.isSelected = true;
                                                listing.selectAll = true;
                                              }
                                            } else {
                                              for (var listing in state.selectedListing) {
                                                listing.isSelected = false;
                                                listing.selectAll = false;
                                              }
                                            }
                                            widget.subscriptionCubit.updateActiveListing(state.selectedListing);
                                          },
                                        ),
                                        Text(
                                          AppConstants.selectAll,
                                          style: FontTypography.defaultTextStyle,
                                        ),
                                      ],
                                    ),
                                    sizedBox10Height(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: ActiveListingsGrid(
                                          isFromMyListing: true,
                                          needScrolling: false,
                                          chooseListing: true,
                                          myListingItems: state.activeListingList,
                                          subscriptionCubit: widget.subscriptionCubit,
                                          subscriptionLoadedState: state),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    state.loader ? const LoaderView() : const SizedBox.shrink(),
                  ],
                ),
                floatingActionButton: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: AppButton(
                        function: () {
                          int? listingLimit;
                          if (state.activeListingList != null && state.activeListingList!.isNotEmpty) {
                            listingLimit = state.activeListingList!.first.listingLimit ?? 0;
                          } else {
                            listingLimit = 0;
                          }
                          int? selectedCount = state.selectedListing.where((item) => item.isSelected == true).length;
                          if (listingLimit >= selectedCount) {
                            ReusableWidgets.showConfirmationDialog(
                              'Confirm Listings',
                              AppConstants.confirmListingsMessage
                                  .replaceAll('{listingCount}', selectedCount.toString())
                                  .replaceAll('{listing}', selectedCount > 1 ? 'listing' : 'listings'),
                              negativeBtnTitle: AppConstants.noStr,
                              positiveBtnTitle: AppConstants.yesStr,
                              () {
                                AppRouter.pop();
                                widget.subscriptionCubit.transferSubscriptionPlan(isFromActiveListing: true);
                              },
                            );
                          } else {
                            AppUtils.showSnackBar(
                              AppConstants.activePlanLimitMessage
                                  .replaceAll('{limit count}', listingLimit.toString())
                                  .replaceAll(
                                      '{subscriptionTitle}', state.activeListingList?.first.subscriptionTitle ?? '')
                                  .replaceAll('{listing}', listingLimit == 1 ? 'listing' : 'listings'),
                              SnackBarType.alert,
                            );
                          }
                        },
                        title:
                            '${AppConstants.confirm} (${state.selectedListing.where((item) => item.isSelected == true).length}/${state.totalCount})')),
              );
            }
            return const SizedBox.shrink();
          }),
    );
  }
}
