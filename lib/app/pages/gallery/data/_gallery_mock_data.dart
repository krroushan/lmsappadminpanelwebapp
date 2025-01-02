// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;

class GalleryItemModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<String> tags;

  GalleryItemModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tags,
  });
}

List<GalleryItemModel> get galleryItems {
  return <GalleryItemModel>[
    GalleryItemModel(
      //title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_11.png',
      tags: [
        // "Business",
        l.S.current.business,
        // "Ui",
        l.S.current.UIDesign,
        // "Ux",
        l.S.current.uIUXDesign,
      ],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_12.png',
      tags: [
        // "Personal",
        l.S.current.personal,
        // "Development",
        l.S.current.Development,
      ],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_13.png',
      tags: [
        // "Business",
        l.S.current.business,
        // "Development",
        l.S.current.Development,
      ],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_14.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_15.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_16.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_17.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_18.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_19.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_11.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_12.png',
      tags: [],
    ),
    GalleryItemModel(
      // title: 'This is Image title',
      // subtitle: 'UI Design',
      title: l.S.current.thisIsImageTitle,
      subtitle: l.S.current.UIDesign,
      imageUrl:
          'assets/images/static_images/background_images/background_image_13.png',
      tags: [],
    ),
  ];
}
