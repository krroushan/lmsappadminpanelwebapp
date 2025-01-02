// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../widgets/widgets.dart';

class AiImageView extends StatefulWidget {
  const AiImageView({super.key});

  @override
  State<AiImageView> createState() => _AiImageViewState();
}

class _AiImageViewState extends State<AiImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.tightFor(width: double.maxFinite),
        margin: EdgeInsets.all(
          responsiveValue<double>(
            context,
            xs: 16,
            lg: 24,
          ),
        ),
        child: ShadowContainer(
          showHeader: false,
          child: Column(
            children: [
              // Header Widget
              Align(
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    const Size.fromWidth(570),
                  ),
                  child: _buildGenerationMethodSelector(context),
                ),
              ),
              const SizedBox(height: 24),

              // Image Grid
              Flexible(
                child: GridView.extent(
                  maxCrossAxisExtent: 230,
                  shrinkWrap: true,
                  childAspectRatio: 250 / 230,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: List.generate(
                    _mockImages.length,
                    (index) {
                      final _image = _mockImages[index];
                      return DownloadableImageCard(
                          imagePath: _image,
                          name: l.S
                              .of(context)
                              .molestiaeQuiaUtCumqueSitNihilIpsamRepellendus
                          // 'Molestiae quia ut cumque sit nihil ipsam repellendus.',
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var generationMethod = AiImageGenerationMethod.textToImage;
  Widget _buildGenerationMethodSelector(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _buttonStyle = OutlinedButton.styleFrom(
      padding: responsiveValue<EdgeInsetsGeometry?>(
        context,
        xs: const EdgeInsets.all(7),
        md: null,
      ),
      visualDensity: const VisualDensity(horizontal: -4),
    );

    final _selectedButtonStyle = _buttonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all<Color?>(
        _theme.colorScheme.primary,
      ),
      foregroundColor: WidgetStateProperty.all<Color?>(
        _theme.colorScheme.onPrimary,
      ),
    );

    bool _isSelectedButton(AiImageGenerationMethod buttonType) {
      return generationMethod == buttonType;
    }

    void _changeSelectedButtonState(AiImageGenerationMethod buttonType) {
      return setState(() => generationMethod = buttonType);
    }

    Widget _buildButton({
      required AiImageGenerationMethod buttonType,
      required String label,
    }) {
      return Flexible(
        child: OutlinedButton(
          onPressed: () => _changeSelectedButtonState(buttonType),
          style: _isSelectedButton(buttonType)
              ? _selectedButtonStyle
              : _buttonStyle,
          child: Text(label),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              buttonType: AiImageGenerationMethod.textToImage,
              //label: 'Text to Image',
              label: lang.textToImage,
            ),
            const SizedBox(width: 16),
            _buildButton(
              buttonType: AiImageGenerationMethod.imageToImage,
              // label: 'Image to Image',
              label: lang.imageToImage,
            ),
          ],
        ),
        SizedBox.square(
          dimension: responsiveValue<double>(
            context,
            xs: 16,
            lg: 20,
          ),
        ),
        if (generationMethod == AiImageGenerationMethod.textToImage)
          TextFormField(
            decoration: InputDecoration(
              //hintText: 'Describe an image you want to Generate...',
              hintText: '${lang.describeAnImageYouWantToGenerate}...',
              suffixIcon: Container(
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    visualDensity: const VisualDensity(vertical: -4),
                  ),
                  //child: const Text('Generate'),
                  child: Text(lang.generate),
                ),
              ),
            ),
          )
        else if (generationMethod == AiImageGenerationMethod.imageToImage)
          DottedBorder(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/widget_images/svg_icons/upload_cloud.svg',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      _theme.colorScheme.onTertiaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      // text: 'Click or drop an image here\n',
                      text: '${lang.clickOrDropAnImageHere}\n',
                      children: [
                        TextSpan(
                          //text: 'Up to 10MB',
                          text: lang.upTo10MB,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _theme.colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: _theme.textTheme.labelLarge,
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}

enum AiImageGenerationMethod { textToImage, imageToImage }

final _mockImages = [
  'assets/images/static_images/ai_generated/images/ai_generated_image_01.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_02.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_03.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_04.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_05.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_06.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_07.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_08.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_09.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_10.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_11.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_12.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_13.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_14.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_15.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_16.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_01.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_02.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_03.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_04.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_05.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_06.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_07.png',
  'assets/images/static_images/ai_generated/images/ai_generated_image_08.png',
];
