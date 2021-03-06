import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:safemoon_burn_ads/modules/core/data/firestore/firestore_service.dart';
import 'package:safemoon_burn_ads/modules/core/data/firestore/models/user_model.dart';
import 'package:safemoon_burn_ads/modules/core/data/shared_preferences/shared_preferences_repository.dart';
import 'package:safemoon_burn_ads/modules/home/domain/models/post_model.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final SharedPreferencesRepositoryImpl sharedPreferencesRepositoryImpl;
  final FirestoreService firestoreService;

  _HomeStore(this.sharedPreferencesRepositoryImpl, this.firestoreService);

  FirebaseRemoteConfig? remoteConfig;

  @observable
  Post? currentPost;
  @observable
  bool loading = false;
  @observable
  bool loadingAd = false;

  @observable
  bool loadingFull = false;

  @observable
  List posts = [];

  int indexCurrentPost = 0;

  @observable
  num adsWatched = 0;

  @observable
  String? userName;
  @observable
  String? password;

  @observable
  num safemoonValue = 0;

  @observable
  num adAverageValue = 0;

  @observable
  num amountRaised = 0;

  @observable
  num amountBurned = 0;
  @observable
  String announcement = "";

  get averageSafemoonBurnedPerAds =>
      (adsWatched * adAverageValue) / safemoonValue;
  @action
  setUserName(name, _password, newUser) {
    loadingAd = true;
    userName = name;
    password = _password;
    newUser ? createUser() : fetchuserScore();
  }

  @action
  Future fetchAllData() async {
    loadingFull = true;
    posts = [];
    currentPost = null;
    indexCurrentPost = 0;
    await getRedditPost();
    await _fetchAndActivate();
    await fetchuserScore();
    loadingFull = false;
  }

  @action
  setSafemoonValue() =>
      safemoonValue = remoteConfig?.getDouble('safemoon_value') ?? 0;
  @action
  setAdAverageValue() =>
      adAverageValue = remoteConfig?.getDouble('cpm') ?? 0.01;
  @action
  setAmountRaised() => amountRaised = remoteConfig?.getDouble('ads_money') ?? 0;
  @action
  setAmountBurned() =>
      amountBurned = remoteConfig?.getDouble('burnt_money') ?? 0;
  @action
  setAnnouncementValue() =>
      announcement = remoteConfig?.getString('quick_news') ?? "";

  @action
  Future _fetchAndActivate() async {
    await remoteConfig?.fetchAndActivate() ?? false;
    setSafemoonValue();
    setAdAverageValue();
    setAmountRaised();
    setAmountBurned();
    setAnnouncementValue();
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
      indexCurrentPost = 0;
    } else {
      indexCurrentPost++;
    }
    currentPost = posts[indexCurrentPost];
  }

  @action
  getPreviousPost() {
    if (indexCurrentPost == 0) {
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
  fetchuserScore() async {
    try {
      if (userName == null || password == null) {
        throw Exception("Please enter a valid username and password");
      } else {
        var _user = firestoreService.fetchUserScore(User(
            name: userName!, password: password!, score: adsWatched.toInt()));
        _user.listen((data) {
          if (data.docs.isNotEmpty) {
            userName = data.docs.first['name'];
            password = data.docs.first['password'];
            updateNameSharedPref(userName ?? '');
            updatePasswordSharedPref(password ?? '');
            updateHigherScore(adsWatched, data.docs.first['score'] ?? 0);
          } else {
            Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
                msg: "Invalid Username or Password",
                timeInSecForIosWeb: 3);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP, msg: e.toString(), timeInSecForIosWeb: 3);
    } finally {
      loadingAd = false;
    }
  }

  updateScore(num reward) async {
    adsWatched += reward;
    var result = await firestoreService.updateUserScore(User(
        name: userName ?? '',
        password: password ?? '',
        score: adsWatched.toInt()));
    if (result) {
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          msg: "Moaaar safemoon burn ????????????",
          timeInSecForIosWeb: 2);
    } else {
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          msg: "Error updating score",
          timeInSecForIosWeb: 2);
    }
  }

  createUser() async {
    try {
      if (userName == null || password == null) {
        throw Exception("Please enter a valid username and password");
      } else {
        var result = await firestoreService.createUser(User(
            name: userName!, password: password!, score: adsWatched.toInt()));
        if (result) {
          await updateNameSharedPref(userName!);
          await updatePasswordSharedPref(password!);
          await updateScoreSharedPref(adsWatched.toInt());
          Fluttertoast.showToast(
              gravity: ToastGravity.BOTTOM,
              msg: "Username created, happy Farming!!!",
              timeInSecForIosWeb: 3);
        } else {
          Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              msg: "Username already exists",
              timeInSecForIosWeb: 3);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP, msg: e.toString(), timeInSecForIosWeb: 3);
      print(e);
    } finally {
      loadingAd = false;
    }
  }

  updateScoreSharedPref(int _adsWatched) async {
    await sharedPreferencesRepositoryImpl.setScore(_adsWatched);
  }

  updateNameSharedPref(String name) async {
    await sharedPreferencesRepositoryImpl.setuserName(name);
  }

  updatePasswordSharedPref(String password) async {
    await sharedPreferencesRepositoryImpl.setPassword(password);
  }

  fetchUserData() async {
    userName = await sharedPreferencesRepositoryImpl.getuserName();
    password = await sharedPreferencesRepositoryImpl.getPassword();
    adsWatched = await sharedPreferencesRepositoryImpl.getScore() ?? 0;
    fetchuserScore();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRanking() {
    return firestoreService.getUsers();
  }

  Future updateHigherScore(num adsWatched, int firebaseScore) async {
    if (adsWatched > firebaseScore) {
      await firestoreService.updateUserScore(User(
          name: userName ?? '',
          password: password ?? '',
          score: adsWatched.toInt()));
    } else if (firebaseScore > adsWatched) {
      this.adsWatched = firebaseScore;
      await updateScoreSharedPref(firebaseScore);
    }
  }
}
