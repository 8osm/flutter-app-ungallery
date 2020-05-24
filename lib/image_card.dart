import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ungallery/image_fullscreen.dart';
import 'package:ungallery/persistence/image_persistence.dart';

class ImageCard extends StatefulWidget {
  final bool starred;
  final CachedImage image;

  const ImageCard({@required this.image, this.starred}) : assert(image != null);

  @override
  createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  var starred;
  var snackBar;

  @override
  void initState() {
    super.initState();
    starred = widget.starred == null ? false : widget.starred;
  }

  Color _getStarred() {
    return starred ? Colors.orange : Colors.black;
  }

  void _invertStarred() {
    snackBar = SnackBar(
      content: Text(
        starred ? "Unstarred!" : "Starred!",
      ),
      duration: Duration(milliseconds: 500),
    );

    if (!starred) {
      StarredImagePersistence.insertImage(widget.image);
    } else {
      StarredImagePersistence.removeImage(widget.image.imageId);
    }

    Scaffold.of(context).showSnackBar(snackBar);
    setState(() {
      starred = !starred;
    });
  }

  void _navigateToFullscreen() {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return (ImageFullscreen(widget.image.imageUrl));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Color.fromRGBO(200, 200, 200, 0.5)),
          ),
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _navigateToFullscreen();
                },
                child: Center(
                  child: Image.network(
                    widget.image.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 48,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.image.authorAvatarUrl),
                            maxRadius: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.image.authorName,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _invertStarred,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Icon(
                            Icons.star,
                            color: _getStarred(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
