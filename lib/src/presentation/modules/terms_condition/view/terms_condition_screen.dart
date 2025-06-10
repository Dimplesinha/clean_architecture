import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/app_constants.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';
import 'package:workapp/src/presentation/modules/terms_condition/cubit/cms_type_cubit.dart';

/// Created by
/// @AUTHOR : Prakash Software Solution Pvt. Ltd.
/// @DATE : 20-09-2024
/// @Message : [TermsConditionScreen]

class TermsConditionScreen extends StatefulWidget {
  final int cmsTypeId;

  const TermsConditionScreen({super.key, required this.cmsTypeId});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  String htmlData = '';
  CmsTypeCubit cmsTypeCubit = CmsTypeCubit();

  @override
  void initState() {
    super.initState();
    cmsTypeCubit.init(cmsTypeId: widget.cmsTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<CmsTypeCubit, CmsTypeState>(
          bloc: cmsTypeCubit,
          builder: (context, state) {
            if (state is CmsTypeLoadedState) {
              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: AppColors.backgroundColor,
                    appBar: MyAppBar(
                      title: state.cmsTypeModel?.result?.cmsTypeId == 1 ? AppConstants.registeringPrivacyStr : (state.cmsTypeModel?.result?.cmsTypeId == 2 ? AppConstants.registeringTandCStr : (state.cmsTypeModel?.result?.cmsTypeId == 3 ? AppConstants.aboutUsStr : '')),
                      backBtn: true,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Html(
                          data: state.cmsTypeModel?.result?.description ?? '<p>Wait for content to load.</p>',
                        ),
                      ),
                    ),
                  ),
                  state.isLoading ? const LoaderView() : const SizedBox.shrink()
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
