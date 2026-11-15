import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/generic_lib/widgets/picture_not_found.dart';
import 'package:smooth_app/helpers/launch_url_helper.dart';

/// Card that displays a Knowledge Panel _Image_ element.
class KnowledgePanelImageCard extends StatelessWidget {
  const KnowledgePanelImageCard({required this.imageElement});

  final KnowledgePanelImageElement imageElement;

  @override
  Widget build(BuildContext context) {
    final double? width = imageElement.width?.toDouble();
    final double? height = imageElement.height?.toDouble();

    final Widget image = Image.network(
      imageElement.url,
      width: width,
      height: height,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: width,
          height: height ?? (width == null ? 100.0 : null),
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return Container(
          width: width,
          height: height ?? (width == null ? 100.0 : null),
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          child: const PictureNotFound(style: PictureNotFoundStyle.sad),
        );
      },
    );
    final String? linkUrl = imageElement.linkUrl;
    if (linkUrl == null) {
      return image;
    }
    return InkWell(
      onTap: () => LaunchUrlHelper.launchURL(linkUrl),
      child: image,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('url', imageElement.url));
    properties.add(IntProperty('width', imageElement.width));
    properties.add(IntProperty('height', imageElement.height));
  }
}
