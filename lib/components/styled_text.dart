import 'package:flutter/material.dart';
import 'package:stock_market/core/app_themes.dart';

class StyledText extends StatelessWidget {
  final String text;
  final String? type;
  final Color? color;
  final int? maximumLines;

  const StyledText(
      {super.key,
      required this.text,
      this.type,
      this.color,
      this.maximumLines = 50});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'header':
        return Text(
          text,
          style:
              header.copyWith(color: color ?? const Color.fromRGBO(0, 0, 0, 1)),
          maxLines: maximumLines,
        );

      case 'title_bold':
        return Text(
          text,
          style: titleBold.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
          maxLines: maximumLines,
        );
      case 'title':
        return Text(
          text,
          style: title.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
          maxLines: maximumLines,
        );
      case 'caption':
        return Text(
          text,
          style: caption.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
          maxLines: maximumLines,
        );
      case 'button':
        return Text(
          text,
          style: button.copyWith(
            color: color ?? const Color.fromRGBO(255, 255, 255, 1),
          ),
          maxLines: maximumLines,
        );
      case 'functional':
        return Text(
          text,
          style: functional.copyWith(
            color: color ?? textSmoke,
          ),
          maxLines: maximumLines,
        );
      case 'small':
        return Text(
          text,
          style: small.copyWith(
            color: color ?? textSmoke,
          ),
          maxLines: maximumLines,
        );
      case 'body_smoke':
        return Text(
          text,
          style: bodySmoke.copyWith(
            color: color ?? textSmoke,
          ),
          maxLines: maximumLines,
        );
      default:
        return Text(
          text,
          style: body.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
          maxLines: maximumLines,
          overflow: TextOverflow.ellipsis,
        );
    }
  }
}
