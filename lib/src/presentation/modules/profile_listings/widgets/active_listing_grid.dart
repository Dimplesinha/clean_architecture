import 'package:flutter/material.dart';
import 'package:workapp/src/domain/models/models_export.dart';
import 'package:workapp/src/presentation/modules/account_type_change/cubit/account_type_change_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_card.dart';
import 'package:workapp/src/presentation/modules/subscription/cubit/subscription_cubit.dart';

class ActiveListingsGrid extends StatelessWidget {
  final List<MyListingItems>? myListingItems;
  final bool hasDummyItem;
  final bool needScrolling;
  final bool showCheckBox;
  final bool chooseListing;
  final bool isFromMyListing;
  final Function(int)? onItemClick;
  final AccountTypeChangeCubit? accountTypeChangeCubit;
  final AccountTypeChangeLoadedState? accountTypeChangeLoadedState;
  final SubscriptionCubit? subscriptionCubit;
  final SubscriptionLoadedState? subscriptionLoadedState;
  final Function()? callback;

  const ActiveListingsGrid({
    super.key,
    this.hasDummyItem = false,
    this.needScrolling = true,
    this.showCheckBox = false,
    this.chooseListing = false,
    this.onItemClick, // Pass index to onItemClick
    this.myListingItems,
    this.accountTypeChangeCubit,
    this.accountTypeChangeLoadedState,
    this.subscriptionCubit,
    this.subscriptionLoadedState,
    required this.isFromMyListing,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> gridItems;
    if (isFromMyListing == true) {
      gridItems = [
        ...?myListingItems?.asMap().entries.map(
              (entry) => ListingCard(
                myListingItem: entry.value,
                isFromMyListing: isFromMyListing,
                showCheckBox: showCheckBox,
                chooseListing: chooseListing,
                accountTypeChangeCubit: accountTypeChangeCubit,
                accountTypeChangeLoadedState: accountTypeChangeLoadedState,
                subscriptionCubit: subscriptionCubit,
                subscriptionLoadedState: subscriptionLoadedState,
                index: entry.key,
                // Pass the index
                callback: () {
                  callback?.call();
                },
              ),
            )
      ];
    } else {
      gridItems = [];
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: gridItems.length,
      itemBuilder: (BuildContext context, int index) {
        return gridItems[index];
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
