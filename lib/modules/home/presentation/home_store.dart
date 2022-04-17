import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:safemoon_burn_ads/modules/core/data/shared_preferences_repository.dart';
import 'package:safemoon_burn_ads/modules/home/domain/models/post_model.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final SharedPreferencesRepositoryImpl sharedPreferencesRepositoryImpl;

  _HomeStore(this.sharedPreferencesRepositoryImpl);

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

  @observable
  num adsWatched = 0;

  @observable
  String? userName;
  @observable
  String? password;

  get averageSafemoonBurnedPerAds =>
      (adsWatched * getAdAverageValue) / getSafemoonValue;
  @action
  setUserName(name, password, newUser) {
    newUser
        ? createUser(name, password)
        : fetchuserScore(
            name,
            password,
          );
  }

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

  num get getSafemoonValue => remoteConfig?.getDouble('safemoon_value') ?? 0;
  num get getAdAverageValue => remoteConfig?.getDouble('cpm') ?? 0.01;
  num get getAmountRaised => remoteConfig?.getDouble('ads_money') ?? 0;
  num get getAmountBurned => remoteConfig?.getDouble('burnt_money') ?? 0;

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

  @action
  fetchuserScore(name, password) async {
    try {
      var doc = FirebaseFirestore.instance
          .collection("users")
          .where('name', isEqualTo: name)
          .where('password', isEqualTo: password)
          .snapshots();

      doc.listen((data) {
        if (data.docs.isNotEmpty) {
          adsWatched = data.docs.first['score'] ?? 0;
          userName = data.docs.first['name'];
          password = data.docs.first['password'];
          updateNameSharedPref();
          updatePasswordSharedPref();
        } else {
          //wrong password
          Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              msg: "Invalid Username or Password",
              timeInSecForIosWeb: 3);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  createUser(name, password) {
    var doc = FirebaseFirestore.instance.collection('users');
    doc.where('name', isEqualTo: name).get().then((data) {
      if (data.docs.isNotEmpty) {
        Fluttertoast.showToast(
            gravity: ToastGravity.TOP,
            msg: "Username already exists",
            timeInSecForIosWeb: 3);
      } else {
        doc.add({
          'name': name,
          'password': password,
          'score': 0,
        });

        userName = name;
        this.password = password;
        adsWatched = 0;

        updateNameSharedPref();
        updatePasswordSharedPref();
        updateScoreSharedPref();
      }
    });
  }

  updateFirestore() {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .where('password', isEqualTo: password)
        .get()
        .then((data) {
      if (data.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(data.docs.first.id)
            .update({'score': adsWatched});
        updateScoreSharedPref();
      }
    });
  }

  updateScoreSharedPref() async {
    await sharedPreferencesRepositoryImpl.setScore(adsWatched.toInt());
  }

  updateNameSharedPref() async {
    await sharedPreferencesRepositoryImpl.setuserName(userName ?? '');
  }

  updatePasswordSharedPref() async {
    await sharedPreferencesRepositoryImpl.setPassword(password ?? '');
  }

  fetchUserData() async {
    userName = await sharedPreferencesRepositoryImpl.getuserName();
    password = await sharedPreferencesRepositoryImpl.getPassword();
    adsWatched = await sharedPreferencesRepositoryImpl.getScore() ?? 0;
  }
}
