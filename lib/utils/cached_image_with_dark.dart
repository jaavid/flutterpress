import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCacheImageWithDarkFilterFull extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool? circularShape;
  final bool? allPosition;
  const CustomCacheImageWithDarkFilterFull(
      {Key? key, required this.imageUrl, required this.radius, this.circularShape, this.allPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(circularShape == false ? 0 : radius),
        bottomRight: Radius.circular(circularShape == false ? 0 : radius)

      ),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.error),
              ),
            ),
          ),

          Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xaa000000),
                        const Color(0xaa000000),
                        const Color(0xaa000000),
                        const Color(0xaa000000),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class CustomCacheImageWithDarkFilterTopBottom extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool? circularShape;
  final bool? allPosition;
  const CustomCacheImageWithDarkFilterTopBottom(
      {Key? key, required this.imageUrl, required this.radius, this.circularShape, this.allPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(circularShape == false ? 0 : radius),
        bottomRight: Radius.circular(circularShape == false ? 0 : radius)

      ),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.error),
              ),
            ),
          ),

          Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xcc000000),
                        const Color(0x00000000),
                        const Color(0x00000000),
                        const Color(0xcc000000),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}





class CustomCacheImageWithDarkFilterBottom extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool? circularShape;
  final bool? allPosition;
  const CustomCacheImageWithDarkFilterBottom(
      {Key? key, required this.imageUrl, required this.radius, this.circularShape, this.allPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(circularShape == false ? 0 : radius),
        bottomRight: Radius.circular(circularShape == false ? 0 : radius)

      ),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.error),
              ),
            ),
          ),

          Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0x00000000),
                        const Color(0x00000000),
                        const Color(0x00000000),
                        const Color(0xcc000000),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}