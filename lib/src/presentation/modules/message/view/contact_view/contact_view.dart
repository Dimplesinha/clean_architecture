import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/modules/message/view/contact_view/contact_inidividual.dart';

/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 12/09/24
/// @Message : [ContactView]
///
/// The `ContactView` class provides for displaying individual, groups, and requests
/// in a tabbed format, with a page view to switch between these categories.
///
/// Responsibilities:
/// Base View to Fetch individual, groups and requests
class ContactView extends StatefulWidget {
  MessageState state;

  ContactView(this.state, {super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> with SingleTickerProviderStateMixin {
  MessageCubit messageCubit = MessageCubit();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // messageCubit.init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: messageCubit..fetchItems(),
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _tabButton(context, 0, AssetPath.individualIcon, AppConstants.individualStr, state.selectedIndex),
                _tabButton(context, 1, AssetPath.groupIcon, AppConstants.groupStr, state.selectedIndex),
                _tabButton(context, 2, AssetPath.requestIcon, AppConstants.requestsStr, state.selectedIndex),
              ],
            ),
            //contactViewBody(selectedTab: state.selectedIndex),
            // PageView below the tab buttons
            // Expanded(
            //   child: PageView(
            //     controller: _pageController,
            //     onPageChanged: (index) {
            //       messageCubit.selectTab(index);
            //     },
            //     children: const [
            //       ContactIndividualScreen(),
            //       ContactGroupsScreen(),
            //       ContactRequestScreen(),
            //     ],
            //   ),
            // ),
          ],
        );
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

/*  Widget contactViewBody({int? selectedTab}) {
    switch (selectedTab) {
      case 0:
        return const ContactIndividualScreen();
      case 1:
        return const ContactGroupsScreen();
      case 2:
        return const ContactRequestScreen();
      default:
        return const SizedBox.shrink();
    }
  }*/

  /// Common Tab view of Message Enquiry and Contact
  Widget _tabButton(BuildContext context, int index, String path, String label, int? selectedIndex) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          messageCubit.selectTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(
              color: AppColors.borderColor,
            ),
          ),
          child: Column(
            children: [
              ReusableWidgets.createSvg(path: path, color: isSelected ? AppColors.primaryColor : AppColors.blackColor),
              const SizedBox(width: 8),
              Text(
                label,
                maxLines: 1,
                style: isSelected
                    ? FontTypography.defaultTextStyle.copyWith(color: AppColors.primaryColor)
                    : FontTypography.defaultTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
