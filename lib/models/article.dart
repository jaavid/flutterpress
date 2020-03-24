import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Article {
  final int id;
  final String title;
  final String content;
  final String lid;
  final String image;
  final String thumb;
  final String bigimage;
  final String category;
  final String date;
  final String link;
  final int catId;
  String format(Date d) {
    final f = d.formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yy}';
  }
  Article({
    this.id,
    this.title,
    this.content,
    this.lid,
    this.image,
    this.thumb,
    this.bigimage,
    this.category,
    this.date,
    this.link,
    this.catId
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    String content  = json['content'] != null ? json['content']['rendered'] : "";
    String lid      = json['excerpt'] != null ? json['excerpt']['rendered'] : "";
    String image    = json['_embedded']['wp:featuredmedia'][0] != null ? json['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url'] : "https://kermaneno.com/wp-content/uploads/2016/05/cropped-kerman-noghosh.png";
    String thumb    = json['_embedded']['wp:featuredmedia'][0] != null ? json['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['publisher-tall-big']['source_url'] : "https://kermaneno.com/wp-content/uploads/2016/05/cropped-kerman-noghosh-150x150.png";
    String bigimage = json['_embedded']['wp:featuredmedia'][0] != null ? json['_embedded']['wp:featuredmedia'][0]['source_url'] : "https://kermaneno.com/wp-content/uploads/2016/05/cropped-kerman-noghosh.png";
    String category = json['_embedded']['wp:term'][0][0]['name'] != null ? json['_embedded']['wp:term'][0][0]['name'] : "اخبار";
    int catId       = json['_embedded']['wp:term'][0][0]['id'] != null ? json['_embedded']['wp:term'][0][0]['id'] : 0;
//    String date     = DateFormat('dd MMMM, yyyy', 'en_US').format(DateTime.parse(json["date"])).toString();
    Jalali j        = Jalali.fromDateTime(DateTime.parse(json["date"]));
    final f         = j.formatter;
    String date     = '${f.d} ${f.mN} ${f.yy}';

    print(json['id']);
    print(image);
    print(thumb);
    print(bigimage);
    return Article(
        id        : json['id'],
        title     : json['title']['rendered'],
        content   : content,
        lid       : lid,
        image     : image,
        thumb     : thumb,
        bigimage  : bigimage,
        category  : category,
        date      : date,
        link      : json['link'],
        catId     : catId
    );
  }

  factory Article.fromDatabaseJson(Map<String, dynamic> data) => Article(
      id        : data['id'],
      title     : data['title'],
      content   : data['content'],
      lid       : data['lid'],
      image     : data['image'],
      thumb     : data['thumb'],
      bigimage  : data['bigimage'],
      category  : data['category'],
      date      : data['date'],
      link      : data['link'],
      catId     : data['catId']
  );

  Map<String, dynamic> toDatabaseJson() => {
        'id'      : this.id,
        'title'   : this.title,
        'content' : this.content,
        'lid'     : this.lid,
        'image'   : this.image,
        'thumb'   : this.thumb,
        'category': this.category,
        'date'    : this.date,
        'link'    : this.link,
        'catId'   : this.catId
      };
}