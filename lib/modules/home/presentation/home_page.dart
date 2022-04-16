import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safemoon_burn_ads/modules/core/admob/ad_helper.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_assets.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_colors.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_strings.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final HomeStore _store = HomeStore();
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;

  @override
  void initState() {
    super.initState();
    _store.remoteConfig = FirebaseRemoteConfig.instance;
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
    _store.remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: const Duration(seconds: 30)));
    _store.fetchAllData();
    _loadRewardedAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Image.asset(CoreAssets.icLogo, height: 32),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(CoreStrings.title),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: CoreColors.sfmMainColor,
              ),
              onPressed: () => _store.fetchAllData(),
            ),
            IconButton(
              icon: const Icon(
                Icons.info,
                color: CoreColors.sfmMainColor,
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
            _store.remoteConfigString.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Announcement: ' + _store.remoteConfigString,
                        style: const TextStyle(
                            color: CoreColors.sfmMainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                  CoreStrings.raisedMoney +
                      _store.remoteConfigNumber.toString(),
                  style: const TextStyle(
                      color: CoreColors.sfmMainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const Text(CoreStrings.warningText,
                style: TextStyle(
                  color: CoreColors.sfmMainColor,
                  fontSize: 10,
                )),
            const SizedBox(height: 16),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
            const SizedBox(height: 8),
            FloatingActionButton.extended(
              onPressed: () {
                _rewardedAd.show(
                    onUserEarnedReward:
                        (AdWithoutView ad, RewardItem reward) {});
              },
              label: const Text(CoreStrings.watchVideoButton),
              icon: const Icon(Icons.fireplace),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Row(
              children: [
                TextButton(
                  onPressed: () => _store.getPreviousPost(),
                  child: Row(children: [
                    const Icon(
                      Icons.chevron_left,
                      color: CoreColors.sfmMainColor,
                    ),
                    Text(
                      _store.indexCurrentPost == 2
                          ? CoreStrings.lastPostButton
                          : CoreStrings.previousPostButton,
                      style: const TextStyle(
                        color: CoreColors.sfmMainColor,
                        fontSize: 16,
                      ),
                    ),
                  ]),
                ),
                const Spacer(flex: 1),
                _store.currentPost?.link != null
                    ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: CoreStrings.goToLinkButton,
                              style: const TextStyle(
                                  color: CoreColors.blueLinkColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(CoreStrings.redditLink +
                                      (_store.currentPost?.link ??
                                          '/safemoon'));
                                },
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const Spacer(
                  flex: 1,
                ),
                TextButton(
                  onPressed: () => _store.getNextPost(),
                  child: Row(children: [
                    Text(
                      _store.indexCurrentPost < _store.posts.length - 1
                          ? CoreStrings.nextPostButton
                          : CoreStrings.firstPostButton,
                      style: const TextStyle(
                        color: CoreColors.sfmMainColor,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: CoreColors.sfmMainColor,
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
      title: const Text(CoreStrings.dialogTitle),
      content: const Text(CoreStrings.dialogDescription),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(CoreStrings.dialogClose),
        ),
      ],
    );
  }

  _getPostWidget() {
    return Observer(
        builder: (_) => (_store.loading)
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  if (_store.currentPost?.title != null)
                    Text(_store.currentPost?.title ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (_store.currentPost?.description != null)
                    Text(_store.currentPost?.description ?? ""),
                  if (_store.imageFromPost != null)
                    Image.network(_store.imageFromPost),
                ]),
              ));
  }
}
