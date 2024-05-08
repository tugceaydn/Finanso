import 'package:flutter/material.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';

class StyledButton extends StatelessWidget {
  final void Function()? handlePress;
  final String text;
  final String? type;
  final dynamic icon;
  final bool isDisabled;
  final bool? isActive;

  const StyledButton({
    super.key,
    required this.handlePress,
    required this.text,
    this.type,
    this.icon,
    this.isDisabled = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'secondary':
        return FilledButton(
          onPressed: isDisabled ? null : handlePress,
          style: Theme.of(context).filledButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(double.maxFinite),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  isDisabled ? textSmoke : Colors.black,
                ),
              ),
          child: Stack(
            alignment: const Alignment(1, 0),
            children: [
              Center(
                child: StyledText(
                  text: text,
                  type: 'button',
                ),
              ),
              icon ?? Container(),
            ],
          ),
        );
      case 'tertiary':
        return FilledButton(
          onPressed: isDisabled ? null : handlePress,
          style: Theme.of(context).filledButtonTheme.style!.copyWith(
                backgroundColor: MaterialStatePropertyAll(
                  isActive! ? primary : primarySmoke,
                ),
              ),
          child: Stack(
            alignment: const Alignment(1, 0),
            children: [
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    height: 1.0,
                    color: isActive! ? Colors.white : Colors.black,
                  ),
                ),
              ),
              icon ?? Container(),
            ],
          ),
        );
      case 'delete':
        return FilledButton(
          onPressed: isDisabled ? null : handlePress,
          style: Theme.of(context).filledButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(double.maxFinite),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  isDisabled ? redBackground : redBackground,
                ),
              ),
          child: Stack(
            alignment: const Alignment(1, 0),
            children: [
              Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    height: 1.0,
                    color: redSolid,
                  ),
                ),
              ),
              icon ?? Container(),
            ],
          ),
        );
      default:
        return FilledButton(
          onPressed: isDisabled ? null : handlePress,
          style: Theme.of(context).filledButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(double.maxFinite),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  isDisabled
                      ? primarySmoke
                      : isActive!
                          ? primary
                          : Colors.white,
                ),
              ),
          child: Stack(
            alignment: const Alignment(1, 0),
            children: [
              Center(
                child: StyledText(
                  text: text,
                  type: 'button',
                  color: isActive! ? Colors.white : Colors.black,
                ),
              ),
              icon ?? Container(),
            ],
          ),
        );
    }
  }
}
