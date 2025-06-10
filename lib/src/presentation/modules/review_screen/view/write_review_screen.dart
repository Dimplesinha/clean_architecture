import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/review_screen/cubit/review_cubit.dart';
import 'package:workapp/src/presentation/style/font/font_typography.dart';
import 'package:workapp/src/presentation/widgets/app_text_field.dart';
import 'package:workapp/src/utils/utils.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 16/09/24
/// @Message : [WriteReviewScreen]
///
/// The `WriteReviewScreen`  class provides a user interface to displays a bottom to sheet to write review and give rating
class WriteReviewScreen extends StatefulWidget {
  final bool isFromReview;
  final bool? isEditable;
  int? myRatingCount = 0;
  final int? categoryId;
  final int? itemId;
  final int? ratingId;
  final String? ratingComment;

  WriteReviewScreen(
      {super.key,
      required this.isFromReview,
      this.isEditable,
      this.myRatingCount = 0,
      this.categoryId,
      this.itemId,
      this.ratingId,
      this.ratingComment});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  ReviewCubit reviewCubit = ReviewCubit();

  @override
  void initState() {
    reviewCubit.init(listingId: 0, categoryId: 0);
    super.initState();
  }

  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _reviewController.text = widget.ratingComment ?? '';
    reviewCubit.rattingCount = widget.myRatingCount ?? 0;
    return BlocBuilder<ReviewCubit, ReviewState>(
      bloc: reviewCubit,
      builder: (context, state) {
        if (state is ReviewLoadedState) {
          return Stack(
            children: [
              PopScope(
                canPop: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 7,
                            width: 59,
                            decoration: BoxDecoration(
                              color: AppColors.bottomSheetBarColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            widget.isFromReview ? AppConstants.rateStr : AppConstants.shareSomethingAboutUs,
                            style: FontTypography.profileHeading.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 20),
                          Visibility(
                            visible: widget.isFromReview,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IgnorePointer(
                                      ignoring: widget.isEditable == false,
                                      child: RatingBar(
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        onRatingChanged: (value) {
                                          reviewCubit.rattingCount = value.toInt();
                                        },
                                        initialRating: reviewCubit.rattingCount.toDouble() != 0.0
                                            ? reviewCubit.rattingCount.toDouble()
                                            : widget.myRatingCount!.toDouble(),
                                        maxRating: 5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 29),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !widget.isFromReview,
                            child: sizedBox20Height(),
                          ),
                          AppTextField(
                            height: 119,
                            hintTxt: AppConstants.enterCommentStr,
                            isReadOnly: widget.isEditable == false,
                            controller: _reviewController,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.newline,
                            textAlignVertical: const TextAlignVertical(y: -1),
                            isExpanded: true,
                            topPadding: 10.0,
                            fillColor: AppColors.locationButtonBackgroundColor,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: CancelButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  title: AppConstants.cancelStr,
                                  bgColor: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Visibility(
                                visible: widget.isEditable == true,
                                child: Expanded(
                                  child: AppButton(
                                    function: () async {
                                      if (reviewCubit.rattingCount == 0) {
                                        AppUtils.showSnackBar(AppConstants.ratingIsRequired, SnackBarType.alert);
                                      } else {
                                        await reviewCubit.addRatingReview(
                                          categoryId: widget.categoryId ?? 0,
                                          listingId: widget.itemId ?? 0,
                                          ratingThumbsUp: reviewCubit.rattingCount,
                                          ratingComment: _reviewController.text,
                                          ratingId: widget.ratingId ?? 0,
                                        );
                                      }
                                    },
                                    title: AppConstants.submitStr,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.loader)
                const Positioned.fill(
                  child: Center(
                    child: LoaderView(),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
