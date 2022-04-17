import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safemoon_burn_ads/modules/core/admob/ad_helper.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_assets.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_colors.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_strings.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/components/ad_tab.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/components/ranking_tab.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/components/reddit_tab.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeStore _store = Modular.get();
  late BannerAd bannerAd;
  bool isBannerReady = false;
  RewardedAd? rewardedAd;
  RewardedInterstitialAd? interstitialRewardedAd;
  bool isRewardedAdReady = false;

  @override
  void initState() {
    super.initState();
    _store.remoteConfig = FirebaseRemoteConfig.instance;
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerReady = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  @override
  Future<void> didChangeDependencies() async {
    _store.remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: const Duration(seconds: 30)));
    _loadInterstitialRewardedAd();
    _loadRewardedAd();
    _store.fetchAllData();
    await _store.fetchUserData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    rewardedAd?.dispose();
    interstitialRewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.local_fire_department)),
                Tab(icon: Icon(Icons.reddit_outlined)),
                Tab(icon: Icon(Icons.emoji_events_outlined)),
              ],
            ),
            title: Row(
              children: [
                Image.asset(CoreAssets.icLogo, height: 32),
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    CoreStrings.title,
                    style: TextStyle(color: CoreColors.sfmMainColor),
                  ),
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
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },
              ),
            ]),
        body: Observer(
          builder: (_) {
            return _store.loadingFull
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      adTab(
                          isBannerReady: isBannerReady,
                          isRewardedAdReady: isRewardedAdReady,
                          store: _store,
                          bannerAd: bannerAd,
                          rewardedAd: rewardedAd,
                          interstitialRewardedAd: interstitialRewardedAd,
                          onAdRewarded: (RewardItem reward) {
                            _store.updateScore(reward.amount);
                          },
                          setUserName:
                              (String name, String password, bool newUser) =>
                                  _store.setUserName(name, password, newUser)),
                      Observer(builder: (_) => redditTab(store: _store)),
                      Observer(builder: (_) => RankingTab(store: _store)),
                    ],
                  );
          },
        ),
      ),
    );
  }

  void _loadInterstitialRewardedAd() {
    RewardedInterstitialAd.load(
        request: AdRequest(),
        adUnitId: AdHelper.interstitialAdUnitId,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            interstitialRewardedAd = ad;
            print('$ad loaded.');
            setState(() {
              isRewardedAdReady = false;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Failed to load a rewarded ad: ${error.message}');
            setState(() {
              isRewardedAdReady = false;
            });
          },
        ));
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            isRewardedAdReady = false;
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
}
