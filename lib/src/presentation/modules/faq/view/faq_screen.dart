import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/faq_model.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/faq/cubit/faq_cubit.dart';
import 'package:workapp/src/presentation/modules/faq/repo/faq_repo.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt. Ltd.
/// @DATE : 11-12-2024
/// @Message : [FAQScreenView]

class FAQScreenView extends StatefulWidget {
  const FAQScreenView({super.key});

  @override
  State<FAQScreenView> createState() => _FAQScreenViewState();
}

class _FAQScreenViewState extends State<FAQScreenView> {
  FaqCubit faqCubit = FaqCubit(faqRepo: FAQRepo.instance);

  @override
  void initState() {
    super.initState();
    faqCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<FaqCubit, FaqLoadedState>(
          bloc: faqCubit,
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: AppColors.backgroundColor,
                  appBar: const MyAppBar(
                    title: AppConstants.faqStr,
                    automaticallyImplyLeading: false,
                    backBtn: true,
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        state.faqItemData?.isEmpty ?? false ? const SizedBox.shrink() : _mobileView(state: state),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: state.isLoading,
                  replacement: const SizedBox(),
                  child: const LoaderView(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _mobileView({required FaqLoadedState state}) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: state.faqItemData?[0].items?.length ?? 0,
        itemBuilder: (context, index) {
          FAQItems? faqItemData = state.faqItemData?[0].items?[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _faqContainer(
              onTap: () {
                if (faqItemData?.isVisible == false || faqItemData?.isVisible == null) {
                  faqItemData?.isVisible = true;
                } else {
                  faqItemData?.isVisible = false;
                }
                setState(() {});
              },
              faqTitle: faqItemData?.question ?? '',
              faqText: faqItemData?.answer ?? '',
              iconVisible: !(faqItemData?.isVisible ?? false),
              textVisible: faqItemData?.isVisible ?? false,
            ),
          );
        },
      ),
    );
  }

  Widget _faqContainer({
    required void Function()? onTap,
    required String faqTitle,
    required String faqText,
    required bool iconVisible,
    required bool textVisible,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 12.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    faqTitle,
                    style: FontTypography.priceStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                Visibility(
                  visible: iconVisible,
                  replacement: const Icon(Icons.keyboard_arrow_up_sharp),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
        sizedBox10Height(),
        Visibility(
          visible: textVisible,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    faqText,
                    textAlign: TextAlign.left,
                    style: FontTypography.answerTextStyle,
                  ),
                ),
              ),
              sizedBox10Height(),
            ],
          ),
        ),
      ],
    );
  }
}
