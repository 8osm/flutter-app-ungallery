import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ungallery/persistence/image_persistence.dart';

class ImageAPI {
  static final _apiUrl = "https://api.unsplash.com";
  static final _apiKey =
      "<UNSPLASH API KEY HERE>";

  static Future<ImageBatch> fetchRandomImages(int amount) async {
    final res = await http
        .get("$_apiUrl/photos/random?count=$amount&client_id=$_apiKey");

    if (res.statusCode == 200) {
      final jsonRes = jsonDecode(res.body);
      var _imageList = <CachedImage>[];
      for (var image in jsonRes) {
        var cachedImage = CachedImage.fromJson(image);
        cachedImage.setStarred(
            await StarredImagePersistence.hasImage(cachedImage.imageId));
        _imageList.add(cachedImage);
      }

      return ImageBatch(_imageList);
    } else {
      throw Exception('Failed to load images');
    }
  }

  static Future<ImageBatch> searchImages(String searchQuery, int limit) async {
    final res = await http
        .get("$_apiUrl/search/photos?query=$searchQuery&client_id=$_apiKey");

    if (res.statusCode == 200) {
      final jsonRes = jsonDecode(res.body);
      var _imageList = <CachedImage>[];
      var currentImage = 0;

        if (jsonRes["total"] > 0) {
          for (dynamic image in jsonRes["results"]) {
//            if(currentImage >= limit) break;
            var cachedImage = CachedImage.fromJson(image);
            cachedImage.setStarred(
                await StarredImagePersistence.hasImage(jsonRes["id"]));
            _imageList.add(cachedImage);
            currentImage++;
        }
      }

      return ImageBatch(_imageList);
    } else {
      throw Exception('Failed to load images');
    }
  }

  static Future<CachedImage> fetchImageById(String id) async {
    final res = await http.get("$_apiUrl/photos/$id?client_id=$_apiKey");

    if (res.statusCode == 200) {
      final jsonRes = jsonDecode(res.body)[0];
      if (!jsonRes["errors"]) {
        var cachedImage = CachedImage.fromJson(jsonRes);
        cachedImage.setStarred(
            await StarredImagePersistence.hasImage(cachedImage.imageId));
        return cachedImage;
      }
    } else {
      throw Exception('Failed to load image');
    }
  }
}
