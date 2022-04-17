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

  final _$loadingAdAtom = Atom(name: '_HomeStore.loadingAd');

  @override
  bool get loadingAd {
    _$loadingAdAtom.reportRead();
    return super.loadingAd;
  }

  @override
  set loadingAd(bool value) {
    _$loadingAdAtom.reportWrite(value, super.loadingAd, () {
      super.loadingAd = value;
    });
  }

  final _$loadingFullAtom = Atom(name: '_HomeStore.loadingFull');

  @override
  bool get loadingFull {
    _$loadingFullAtom.reportRead();
    return super.loadingFull;
  }

  @override
  set loadingFull(bool value) {
    _$loadingFullAtom.reportWrite(value, super.loadingFull, () {
      super.loadingFull = value;
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

  final _$adsWatchedAtom = Atom(name: '_HomeStore.adsWatched');

  @override
  num get adsWatched {
    _$adsWatchedAtom.reportRead();
    return super.adsWatched;
  }

  @override
  set adsWatched(num value) {
    _$adsWatchedAtom.reportWrite(value, super.adsWatched, () {
      super.adsWatched = value;
    });
  }

  final _$userNameAtom = Atom(name: '_HomeStore.userName');

  @override
  String? get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String? value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$passwordAtom = Atom(name: '_HomeStore.password');

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$safemoonValueAtom = Atom(name: '_HomeStore.safemoonValue');

  @override
  num get safemoonValue {
    _$safemoonValueAtom.reportRead();
    return super.safemoonValue;
  }

  @override
  set safemoonValue(num value) {
    _$safemoonValueAtom.reportWrite(value, super.safemoonValue, () {
      super.safemoonValue = value;
    });
  }

  final _$adAverageValueAtom = Atom(name: '_HomeStore.adAverageValue');

  @override
  num get adAverageValue {
    _$adAverageValueAtom.reportRead();
    return super.adAverageValue;
  }

  @override
  set adAverageValue(num value) {
    _$adAverageValueAtom.reportWrite(value, super.adAverageValue, () {
      super.adAverageValue = value;
    });
  }

  final _$amountRaisedAtom = Atom(name: '_HomeStore.amountRaised');

  @override
  num get amountRaised {
    _$amountRaisedAtom.reportRead();
    return super.amountRaised;
  }

  @override
  set amountRaised(num value) {
    _$amountRaisedAtom.reportWrite(value, super.amountRaised, () {
      super.amountRaised = value;
    });
  }

  final _$amountBurnedAtom = Atom(name: '_HomeStore.amountBurned');

  @override
  num get amountBurned {
    _$amountBurnedAtom.reportRead();
    return super.amountBurned;
  }

  @override
  set amountBurned(num value) {
    _$amountBurnedAtom.reportWrite(value, super.amountBurned, () {
      super.amountBurned = value;
    });
  }

  final _$announcementAtom = Atom(name: '_HomeStore.announcement');

  @override
  String get announcement {
    _$announcementAtom.reportRead();
    return super.announcement;
  }

  @override
  set announcement(String value) {
    _$announcementAtom.reportWrite(value, super.announcement, () {
      super.announcement = value;
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

  final _$fetchuserScoreAsyncAction = AsyncAction('_HomeStore.fetchuserScore');

  @override
  Future fetchuserScore(dynamic name, dynamic password) {
    return _$fetchuserScoreAsyncAction
        .run(() => super.fetchuserScore(name, password));
  }

  final _$_HomeStoreActionController = ActionController(name: '_HomeStore');

  @override
  dynamic setUserName(dynamic name, dynamic password, dynamic newUser) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setUserName');
    try {
      return super.setUserName(name, password, newUser);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSafemoonValue() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setSafemoonValue');
    try {
      return super.setSafemoonValue();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAdAverageValue() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setAdAverageValue');
    try {
      return super.setAdAverageValue();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmountRaised() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setAmountRaised');
    try {
      return super.setAmountRaised();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmountBurned() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setAmountBurned');
    try {
      return super.setAmountBurned();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAnnouncementValue() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.setAnnouncementValue');
    try {
      return super.setAnnouncementValue();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

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
loadingAd: ${loadingAd},
loadingFull: ${loadingFull},
posts: ${posts},
adsWatched: ${adsWatched},
userName: ${userName},
password: ${password},
safemoonValue: ${safemoonValue},
adAverageValue: ${adAverageValue},
amountRaised: ${amountRaised},
amountBurned: ${amountBurned},
announcement: ${announcement}
    ''';
  }
}
