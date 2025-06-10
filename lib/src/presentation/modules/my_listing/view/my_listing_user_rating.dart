import 'dart:async';

import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_exports.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/view/my_rating_filter.dart';
import 'package:workapp/src/presentation/modules/review_screen/view/write_review_screen.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/label_text.dart';
import 'package:workapp/src/presentation/widgets/load_network_image.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 10/09/24
/// @Message : [MyListingRating]
///
/// The `MyListingRating` class provides a user interface to display a list of ratings shared by the user
///
/// Responsibilities:
/// By tapping on a rating item, the user will be redirected to view the rating screen, containing all ratings provided for that item by all users.

class MyListingRating extends StatelessWidget {
  final MyListingCubit myListingCubit;

  MyListingRating({super.key, required this.myListingCubit});

  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;
  final searchTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyListingCubit, MyListingState>(
      bloc: myListingCubit,
      builder: (context, state) {
        if (state is MyListingLoadedState) {
          if (state.ratingsSearchText!.isNotEmpty) {
            _streamControllerClearBtn.add(true);
            searchTxtController.text = state.ratingsSearchText!;
          } else {
            _streamControllerClearBtn.add(false);
          }

          return SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ReusableWidgets.searchWidget(
                          hintTxt: AppConstants.findMyRatings,
                          onSubmit: (value) {
                            FocusScope.of(context).unfocus(); // Hides the keyboard
                            _onSearchClick();
                            // No need of this logic here
                            /*if (searchTxtController.text.trim().isNotEmpty) {
                              _onSearchClick();
                            } else {
                              AppUtils.showSnackBar(AppConstants.searchHintStr, SnackBarType.alert);
                            }*/
                          },
                          onChanged: (value) => _streamControllerClearBtn.add(value.isNotEmpty),
                          stream: _streamClearBtn,
                          onCancelClick: () {
                            _streamControllerClearBtn.add(false);
                            searchTxtController.clear();
                            _onSearchClick();
                          },
                          onSearchIconClick: () {
                            FocusScope.of(context).unfocus(); // Hides the keyboard
                            _onSearchClick();
                            // No need of this logic here
                            /*if (searchTxtController.text.trim().isNotEmpty) {
                              _onSearchClick();
                            } else {
                              AppUtils.showSnackBar(AppConstants.searchHintStr, SnackBarType.alert);
                            }*/
                          },
                          txtController: searchTxtController,
                        ),
                      ),
                      sizedBox15Width(),
                      InkWell(
                        onTap: () {
                          AppUtils.showBottomSheet(
                            context,
                            child: MyRatingFilter(
                              myListingCubit: myListingCubit,
                              state: state,
                            ),
                          );
                        },
                        child: ReusableWidgets.createSvg(path: AssetPath.insightFilterIcon, color: AppColors.blackColor),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  sizedBox10Height(),
                  LabelText(
                    title: state.selectedRatingType == 1 ? AppConstants.myItemRatingsStr : AppConstants.myRatingsStr,
                    isRequired: false,
                    textStyle: FontTypography.subTextBoldStyle,
                  ),
                  sizedBox20Height(),
                  // List of ratings
                  state.myRatingItem == null || state.myRatingItem!.isEmpty
                      ? Center(
                          child: Text(AppConstants.noItemsStr, style: FontTypography.defaultTextStyle),
                        )
                      : ListView.builder(
                          itemCount: state.myRatingItem?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20.0),
                          itemBuilder: (context, index) {
                            RatingItems rating = state.myRatingItem?[index] ?? RatingItems();
                            bool isEditable = AppUtils.instance.dateCheck(rating.dateCreated ?? '');
                            return InkWell(
                              onTap: () {
                                AppRouter.push(AppRoutes.reviewScreenRoute, args: {
                                  ModelKeys.itemId: rating.listingId,
                                  ModelKeys.categoryId: rating.categoryId,
                                  ModelKeys.itemName: rating.listingName ?? '',
                                  ModelKeys.isFromMyRatings: true,
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: LoadNetworkImage(
                                            fit: BoxFit.fill,
                                            url: state.selectedRatingType == 1
                                                ? rating.profilePic ?? ''
                                                : rating.listingLogo ?? '',
                                            errorWidget: ReusableWidgets.createSvg(path: AssetPath.personIcon),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            // Rating Stars and Rating Score
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    state.selectedRatingType == 1
                                                        ? rating.userName ?? ''
                                                        : rating.listingName ?? '',
                                                    style: FontTypography.subTextStyle.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    ...AppUtils.buildStarIcons(
                                                        double.tryParse(rating.ratingThumbsUp.toString()) ?? 0.0),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      double.tryParse(rating.ratingThumbsUp.toString()).toString(),
                                                      style: FontTypography.ratingNumberTxtStyle,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: rating.userId == state.userId
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.spaceBetween,
                                              children: [
                                                Visibility(
                                                  visible: state.selectedRatingType == 1,
                                                  child: Flexible(
                                                    child: Text(
                                                      rating.listingName ?? '',
                                                      style: FontTypography.subTextStyle.copyWith(
                                                        color: AppColors.primaryColor,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: rating.userId == state.userId && isEditable,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Map<String, dynamic>? res = await AppUtils.showBottomSheet(
                                                          context,
                                                          child: WriteReviewScreen(
                                                            isFromReview: true,
                                                            itemId: rating.listingId,
                                                            categoryId: rating.categoryId,
                                                            myRatingCount: rating.ratingThumbsUp,
                                                            ratingComment: rating.ratingComment ?? '',
                                                            isEditable: isEditable,
                                                            ratingId: rating.ratingId,
                                                          ),
                                                        );

                                                        if (res != null) {
                                                          _onSearchClick();
                                                        }
                                                      },
                                                      child: SizedBox(
                                                        width: 30, // Increase tappable width
                                                        height: 30, // Increase tappable height
                                                        child: Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: ReusableWidgets.createSvg(
                                                              path: AssetPath.editIconBlack, size: 15.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  sizedBox5Height(),
                                  Text(
                                    rating.ratingComment ?? '',
                                    style: FontTypography.enquiryCityTxtStyle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  sizedBox5Height(),
                                  Text(
                                    rating.dateCreated != null
                                        ? AppUtils.currentDateTime(rating.dateCreated ?? '')
                                        : '',
                                    style: FontTypography.reviewTimeTxtStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  sizedBox40Height(),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _onSearchClick() {
    myListingCubit.ratingCurrentPage = 1;
    myListingCubit.fetchRatings(
      search: searchTxtController.text.trim(),
      isRefresh: true,
    );
  }
}
