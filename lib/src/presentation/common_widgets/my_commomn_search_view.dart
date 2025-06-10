import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/common_widgets/app_bar.dart';

class MyCommonSearchView extends StatefulWidget {
  final List<String?> listItems;
  final String title;
  final TextStyle? hintSearchTextStyle;
  final TextStyle? searchTextStyle;
  final TextStyle? listTitleTextStyle;

  const MyCommonSearchView({Key? key, required this.listItems, required this.title, this.hintSearchTextStyle, this.listTitleTextStyle, this.searchTextStyle}) : super(key: key);

  @override
  State<MyCommonSearchView> createState() => _MyCommonSearchViewState();
}

class _MyCommonSearchViewState<T> extends State<MyCommonSearchView> {
  List<String?> listItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setState(() => listItems = widget.listItems));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title, backBtn: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              style: widget.hintSearchTextStyle ?? const TextStyle(color: Colors.black),
              onChanged: (value) => _onChangedText(value),
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
                hintText: 'Search',
                hintStyle: widget.hintSearchTextStyle ?? const TextStyle(color: Colors.black),
                suffixIcon: const SizedBox(
                  height: 10.0,
                  width: 10.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 15.0, top: 15.0),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  var item = listItems[index];
                  return ListTile(
                    title: Text(item ?? '', style: widget.listTitleTextStyle ?? const TextStyle(color: Colors.black)),
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onChangedText(String value) {
    List<String?> searchList = widget.listItems.where((item) {
      return item?.toLowerCase().contains(value.toLowerCase()) ?? false;
    }).toList();

    setState(() => listItems = searchList);
  }
}
