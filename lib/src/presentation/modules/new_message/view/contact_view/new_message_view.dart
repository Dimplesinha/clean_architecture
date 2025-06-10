import 'dart:async';

import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/new_message/cubit/new_message_cubit.dart';
import 'package:workapp/src/presentation/modules/new_message/repo/message_repo.dart';
import 'package:workapp/src/presentation/modules/new_message/view/contact_view/invite_contact_view.dart';
import 'package:workapp/src/presentation/modules/new_message/view/contact_view/manage_contact_view.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 10/09/24
/// @Message : [NewMessageView]
///
/// The `NewMessageView` class provides user interface to select workapp contact tab
/// workapp group tab, and invite
///

class NewMessageView extends StatefulWidget {
  const NewMessageView({super.key});

  @override
  State<NewMessageView> createState() => _NewMessageViewState();
}

class _NewMessageViewState extends State<NewMessageView> with SingleTickerProviderStateMixin {
  NewMessageCubit newMessageCubit = NewMessageCubit(contactRepository: ContactRepository.instance);
  final PageController _pageController = PageController();
  final StreamController<bool> _streamControllerClearBtn = StreamController<bool>.broadcast();

  Stream<bool> get _streamClearBtn => _streamControllerClearBtn.stream;

  @override
  void initState() {
    super.initState();
    newMessageCubit.init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMessageCubit, NewMessageState>(
      bloc: newMessageCubit,
      builder: (context, state) {
        if (state is NewMessageLoadedState) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: const MyAppBar(
              elevation: 2,
              centerTitle: true,
              title: AppConstants.newMessageStr,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: ReusableWidgets.searchWidget(
                    maxLines:1,
                    onSubmit: (value) {
                      _onSearchClick();
                    },
                    onChanged: (value) => {_streamControllerClearBtn.add(value.isNotEmpty)},
                    stream: _streamClearBtn,
                    onCancelClick: () {
                      _streamControllerClearBtn.add(false);
                      newMessageCubit.searchTxtController.clear();
                      _onSearchClick();
                    },
                    onSearchIconClick: () {
                      _onSearchClick();
                    },
                    txtController: newMessageCubit.searchTxtController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tabButton(
                      context,
                      0,
                      AssetPath.workAppContactIcon,
                      AppConstants.workAppContactStr,
                      state.selectedIndex,
                      _pageController,
                      newMessageCubit,
                    ),
                    /*AppUtils.tabButton(context, 1, AssetPath.workAppGroupIcon, AppConstants.workAppGroupStr,
                      state.selectedIndex, _pageController),*/
                    tabButton(
                      context,
                      1,
                      AssetPath.inviteIcon,
                      AppConstants.inviteStr,
                      state.selectedIndex,
                      _pageController,
                      newMessageCubit,
                    ),
                  ],
                ),
                Expanded(
                  child: messageTabBody(
                    selectedTab: state.selectedIndex,
                    state: state,
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onSearchClick() {
    newMessageCubit.contactCurrentPage = 1;
    newMessageCubit.fetchContactList(isRefresh: true, isSwipe: true);
  }

  Widget messageTabBody({int? selectedTab, required NewMessageLoadedState state}) {
    switch (selectedTab) {
      case 0:
        return ManageContactScreen(newMessageCubit: newMessageCubit);
      case 1:
        return InviteScreen(
          state: state,
          newMessageCubit: newMessageCubit,
          pageController: _pageController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  static Widget tabButton(BuildContext context, int index, String path, String label, int? selectedIndex,
      PageController pageController, NewMessageCubit newMessageCubit) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          newMessageCubit.selectTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(
              width: 0.7,
              color: AppColors.tabBorderColor,
            ),
          ),
          child: Column(
            children: [
              ReusableWidgets.createSvg(
                  path: path, color: isSelected ? AppColors.primaryColor : AppColors.blackColor, size: 16),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: isSelected
                    ? FontTypography.tabBarStyle.copyWith(color: AppColors.primaryColor)
                    : FontTypography.tabBarStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
