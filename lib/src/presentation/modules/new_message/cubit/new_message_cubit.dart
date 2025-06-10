import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/constants.dart';
import 'package:workapp/src/domain/models/contact_model.dart';
import 'package:workapp/src/domain/models/my_contacts_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/new_message/repo/message_repo.dart';

part 'new_message_state.dart';

class NewMessageCubit extends Cubit<NewMessageState> {
  bool selectContact = false;

  final ContactRepository? contactRepository;

  //Used to identify current page.
  int contactCurrentPage = 1;

  //Used to identify is it next page or not.
  bool hasNextPage = true;

  // Stores all contacts listing data.
  List<Contact>? updatedMyListingItems;

  final searchTxtController = TextEditingController();

  NewMessageCubit({this.contactRepository}) : super(NewMessageInitial());

  void init() async {
    emit(NewMessageLoadedState());
  }

  Future<void> initContacts() async {
    emit(NewMessageLoadedState());
    if(AppUtils.loginUserModel?.uuid != null) {
      await fetchContactList();

    }
  }

  /// fetch list of all
  Future<void> fetchContactList({bool isRefresh = true, bool isSwipe = false}) async {
    var oldState = state as NewMessageLoadedState;
    try {
      if(AppUtils.loginUserModel?.uuid == null) {
        return ;
      }
      if (isRefresh == true && isSwipe == false) {
        emit(oldState.copyWith(loader: true));
      }

      Map<String, dynamic> requestBody = {
        ModelKeys.pageIndex: contactCurrentPage,
        ModelKeys.pageSize: AppConstants.contactPageSize,
        ModelKeys.search: searchTxtController.text,
      };

      var response = await contactRepository?.fetchContactList(requestBody: requestBody);

      if (response?.responseData?.statusCode == 200 && response?.responseData != null) {
        List<Contact> myListingItem =
            (response?.responseData?.result.expand((model) => model.items).toList() ?? []).cast<Contact>();

        if (myListingItem.length == AppConstants.contactPageSize) {
          hasNextPage = true;
          contactCurrentPage++;
        } else {
          hasNextPage = false;
        }

        updatedMyListingItems = isRefresh
            ? myListingItem // start fresh with new items
            : [...?oldState.myListingItem, ...myListingItem];

        emit(oldState.copyWith(
          myListing: response?.responseData?.result[0].items,
          myListingItem: updatedMyListingItems,
          loader: false,
        ));
      } else {
        emit(oldState.copyWith(
          loader: false,
          myListingItem: [],
        ));
      }
    } catch (e) {
      emit(oldState.copyWith(loader: false, myListingItem: []));
    }
  }

  /// select tab
  void selectTab(int index) {
    //invite tab will be not selectable till api response come.
    if (index == 1) {
      if (updatedMyListingItems == null) {return;}
      updatedMyListingItems = null;
    }
    var oldState = state as NewMessageLoadedState;
    int lastIndex = oldState.selectedIndex ?? 1;
    emit(oldState.copyWith(selectedIndex: index, lastIndex: lastIndex));
  }

  /// on cancel of invite option
  void onCancel() {
    final oldState = state as NewMessageLoadedState;
    // if last index is 2 then do not update  last index
    int lastIndex = (oldState.lastIndex == 2) ? (oldState.selectedIndex ?? 0) : (oldState.lastIndex ?? 0);

    emit(oldState.copyWith(selectedIndex: lastIndex));
  }

  /// clear selected contact
  void clearSelectedContacts() {
    var oldState = state as NewMessageLoadedState;
    emit(oldState.copyWith(selectedContacts: [])); // Clear the selection
  }

  void changeInviteBy(String? title) {
    var oldState = state as NewMessageLoadedState;
    emit(oldState.copyWith(inviteBy: title));
  }

  void clearSelectedGroups() {
    var oldState = state as NewMessageLoadedState;
    emit(oldState.copyWith(selectedGroups: [])); // Clear the selection
  }
}
