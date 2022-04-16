import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_colors.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_strings.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';

class adTab extends StatefulWidget {
  bool isBannerReady = false;
  bool isRewardedAdReady = false;
  HomeStore store;
  BannerAd bannerAd;
  RewardedAd? rewardedAd;
  RewardedInterstitialAd? interstitialRewardedAd;
  Function(RewardItem) onAdRewarded;

  adTab(
      {Key? key,
      required this.isBannerReady,
      required this.isRewardedAdReady,
      required this.store,
      required this.bannerAd,
      required this.rewardedAd,
      required this.interstitialRewardedAd,
      required this.onAdRewarded})
      : super(key: key);

  @override
  State<adTab> createState() => _adTabState();
}

class _adTabState extends State<adTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          getAnnouncement(),
          getAmountChips(),
          const SizedBox(height: 16),
          if (widget.isBannerReady)
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: widget.bannerAd.size.width.toDouble(),
                height: widget.bannerAd.size.height.toDouble(),
                child: AdWidget(ad: widget.bannerAd),
              ),
            ),
          const SizedBox(height: 24),
          getRewardedVideoAd(),
          const SizedBox(height: 24),
          getInterstitialAd(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  getAnnouncement() {
    return widget.store.remoteConfigString.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: CoreColors.backgroundChipColor,
              ),
              child: Text(widget.store.remoteConfigString,
                  style: const TextStyle(
                      color: CoreColors.sfmMainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          )
        : Container();
  }

  getAmountChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: CoreColors.backgroundChipColor,
          ),
          child: Text(
              CoreStrings.raisedMoney +
                  widget.store.getAmountRaised.toStringAsFixed(2),
              style: const TextStyle(
                  color: CoreColors.sfmMainColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: CoreColors.backgroundChipColor,
          ),
          child: Text(
              CoreStrings.burnedMoney +
                  widget.store.getAmountBurned.toStringAsFixed(2),
              style: const TextStyle(
                  color: CoreColors.sfmMainColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget getInterstitialAd() {
    return FloatingActionButton.extended(
      onPressed: () {
        widget.interstitialRewardedAd?.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          widget.onAdRewarded(reward);
        });
      },
      label: const Text(CoreStrings.watchInterstitialButton),
      icon: const Icon(Icons.monetization_on),
    );
  }

  Widget getRewardedVideoAd() {
    return FloatingActionButton.extended(
      onPressed: () {
        widget.rewardedAd?.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          widget.onAdRewarded(reward);
        });
      },
      label: const Text(CoreStrings.watchVideoButton),
      icon: const Icon(Icons.fireplace),
    );
  }
}
