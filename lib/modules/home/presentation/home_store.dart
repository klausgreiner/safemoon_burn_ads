import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:safemoon_burn_ads/modules/home/domain/models/post_model.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  _HomeStore();

  FirebaseRemoteConfig? remoteConfig;

  @observable
  Post? currentPost;
  @observable
  bool loading = false;

  @observable
  List posts = [];

  String remoteConfigString = "";
  double? remoteConfigNumber;

  int indexCurrentPost = 2;
  @action
  Future fetchAllData() async {
    loading = true;
    remoteConfigString = "";
    remoteConfigNumber = null;
    posts = [];
    currentPost = null;
    indexCurrentPost = 2;
    getRedditPost();
    _fetchAndActivate();
  }

  num get getAmountRaised => remoteConfig?.getDouble('ads_money') ?? 0;

  String get getStringValue => remoteConfig?.getString('quick_news') ?? "";

  @action
  Future _fetchAndActivate() async {
    bool updated = await remoteConfig?.fetchAndActivate() ?? false;
    if (updated || getStringValue.isNotEmpty) {
      remoteConfigString = getStringValue;
      remoteConfigNumber = getAmountRaised.toDouble();
    }
  }

  @action
  getRedditPost() async {
    try {
      var response = await http.get(Uri(
          scheme: 'https', host: 'www.reddit.com', path: '/r/safemoon/.json'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var _posts = data['data']['children'];
        posts = _posts.map((_post) => Post.fromJson(_post)).toList();

        currentPost = posts[indexCurrentPost];
      }
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
  }

  @action
  getNextPost() {
    if (indexCurrentPost == posts.length - 1) {
      indexCurrentPost = 2;
    } else {
      indexCurrentPost++;
    }
    currentPost = posts[indexCurrentPost];
  }

  @action
  getPreviousPost() {
    if (indexCurrentPost == 2) {
      indexCurrentPost = posts.length - 1;
    } else {
      indexCurrentPost--;
    }
    currentPost = posts[indexCurrentPost];
  }

  get imageFromPost {
    String? url = currentPost?.img ?? currentPost?.thumbnail;
    bool isValidImg =
        (url?.contains('.jpg') ?? false) || (url?.contains('.png') ?? false);
    return isValidImg ? url : null;
  }
}
