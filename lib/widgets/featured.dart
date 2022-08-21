import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:kermaneno/cards/feature_card.dart';
import 'package:kermaneno/utils/loading_card.dart';
import '../blocs/featured_bloc.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Featured extends StatefulWidget {
  const Featured({Key? key}) : super(key: key);

  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  @override
  Widget build(BuildContext context) {
    final fb = context.watch<FeaturedBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: PageView.builder(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            itemCount: fb.articles.isEmpty ? 1 : fb.articles.length,
            onPageChanged: (int pageIndex) =>
                context.read<FeaturedBloc>().saveDotIndex(pageIndex),
            itemBuilder: (BuildContext context, int index) {
              if (fb.articles.isEmpty) {
                if (fb.hasData) {
                  return _LoadingWidget();
                } else {
                  return _NoContentsWidget();
                }
              }
              return FeatureCard(
                  article: fb.articles[index],
                  heroTag: 'featured${fb.articles[index].id}');
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(0),
          child: DotsIndicator(
            dotsCount: fb.articles.isEmpty ? 1 : fb.articles.length,
            position: fb.dotIndex.toDouble(),
            decorator: DotsDecorator(
              activeColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.secondary,
              spacing: EdgeInsets.all(3),
              size: const Size.square(5),
              activeSize: const Size(20.0, 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoContentsWidget extends StatelessWidget {
  const _NoContentsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(5)),
      child: Text('no contents found').tr(),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: LoadingCard(height: null),
    );
  }
}
