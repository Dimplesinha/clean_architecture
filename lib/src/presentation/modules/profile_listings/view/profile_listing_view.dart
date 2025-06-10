import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/core/core_exports.dart';
import 'package:workapp/src/presentation/common_widgets/app_bar.dart';
import 'package:workapp/src/presentation/modules/profile_listings/cubit/profile_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/profile_listings/repo/profile_listing_repo.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/category_list.dart';
import 'package:workapp/src/presentation/modules/profile_listings/widgets/listing_grid.dart';
import 'package:workapp/src/presentation/style/style.dart';

class ProfileListingsScreen extends StatefulWidget {
  const ProfileListingsScreen({super.key});

  @override
  State<ProfileListingsScreen> createState() => _ProfileListingsScreenState();
}

class _ProfileListingsScreenState extends State<ProfileListingsScreen> {
  final ProfileListingCubit profileListingCubit = ProfileListingCubit(profileListingRepo: ProfileListingRepo.instance);

  @override
  void initState() {
    profileListingCubit.init(userId: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Jeneliya's Listings"),
      body: BlocBuilder<ProfileListingCubit, ProfileListingState>(
        bloc: profileListingCubit,
        builder: (context, state) {
          if (state is ProfileListingLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox20Height(),
                CategoryList(),
                //
                servicesWidget(),
                ///ToDo: temporary removed mylisting parameters from listing grid add it later when implementing its
                ///TODO continue : is only for displaying due to removing model
                // Horizontal list
                Expanded(
                    child: ListingsGrid(
                  isFromMyListing: false,
                  hasDummyItem: false,
                  onItemClick: () => AppRouter.push(AppRoutes.itemDetailsViewRoute),
                )),
                //
                // Your main listings grid
              ],
            );
          } else if (state is ListingError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }

  Widget servicesWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppConstants.servicesStr,
            style: FontTypography.listingTitleTextStyle,
          ),
          Text(
            AppConstants.seeAllStr,
            style: FontTypography.subTextStyle.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
