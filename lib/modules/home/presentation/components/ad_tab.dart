import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  Function(String, String, bool) setUserName;

  adTab({
    Key? key,
    required this.isBannerReady,
    required this.isRewardedAdReady,
    required this.store,
    required this.bannerAd,
    required this.rewardedAd,
    required this.interstitialRewardedAd,
    required this.onAdRewarded,
    required this.setUserName,
  }) : super(key: key);

  @override
  State<adTab> createState() => _adTabState();
}

class _adTabState extends State<adTab> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Observer(
              builder: (_) => widget.store.userName != null
                  ? getClickTracker()
                  : getInputUser()),
          const SizedBox(height: 16),
          Observer(builder: (_) => getAnnouncement()),
          const SizedBox(height: 16),
          Observer(builder: (_) => getAmountChips()),
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
    return widget.store.announcement.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: CoreColors.backgroundChipColor,
              ),
              child: Text(widget.store.announcement,
                  style: const TextStyle(
                      color: CoreColors.sfmMainColor,
                      fontSize: 12,
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
                  widget.store.amountRaised.toStringAsFixed(2),
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
                  widget.store.amountBurned.toStringAsFixed(2),
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

  getClickTracker() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: CoreColors.backgroundChipColor,
      ),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: widget.store.userName,
            style: const TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        const TextSpan(
            text: CoreStrings.counterBeginText,
            style: TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        TextSpan(
            text: widget.store.adsWatched.toString(),
            style: const TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
        const TextSpan(
            text: CoreStrings.counterEndText,
            style: TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 10,
            )),
        TextSpan(
            text: widget.store.averageSafemoonBurnedPerAds.toStringAsFixed(2) +
                ' SFM',
            style: const TextStyle(
                color: CoreColors.sfmMainColor,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ])),
    );
  }

  getInputUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            maxLength: 16,
            controller: usernameController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: usernameController.clear,
                icon: const Icon(Icons.clear),
              ),
              hintText: CoreStrings.userNameHint,
              hintStyle: const TextStyle(
                color: CoreColors.sfmMainColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: CoreColors.sfmMainColor,
                  width: 2,
                ),
              ),
            ),
            style: const TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            textAlign: TextAlign.center,
            controller: passwordController,
            obscureText: obscureText,
            maxLength: 9,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
              ),
              hintText: CoreStrings.passwordHint,
              hintStyle: const TextStyle(
                color: CoreColors.sfmMainColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: CoreColors.sfmMainColor,
                  width: 2,
                ),
              ),
            ),
            style: const TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            onSubmitted: (String value) => handleLogin(false),
          ),
          const SizedBox(height: 8),
          widget.store.loadingAd
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: CoreColors.backgroundChipColor,
                        ),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => handleLogin(true),
                          child: const Text(CoreStrings.createAccountButton),
                        )),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: CoreColors.sfmMainColor,
                      ),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => handleLogin(false),
                        child: const Text(
                          CoreStrings.submitButton,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  handleLogin(bool isNewUser) {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      widget.setUserName(
          usernameController.text, passwordController.text, isNewUser);
    }
  }
}
