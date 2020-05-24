import 'package:flutter/cupertino.dart';
import 'package:ungallery/network/image_fetch.dart';
import 'package:ungallery/persistence/image_persistence.dart';

abstract class ImageBatchProvider extends ChangeNotifier{
  Future<ImageBatch> getImages();
}

class RandomImageBatchProvider extends ImageBatchProvider {
  Future<ImageBatch> images;
  var count;

  RandomImageBatchProvider.single() {
    count = 1;
  }

  RandomImageBatchProvider({this.count});

  @override
  Future<ImageBatch> getImages() async {
    images = ImageAPI.fetchRandomImages(count);
    return images;
  }
}

class StarredImageBatchProvider extends ImageBatchProvider {
  Future<ImageBatch> images;

  StarredImageBatchProvider(){
    StarredImagePersistence.listenable.addListener(() {
      super.notifyListeners();
    });
  }

  @override
  Future<ImageBatch> getImages() async {
    images = StarredImagePersistence.starredImages();
    return images;
  }
}

class QueryImageBatchProvider extends ImageBatchProvider {
  Future<ImageBatch> images;
  String _query = "a";


  set query(String value) {
    _query = value;
    images = ImageAPI.searchImages(value, resultLimit);
    super.notifyListeners();
  }

  int resultLimit;

  QueryImageBatchProvider({this.resultLimit});

  @override
  Future<ImageBatch> getImages() async {
    images = ImageAPI.searchImages(_query, resultLimit);
    return images;
  }
}

class WrapperImageBatchProvider extends ImageBatchProvider {

  Future<ImageBatch> _imageBatch;
  WrapperImageBatchProvider(this._imageBatch);

  set imageBatch(Future<ImageBatch> value) {
    _imageBatch = value;
    super.notifyListeners();
  }

  @override
  Future<ImageBatch> getImages() {
      return _imageBatch;
  }

}