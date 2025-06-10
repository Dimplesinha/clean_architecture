import 'package:workapp/src/presentation/modules/account_type_change/cubit/account_type_change_cubit.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/active_listing_grid.dart';

class ChooseActiveListing extends StatefulWidget {
  final AccountTypeChangeCubit accountTypeChangeCubit;
  final int accountType;

  const ChooseActiveListing({super.key, required this.accountTypeChangeCubit, required this.accountType});

  @override
  State<ChooseActiveListing> createState() => _ChooseActiveListingState();
}

class _ChooseActiveListingState extends State<ChooseActiveListing> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.accountTypeChangeCubit.activeListingList(accountType: widget.accountType, isRefresh: true);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
            widget.accountTypeChangeCubit.hasNextPage) {
          widget.accountTypeChangeCubit.activeListingList(accountType: widget.accountType);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder<AccountTypeChangeCubit, AccountTypeChangeLoadedState>(
          bloc: widget.accountTypeChangeCubit,
          builder: (context, state) {
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
                        if (state.selectedListing.every((item) => item.isSelected == null) ||
                            state.selectedListing.any((item) => item.isSelected == true)) {
                          for (var listing in state.selectedListing) {
                            listing.isSelected = false;
                            listing.selectAll = false;
                          }
                        }
                        widget.accountTypeChangeCubit.clearSelectedListings(state.selectedListing);
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
                      widget.accountTypeChangeCubit.currentPage = 1;
                      await widget.accountTypeChangeCubit
                          .activeListingList(accountType: widget.accountType, isRefresh: true);
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric( vertical: 15.0),
                        child: state.activeListingList == null || state.activeListingList!.isEmpty
                            ? Center(
                                child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                                    child: Text(
                                      AppConstants.activePlanLimit
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
                                          widget.accountTypeChangeCubit.updateActiveListing(state.selectedListing);
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                                    child: ActiveListingsGrid(
                                      isFromMyListing: true,
                                      needScrolling: false,
                                      showCheckBox: true,
                                      myListingItems: state.activeListingList,
                                      accountTypeChangeCubit: widget.accountTypeChangeCubit,
                                      accountTypeChangeLoadedState: state,
                                      callback: () {
                                        widget.accountTypeChangeCubit.activeListingList(accountType: widget.accountType, isRefresh: true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  state.isLoading ? const LoaderView() : const SizedBox.shrink(),
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
                      if (listingLimit >= selectedCount && selectedCount !=0) {
                        int selectedCount = state.selectedListing.where((item) => item.isSelected == true).length;
                        ReusableWidgets.showConfirmationDialog(
                          'Confirm Listings',
                          AppConstants.confirmListingsMessage
                              .replaceAll('{listingCount}', selectedCount.toString())
                              .replaceAll('{listing}', selectedCount > 1 ? 'listing' : 'listings'),
                          negativeBtnTitle: AppConstants.noStr,
                          positiveBtnTitle: AppConstants.yesStr,
                              () {
                                AppRouter.pop();
                                widget.accountTypeChangeCubit
                                    .changeAccountType(accountType: widget.accountType,);
                          },
                        );
                      }else if(selectedCount==0){
                        ReusableWidgets.showConfirmationDialog(
                          'Please confirm!',
                          AppConstants.notSelectedListing,
                          negativeBtnTitle: AppConstants.noStr,
                          positiveBtnTitle: AppConstants.yesStr,
                              () {
                            AppRouter.pop();
                            widget.accountTypeChangeCubit
                                .changeAccountType(accountType: widget.accountType,);
                          },
                        );
                      } else {
                        AppUtils.showSnackBar(
                          AppConstants.activePlanLimitMessage
                              .replaceAll('{limit count}', listingLimit.toString())
                              .replaceAll('{subscriptionTitle}', state.activeListingList?.first.subscriptionTitle ?? '')
                              .replaceAll('{listing}', listingLimit == 1 ? 'listing' : 'listings'),
                          SnackBarType.alert,
                        );
                      }
                    },
                    title:
                        '${AppConstants.confirm} (${state.selectedListing.where((item) => item.isSelected == true).length}/${state.totalCount})',
                  )),
            );
          }),
    );
  }
}
