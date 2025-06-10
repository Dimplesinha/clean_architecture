import 'package:workapp/src/core/constants/sized_box_constants.dart';
import 'package:workapp/src/domain/models/advance_search_model.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/advance_search_screen/cubit/advance_search_cubit.dart';

class MetadataBottomSheet extends StatefulWidget {
  final AdvanceSearchCubit advanceSearchCubit;
  AdvanceSearchItem? advanceSearchItem;
  bool? isSaved;

  MetadataBottomSheet({Key? key, required this.advanceSearchCubit, this.advanceSearchItem, this.isSaved})
      : super(key: key);

  @override
  _MetadataBottomSheetState createState() => _MetadataBottomSheetState();
}

class _MetadataBottomSheetState extends State<MetadataBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvanceSearchCubit, AdvanceSearchState>(
      bloc: widget.advanceSearchCubit,
      builder: (context, state) {
        return Container(
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 7,
                  width: 59,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  widget.isSaved == true ? AppConstants.savedSearch : AppConstants.recentSearch,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 38),
                Flexible(child: CustomListView(advanceSearchItem: widget.advanceSearchItem!)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        width: 50,
                        function: () {
                          widget.advanceSearchCubit.searchFromOldListing(advanceSearchItem: widget.advanceSearchItem);
                        },
                        title: AppConstants.searchStr,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomListView extends StatelessWidget {
  final AdvanceSearchItem advanceSearchItem;

  const CustomListView({Key? key, required this.advanceSearchItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> searchData = AppUtils.getMetaData(advanceSearchItem);
    return ListView.builder(
      itemCount: searchData.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 12),
      itemBuilder: (context, index) {
        final key = searchData.keys.elementAt(index);
        final value = searchData.values.elementAt(index);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$key:  ',
              style: const TextStyle(fontSize: 16),
            ),
            sizedBox30Height(),
            Flexible(
              child: Text(
                '$value',
                maxLines: 4,
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow text
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
