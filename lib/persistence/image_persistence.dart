import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CachedImage {
	final String imageId;
	final String imageUrl;
	final String thumbnailUrl;
	final String authorName;
	final String authorAvatarUrl;
	bool starred;

	CachedImage({this.starred,
		this.imageUrl,
		this.thumbnailUrl,
		this.authorName,
		this.authorAvatarUrl,
		this.imageId});

	factory CachedImage.fromJson(Map<String, dynamic> json) {
		return CachedImage(
			starred: false,
			imageId: json["id"],
			imageUrl: json["urls"]["full"],
			thumbnailUrl: json["urls"]["thumb"],
			authorName: json["user"]["username"],
			authorAvatarUrl: json["user"]["profile_image"]["small"],
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'imageId': imageId,
			'imageUrl': imageUrl,
			'thumbnailUrl': thumbnailUrl,
			'authorName': authorName,
			'authorAvatarUrl': authorAvatarUrl,
		};
	}

	void setStarred(bool newValue) {
		this.starred = newValue;
	}
}

class StarredImageListenable extends ChangeNotifier {

	void notify() {
		super.notifyListeners();
	}

}

class StarredImagePersistence {
	static final StarredImageListenable listenable = StarredImageListenable();

	static List<String> starredImageIds = <String>[];

	static Future<Database> _init() async {
		final Future<Database> database = openDatabase(
			join(await getDatabasesPath(), 'starred_images.db'),
			onCreate: (db, version) {
				// Run the CREATE TABLE statement on the database.
				return db.execute(
					"CREATE TABLE starred_images(imageId TEXT PRIMARY KEY, imageUrl TEXT, thumbnailUrl TEXT, authorName TEXT, authorAvatarUrl TEXT)",
				);
			},
			version: 1,
		);
		return database;
	}

	static Future<void> insertImage(CachedImage image) async {
		final Database db = await _init();

		await db.insert(
			'starred_images',
			image.toMap(),
			conflictAlgorithm: ConflictAlgorithm.replace,
		);

		listenable.notify();
	}

	static Future<void> removeImage(String imageId) async {
		final db = await _init();


		await db.delete(
			'starred_images',
			where: "imageId = ?",
			whereArgs: [imageId],
		);
		listenable.notify();
	}

	static Future<ImageBatch> starredImages() async {
		final Database db = await _init();


		final List<Map<String, dynamic>> maps = await db.query('starred_images');


		return ImageBatch(List.generate(maps.length, (i) {
			return CachedImage(
				imageId: maps[i]["imageId"],
				imageUrl: maps[i]["imageUrl"],
				thumbnailUrl: maps[i]["thumbnailUrl"],
				authorName: maps[i]["authorName"],
				authorAvatarUrl: maps[i]["authorAvatarUrl"],
				starred: true,
			);
		}));
	}

	static Future<bool> hasImage(String imageId) async {
		final Database db = await _init();


		final List<Map<String, dynamic>> maps = await db.query('starred_images');

/**/
		for (Map<String, dynamic> map in maps) {
			if (map["imageId"] == imageId) return true;
		}
		return false;
	}
}

class ImageBatch {
	var _images = <CachedImage>[];

	get images => _images;

	ImageBatch(this._images);

	CachedImage getImage(int index) {
		return _images[index];
	}

	int getLength() {
		return _images.length;
	}
}