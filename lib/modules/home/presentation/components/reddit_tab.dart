import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_colors.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_strings.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';
import 'package:url_launcher/url_launcher.dart';

class redditTab extends StatefulWidget {
  HomeStore store;
  redditTab({Key? key, required this.store}) : super(key: key);

  @override
  State<redditTab> createState() => _redditTabState();
}

class _redditTabState extends State<redditTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () => widget.store.getPreviousPost(),
              child: Row(children: [
                const Icon(
                  Icons.chevron_left,
                  color: CoreColors.sfmMainColor,
                ),
                Text(
                  widget.store.indexCurrentPost == 2
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
            widget.store.currentPost?.link != null
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: CoreStrings.goToLinkButton,
                          style:
                              const TextStyle(color: CoreColors.blueLinkColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(CoreStrings.redditLink +
                                  (widget.store.currentPost?.link ??
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
              onPressed: () => widget.store.getNextPost(),
              child: Row(children: [
                Text(
                  widget.store.indexCurrentPost < widget.store.posts.length - 1
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _getPostWidget(),
        ),
        const SizedBox(height: 16),
      ],
    ));
  }

  _getPostWidget() {
    return Observer(
        builder: (_) => (widget.store.loading)
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: CoreColors.backgroundChipColor,
                ),
                child: Column(children: [
                  if (widget.store.currentPost?.title != null)
                    Text(widget.store.currentPost?.title ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CoreColors.sfmMainColor,
                        )),
                  const SizedBox(height: 16),
                  if (widget.store.currentPost?.description != null)
                    Text(widget.store.currentPost?.description ?? ""),
                  if (widget.store.imageFromPost != null)
                    Image.network(widget.store.imageFromPost),
                ]),
              ));
  }
}
