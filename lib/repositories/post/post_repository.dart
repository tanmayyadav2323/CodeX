import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/config/paths.dart';
import 'package:code/models/comment_model.dart';
import 'package:code/models/post_model.dart';

import 'base post_repository.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  Stream<List<Future<Post>>> getUserPosts({required String roomId}) {
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  void deletePost(String id) {
    _firebaseFirestore.collection(Paths.posts).doc(id).delete();
  }

  void createLike({required Post post, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});
  }

  void deleteLikes({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});
    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }

  Future<Set<String>> getLikedPostIds(
      {required String userId, required List<Post> posts}) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();

      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }

  Future<void> createComment(
      {required Comment comment, required Post post}) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());
  }

  @override
  Stream<List<Future<Comment>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }
}
