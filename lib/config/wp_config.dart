class WpConfig {
  static const String websiteUrl = "https://kermaneno.ir";
  //FEATURE TAG ID
  static const int featuredTagID = 5;
  //VIDEO TAG ID
  static const int videoTagId = 21672;

  // Hometab 4 categories
  // -- 'Serial Number' : [Category Id, 'Category Name'] -- Length should be 4.
  static const Map selectedCategories = {
    '1': [382, "ویژه"],
    '2': [326, "۲۰:۲۰"],
    '3': [347, "حوادث"],
    '4': [332, "سیاست"],
  };

  /*
  List of blocked categories. Do nothing if you don't want to block any categories.
  If you want to bloc any category and it's posts then enter values like these:
  Example: If you want to block category id 10 & 12, then it will be look like this:
    static const String blockedCategoryIds = "10,12";
    static const String blockedCategoryIdsforPopularPosts = "-10,-12";

  */

  static const String blockedCategoryIds = "";
  static const String blockedCategoryIdsforPopularPosts = "";

  // FEATURE IMGAE -  IF YOUR POSTS DON"T HAVE A FEATURE IMAGE
  static const String randomPostFeatureImage =
      "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png";

  // FEATURE CATEGORY IMGAE -  IF YOU HAVEN'T DEFINE A COVER IMAGE FOR A CATEGORY IN THE LIST BELOW
  static const String randomCategoryThumbnail =
      "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png";

  // ENTER CATERGORY ID AND ITS COVERS IMAGE
  // 306
  //   310
  //   347
  //   332
  //   346
  //   348
  static const Map categoryThumbnails = {
    // categoryID : 'category thumbnail url'
    306:
        "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png",
    310:
        "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png",
    347:
        "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png",
    332:
        "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png",
    346:
        "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png",
    348:
        "https://kermaneno.ir/wp-content/uploads/2020/05/cropped-kerman-noghosh1.png",
  };
}
