import 'package:flutter/material.dart';
import 'package:stock_market/core/app_themes.dart';

class StyledText extends StatelessWidget {
  final String text;
  final String? type;
  final Color? color;

  const StyledText({
    super.key,
    required this.text,
    this.type,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'header':
        return Text(
          text,
          style:
              header.copyWith(color: color ?? const Color.fromRGBO(0, 0, 0, 1)),
        );
      case 'title_bold':
        return Text(
          text,
          style: titleBold.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
        );
      case 'title':
        return Text(
          text,
          style: title.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
        );
      case 'caption':
        return Text(
          text,
          style: caption.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
        );
      case 'button':
        return Text(
          text,
          style: button.copyWith(
            color: color ?? const Color.fromRGBO(255, 255, 255, 1),
          ),
        );
      case 'functional':
        return Text(
          text,
          style: functional.copyWith(
            color: color ?? textSmoke,
          ),
        );
      case 'small':
        return Text(
          text,
          style: small.copyWith(
            color: color ?? textSmoke,
          ),
        );
      case 'body_smoke':
        return Text(
          text,
          style: bodySmoke.copyWith(
            color: color ?? textSmoke,
          ),
        );
      default:
        return Text(
          text,
          style: body.copyWith(
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          ),
        );
    }
  }
}
