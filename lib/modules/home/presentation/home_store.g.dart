// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStore, Store {
  final _$currentPostAtom = Atom(name: '_HomeStore.currentPost');

  @override
  Post? get currentPost {
    _$currentPostAtom.reportRead();
    return super.currentPost;
  }

  @override
  set currentPost(Post? value) {
    _$currentPostAtom.reportWrite(value, super.currentPost, () {
      super.currentPost = value;
    });
  }

  final _$loadingAtom = Atom(name: '_HomeStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$postsAtom = Atom(name: '_HomeStore.posts');

  @override
  List<dynamic> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(List<dynamic> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  final _$fetchAllDataAsyncAction = AsyncAction('_HomeStore.fetchAllData');

  @override
  Future<dynamic> fetchAllData() {
    return _$fetchAllDataAsyncAction.run(() => super.fetchAllData());
  }

  final _$_fetchAndActivateAsyncAction =
      AsyncAction('_HomeStore._fetchAndActivate');

  @override
  Future<dynamic> _fetchAndActivate() {
    return _$_fetchAndActivateAsyncAction.run(() => super._fetchAndActivate());
  }

  final _$getRedditPostAsyncAction = AsyncAction('_HomeStore.getRedditPost');

  @override
  Future getRedditPost() {
    return _$getRedditPostAsyncAction.run(() => super.getRedditPost());
  }

  final _$_HomeStoreActionController = ActionController(name: '_HomeStore');

  @override
  dynamic getNextPost() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.getNextPost');
    try {
      return super.getNextPost();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getPreviousPost() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.getPreviousPost');
    try {
      return super.getPreviousPost();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPost: ${currentPost},
loading: ${loading},
posts: ${posts}
    ''';
  }
}
