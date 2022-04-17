import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safemoon_burn_ads/modules/core/constants/core_colors.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';

class RankingTab extends StatefulWidget {
  HomeStore store;

  RankingTab({Key? key, required this.store}) : super(key: key);

  @override
  State<RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'Ranking',
            style: TextStyle(
              color: CoreColors.sfmMainColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder(
            stream: widget.store.getRanking(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return !streamSnapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data?.docs.length ?? 0,
                      itemBuilder: (ctx, index) {
                        int _score = streamSnapshot.data?.docs[index]['score'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 6.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: CoreColors.backgroundChipColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  streamSnapshot.data?.docs[index]['name'],
                                  style: const TextStyle(
                                    color: CoreColors.sfmMainColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _score.toString(),
                                  style: const TextStyle(
                                    color: CoreColors.sfmMainColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                getMedal(index),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ],
      ),
    ));
  }

  Widget getMedal(int index) {
    return index < 3
        ? Icon(Icons.emoji_events_outlined, color: getIndexColor(index))
        : Container();
  }

  Color getIndexColor(index) {
    //create three colors gold silver bronze
    switch (index) {
      case 0:
        return const Color(0xFFFFD700);
      case 1:
        return const Color(0xFFC0C0C0);
      case 2:
        return const Color(0xFFCD7F32);
      default:
        return CoreColors.sfmMainColor;
    }
  }
}
