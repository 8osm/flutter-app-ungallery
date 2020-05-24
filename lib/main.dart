import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ungallery/provider/image_provider.dart';
import 'package:ungallery/search.dart';

import 'image_tab.dart';

void main() {
  runApp(MainRoute(
    appTitle: "UnGallery",
  ));
}

class MainRoute extends StatefulWidget {
  final appTitle;

  MainRoute({@required this.appTitle}) : assert(appTitle != null);

  @override
  createState() => _MainRouteState();
}

class SearchAction extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    void _onSearchPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return SearchView();
        }),
      );
    }

    return InkWell(
      onTap: _onSearchPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(Icons.search),
      ),
    );
  }
  
}

class _MainRouteState extends State<MainRoute> {
  ImageBatchProvider starredImages;
  ImageBatchProvider images;

  @override
  void initState() {
    super.initState();
    images = RandomImageBatchProvider(count: 30);
    starredImages = StarredImageBatchProvider();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(0, 0, 0, 0.7),
          ),
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.appTitle),
            actions: [
              SearchAction()
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: "Images",
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: "Starred",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ImageTab(
                imageProvider: this.images,
                onEmptyIcon: Icons.cancel,
                onEmptyText: "No images here",
                pageStorageKey: "ImagesStorageKey",
              ),
              ImageTab(
                imageProvider: this.starredImages,
                onEmptyIcon: Icons.star,
                onEmptyText: "Your starred images will appear here",
                pageStorageKey: "starredImagesStorageKey",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
