import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/constants/appwrite_constants.dart';
import 'package:twitter__clone/core/providers.dart';

final storageApiProvider = Provider((ref) {
  return StorageApi(storage: ref.watch(appwriteStorageProvider));
});

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: 'unique()',
        // ignore: deprecated_member_use
        file: InputFile(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadImage.$id),
      );
    }
    return (imageLinks);
  }
}
