import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/models/add_listing_form_model.dart';
import 'package:workapp/src/domain/models/dynamic_add_listing_response_model.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';

class AddListingFormView extends StatefulWidget {
  final CategoriesListResponse? category;
  final int? itemId;
  final int? formId;
  final String? accountType;
  final String? recordStatus;
  final int? recordStatusID;
  final MyListingCubit? myListingCubit;
  final MyListingLoadedState? myListingLoadedState;
  final bool? isListingEditing;
  final bool? isDraft;
  final bool? isAvailableHistory;

  const AddListingFormView({
    super.key,
    required this.category,
    this.itemId,
    this.formId,
    this.accountType,
    this.myListingCubit,
    this.myListingLoadedState,
    this.isListingEditing,
    this.isDraft,
    this.recordStatus,
    this.recordStatusID,
    this.isAvailableHistory,
  });

  @override
  State<AddListingFormView> createState() => _AddListingFormViewState();
}

class _AddListingFormViewState extends State<AddListingFormView> {
  final ScrollController _scrollController = ScrollController();
  AddListingFormCubit addListingFormCubit = AddListingFormCubit();

  @override
  void initState() {
    addListingFormCubit.fetchCurrency();
    addListingFormCubit.init(
      formId: widget.formId,
      itemId: widget.itemId,
      recordStatusID: widget.recordStatusID,
      isListingEditing: widget.isDraft == true ? false : widget.isListingEditing,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddListingFormCubit, AddListingFormLoadedState>(
      bloc: addListingFormCubit,
      builder: (context, state) {
        String listingName = state.listings?.formName ?? widget.category?.formName ?? '';
        return Container(
          color: AppColors.primaryColor,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              appBar: MyAppBar(
                title: widget.itemId == null
                    ? AppConstants.addListingTitleStr.replaceFirst(
                        '{listingName}',
                        listingName,
                      )
                    : AppConstants.updateListingTitleStr.replaceFirst(
                        '{listingName}',
                        listingName,
                      ),
                actionList: [
                  Visibility(
                    visible: widget.itemId != null,
                    replacement: const SizedBox.shrink(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.locationButtonBackgroundColor,
                        child: InkWell(
                          onTap: () async {
                            if (RecordStatus.waitingForApproval.value == widget.recordStatusID &&
                                state.listings?.isAvailableHistory == true) {
                              // If status is "waiting for approval", ask user what they want to delete
                              await ReusableWidgets.showConfirmationDialog2(
                                AppConstants.pleasConfirm,
                                AppConstants.areYouSureDeleteWaitingStr,
                                () async {
                                  // Delete Listing
                                  widget.myListingCubit?.onDeletingWaitingForApproval(
                                      itemId: widget.itemId, isHistory: false, isFromItemEdit: true);
                                },
                                positiveBtnTitle: AppConstants.deleteListing,
                                // negativeBtnTitle: AppConstants.deleteAwaitingApproval,
                                negativeBtnTitle: '${AppConstants.deleteStr} ${widget.recordStatus}',
                              ).then((result) async {
                                if (result == false) {
                                  // Delete Awaiting Approval
                                  widget.myListingCubit?.onDeletingWaitingForApproval(
                                      itemId: widget.itemId, isHistory: true, isFromItemEdit: true);
                                }
                              });
                            } else {
                              ReusableWidgets.showLoaderDialog();
                              int? itemCount = await widget.myListingCubit?.fetchItemUsageCount(
                                itemId: widget.itemId,
                                formId: widget.formId,
                              );
                              AppRouter.pop();
                              if (widget.itemId != null) {
                                if (itemCount != 0 && itemCount != null) {
                                  ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                      AppConstants.pleasConfirm, AppConstants.categoryInUse,
                                      funcYes: () {
                                        navigatorKey.currentState?.pop();
                                        widget.myListingCubit?.onDeletingWaitingForApproval(
                                            itemId: widget.itemId, isHistory: false, isFromItemEdit: true);
                                      },
                                      funcNo: () => navigatorKey.currentState?.pop());
                                } else {
                                  ReusableWidgets.showConfirmationWithTwoFuncDialog(
                                      AppConstants.pleasConfirm,
                                      AppConstants.areYouSureDeleteStr.replaceFirst(
                                          '{categoryName}', widget.category?.formName?.toLowerCase() ?? ''),
                                      funcYes: () async {
                                        navigatorKey.currentState?.pop();
                                        widget.myListingCubit?.onDeletingWaitingForApproval(
                                            itemId: widget.itemId, isHistory: false, isFromItemEdit: true);
                                      },
                                      funcNo: () => navigatorKey.currentState?.pop());
                                }
                              }
                            }
                          },
                          child: ReusableWidgets.createSvg(
                              path: AssetPath.deleteIcon, color: AppColors.jetBlackColor), // Icon inside the button
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Visibility(
                visible: !state.isUpdatingInitialData,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: SizedBox(
                    height: 50,
                    child: addListingFormNavigationButtons(state: state),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Visibility(
                      visible: !state.isUpdatingInitialData,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListingFormBannerView(
                            state: state,
                            progress: Progress(
                              currentStep: state.currentSectionCount ?? 1,
                              totalSteps: state.totalSectionCount ?? 1,
                            ),
                          ),
                          addListingFormBody(
                              currentSectionCount: state.currentSectionCount ?? 1,
                              state: state,
                              recordStatus: widget.recordStatus)
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading) const LoaderView() else const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Scroll to top position
  void _scrollToTop() {
    _scrollController.jumpTo(0);
  }

  Widget addListingFormBody({
    required int currentSectionCount,
    required AddListingFormLoadedState state,
    String? recordStatus,
  }) {
    List<Sections>? sectionList = state.sections;

    if (sectionList == null || currentSectionCount > sectionList.length) {
      return const SizedBox.shrink();
    }
    return BasicDetailsFormView(
        addListingFormCubit: addListingFormCubit,
        state: state,
        sectionIndex: (state.currentSectionCount ?? 1) - 1,
        itemId: widget.itemId ?? 0,
        recordStatus: recordStatus);
  }

  Widget addListingFormNavigationButtons({
    required AddListingFormLoadedState state,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Visibility(
            visible: state.currentSectionCount != 1,
            replacement: const SizedBox.shrink(),
            child: AppBackButton(
              bgColor: AppColors.whiteColor,
              function: () {
                if (!state.isLoading) {
                  handleBackButtonClick();
                }
              },
              title: AppConstants.backStr,
            ),
          ),
        ),
        sizedBox20Width(),
        Expanded(
          child: AppButton(
            function: () {
              if (!state.isLoading) {
                if (state.currentSectionCount != state.totalSectionCount) {
                  handleNextButtonClick(widget.isListingEditing);
                } else {
                  handleSubmitButtonClick(state);
                }
              }
            },
            title: state.currentSectionCount != state.totalSectionCount ? AppConstants.nextStr : AppConstants.submitStr,
          ),
        ),
      ],
    );
  }

  void handleBackButtonClick() {
    addListingFormCubit.onBackButtonClick();
    _scrollToTop();
  }

  Future<void> handleNextButtonClick(bool? isListingEditing) async {
    DynamicAddListingResponseModel? res =
        await addListingFormCubit.onNextButtonClick(isListingEditing: isListingEditing);
    // if (res != null) {
    _scrollToTop();
    //}
  }

  void handleSubmitButtonClick(AddListingFormLoadedState state) {
    addListingFormCubit.onNextButtonClick(isFromSubmitButton: true);
  }
}
