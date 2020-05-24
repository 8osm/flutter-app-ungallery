import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ungallery/persistence/image_persistence.dart';

import 'image_card.dart';
import 'provider/image_provider.dart';

class ImageTab extends StatefulWidget {
	final ImageBatchProvider imageProvider;
	final String onEmptyText;
	final IconData onEmptyIcon;
	final String pageStorageKey;
  const ImageTab({@required this.imageProvider, @required this.onEmptyText, @required this.onEmptyIcon, @required this.pageStorageKey});
	
  @override
  _ImageTabState createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
	var images;

  @override
  void initState() {
	  super.initState();
	  images = widget.imageProvider.getImages();
	  widget.imageProvider.addListener(_updateImages);
  }

  void _updateImages(){
  	setState(() {
  	  images = widget.imageProvider.getImages();
  	});
  }

	@override
  void dispose() {
		widget.imageProvider.removeListener(_updateImages);
		super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<ImageBatch>(
	      future: images,
        builder: (BuildContext context, AsyncSnapshot<ImageBatch> snapshot) {
	      	if(snapshot.hasData) {
			      if(snapshot.data.getLength() == 0){
			      	return Padding(
			      	  padding: const EdgeInsets.only(top:16.0),
			      	  child: Container(
					      child: Column(
						      crossAxisAlignment: CrossAxisAlignment.center,
						      children: [
						      	Icon(widget.onEmptyIcon, size: 40, color: Colors.grey,),
							      Text(widget.onEmptyText, style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey),)
						      ],
					      ),
				      ),
			      	);
			      }
			      return ListView.builder(
				      key: PageStorageKey(widget.pageStorageKey),
				      itemCount: snapshot.data.getLength(),
				      itemBuilder: (BuildContext context, int index) {
					      return Container(
						      margin: EdgeInsets.symmetric(horizontal: 8),
						      child: ImageCard(
							      starred: snapshot.data.getImage(index).starred,
							      image: snapshot.data.getImage(index),
						      ),
					      );
				      },
			      );
		      } else if(snapshot.hasError){
			      return Text("${snapshot.error}");
		      }
		      return Row(
				      mainAxisAlignment: MainAxisAlignment.center,
				      crossAxisAlignment: CrossAxisAlignment.center,
				      children: [CircularProgressIndicator()]);
        },
      ),
    );
  }
}
