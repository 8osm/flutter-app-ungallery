import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ungallery/image_tab.dart';
import 'package:ungallery/provider/image_provider.dart';
import 'network/image_fetch.dart';


class SearchView extends StatefulWidget {

	@override
	createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
	static const int SEARCH_LIMIT = 30;

	final TextEditingController _searchController = TextEditingController();

	QueryImageBatchProvider queryImageProvider;

	_SearchViewState() {
		_searchController.addListener(() {
			if (_searchController.text.isEmpty) {
				setState(() {
					queryImageProvider.query = "";
				});
			} else {
				setState(() {
					queryImageProvider.query = _searchController.text;
				});
			}
		});
	}

	@override
  void dispose() {
		_searchController.dispose();
		super.dispose();
  }

  @override
	void initState() {
		super.initState();
		queryImageProvider = QueryImageBatchProvider(resultLimit: SEARCH_LIMIT);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: TextField(
					autofocus: true,
					controller: _searchController,
					decoration: new InputDecoration(
							hintText: 'Search...'
					),
				),
			),
			body: Container(
			  child: Center(
			    child: Builder(
			      builder: (BuildContext context){
				      return ImageTab(
					      imageProvider: this.queryImageProvider,
					      onEmptyIcon: Icons.search,
					      onEmptyText: "No results found",
					      pageStorageKey: "queryImagesStorageKey",
				      );
			      },
			    ),
			  ),
			),
		);
	}
}