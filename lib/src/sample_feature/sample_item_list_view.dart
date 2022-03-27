import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safemoon_burn_ads/src/ad_helper.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SampleItemListView extends StatefulWidget {
  SampleItemListView({Key? key}) : super(key: key);

  static const routeName = '/';
  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;
  List<String> _currentPost = [];
  dynamic _Posts = [];
  int indexCurrentPost = 2;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  Future<void> didChangeDependencies() async {
    await getRedditPost();
    _loadRewardedAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _rewardedAd.dispose();
    super.dispose();
  }

  getRedditPost() async {
    var response = await http.get(Uri(
        scheme: 'https', host: 'www.reddit.com', path: '/r/safemoon/.json'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _Posts = data['data']['children'];
      setCurrentPost();
    }
  }

  getNextPost() {
    setState(() {
      _currentPost.clear();

      if (indexCurrentPost == _Posts.length - 1) {
        indexCurrentPost = 2;
      } else {
        indexCurrentPost++;
      }
    });

    // print(indexCurrentPost.toString() + ' ' + _Posts.length.toString());
    setCurrentPost();
  }

  getPreviousPost() {
    setState(() {
      _currentPost.clear();

      if (indexCurrentPost == 2) {
        indexCurrentPost = _Posts.length - 1;
      } else {
        indexCurrentPost--;
      }
    });

    // print(indexCurrentPost.toString() + ' ' + _Posts.length.toString());
    setCurrentPost();
  }

  setCurrentPost() {
    var currentElement = _Posts[indexCurrentPost];
    String title = currentElement['data']['title'];
    String? thumbnail = currentElement['data']['thumbnail'] == 'self'
        ? null
        : currentElement['data']['thumbnail'];
    String? picture = currentElement['data']['url_overridden_by_dest'];
    String selftext = currentElement['data']['selftext'];
    String? img =
        (picture?.contains('.jpg') == true || picture?.contains('.png') == true)
            ? picture
            : thumbnail;
    String link = currentElement['data']['url'] ?? '';
    setState(() {
      _currentPost.add(title);
      _currentPost.add(img ?? "");
      _currentPost.add(selftext);
      _currentPost.add(link);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/images/safemoon.png', height: 32),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text('Safemoon Burn by Ads'),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Color(0xFF04998F),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
            SizedBox(height: 8),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Let\'s burn some safemoon?'),
                      content: Text('Watch an Ad to BUUUUURN safemoon!'),
                      actions: [
                        TextButton(
                          child: Text('cancel'.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('ok'.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                            _rewardedAd.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem reward) {},
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              label: Text('Click to watch a video'),
              icon: Icon(Icons.fireplace),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Row(
              children: [
                TextButton(
                  onPressed: () => getPreviousPost(),
                  child: Row(children: [
                    const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF04998F),
                    ),
                    Text(
                      indexCurrentPost == 2 ? 'Last Post' : 'Previous Post',
                      style: const TextStyle(
                        color: Color(0xFF04998F),
                        fontSize: 16,
                      ),
                    ),
                  ]),
                ),
                Spacer(
                  flex: 1,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Go to Post',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(_currentPost[3]);
                          },
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                TextButton(
                  onPressed: () => getNextPost(),
                  child: Row(children: [
                    Text(
                      indexCurrentPost < _Posts.length - 1
                          ? 'Next Post'
                          : 'First Post',
                      style: TextStyle(
                        color: Color(0xFF04998F),
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFF04998F),
                    ),
                  ]),
                ),
              ],
            ),
            _getPostWidget(),
          ],
        ),
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('🔥🔥 Safemoon Burn Ads 🔥🔥'),
      content: const Text(
          '''Inspired by the Spotify burn playlist \nI've made this small app to help us to burn some safemoon faster.\nßEvery month I'll be getting the revenue from ads and sinking into the burn wallet.'''),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  _getPostWidget() {
    return (_currentPost.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(_currentPost[0],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(_currentPost[2]),
              if (_currentPost.length > 1 && _currentPost[1].isNotEmpty)
                Image.network(_currentPost[1]),
            ]),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
