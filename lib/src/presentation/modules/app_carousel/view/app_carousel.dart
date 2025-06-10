
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/presentation/modules/app_carousel/app_carousel_exports.dart';
import 'package:workapp/src/presentation/modules/app_carousel/cubit/app_carousel_cubit.dart';
import 'package:workapp/src/presentation/modules/app_carousel/repo/app_carousel_repo.dart';
import 'package:workapp/src/presentation/modules/profile_basic_details/profile_basic_details_exports.dart';

class AppCarouselView extends StatefulWidget {
  final Function()? onItemClick;
  final Function()? onCallback;
  final Function(MyListingResponse)? onItemListResult; // Added

  const AppCarouselView({super.key, this.onItemClick, this.onCallback,  this.onItemListResult});

  @override
  State<AppCarouselView> createState() => _AppCarouselViewState();
}

class _AppCarouselViewState extends State<AppCarouselView> {
  final AppCarouselCubit _appCarouselCubit = AppCarouselCubit(appCarouselRepository: AppCarouselRepository.instance);
  CarouselSliderController? _controller = CarouselSliderController();

  @override
  void initState() {
    _appCarouselCubit.init();
    _fetchItems();
    super.initState();
  }

  Future<void> _fetchItems() async {
    final result = await _appCarouselCubit.fetchItems();
    if (widget.onItemListResult != null && result != null) {
      widget.onItemListResult!(result);
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCarouselCubit, AppCarouselState>(
      bloc: _appCarouselCubit,
      builder: (context, state) {
        if (state is AppCarouselLoadedState) {
          final items = state.items ?? [];
          final List<Widget> sliderItems = [];
          final List<Widget> indicatorItems = [];

          for (int i = 0; i < items.length; i += 2) {
            final firstItem = items[i];
            final secondItem = (i + 1 < items.length) ? items[i + 1] : null;

            sliderItems.add(
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListingCard(
                        myListingItem: firstItem,
                        onItemClick: widget.onItemClick,
                        callback: widget.onCallback,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: secondItem != null
                          ? ListingCard(
                        myListingItem: secondItem,
                        onItemClick: widget.onItemClick,
                      )
                          : const SizedBox(), // empty right half
                    ),
                  ),
                ],
              ),
            );

            indicatorItems.add(
              AnimatedContainer(
                width: state.currentIndex == (i ~/ 2) ? 35.0 : 4,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: state.currentIndex == (i ~/ 2)
                      ? AppColors.primaryColor
                      : AppColors.greyUnselectedColor,
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
            );
          }
          double imageSize = (MediaQuery.of(context).size.width - 30) / 2;

          return Visibility(
            visible: indicatorItems.isNotEmpty ? true : false,
            child: Padding(
              padding: const EdgeInsets.only(left: 6,right:  6),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        enlargeCenterPage: false,
                        autoPlay: (state.items?.length ?? 0) > 1,
                        viewportFraction: 1,
                        height: imageSize + 60,
                        onPageChanged: (index, reason) {
                          _appCarouselCubit.onCarouselPageChange(currentIndex: index);
                        }),
                    carouselController: _controller,
                    items: sliderItems,
                  ),
                  sizedBox10Height(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [...indicatorItems])
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
