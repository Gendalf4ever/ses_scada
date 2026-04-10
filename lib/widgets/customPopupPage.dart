import 'package:flutter/material.dart';
import '../widgets/structures.dart';

class CustomPopupPage extends StatefulWidget {
  final String title;
  final bool showCloseButton;
  final Widget? appbarWidget;
  final Color backgroundColor;
  final Color borderColor;
  final List<Widget> widgetStack;

  const CustomPopupPage({
    super.key,
    required this.title,
    this.showCloseButton = true,
    this.appbarWidget,
    this.backgroundColor = Colors.black,
    this.borderColor = Colors.blue,
    required this.widgetStack,
  });

  @override
  State<CustomPopupPage> createState() => _CustomPopupPageState();
}

class _CustomPopupPageState extends State<CustomPopupPage> {
  @override
  Widget build(BuildContext context) {
    final maxHeight = screenHeight * 0.8;
    const fontSize = 18.0;
    const appBarHeight = 64.0;
    const padding = 12.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: widget.borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AppBar row
              Container(
                height: appBarHeight,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: widget.borderColor, width: 1.5),
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    // Left: close button or empty spacer
                    SizedBox(
                      width: appBarHeight,
                      child: widget.showCloseButton
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: widget.borderColor,
                                size: fontSize * 2.2,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            )
                          : null,
                    ),
                    // Center: title
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize * 2,
                          ),
                        ),
                      ),
                    ),
                    // Right: optional widget or empty spacer to balance title
                    SizedBox(
                      width: appBarHeight,
                      child: widget.appbarWidget != null
                          ? Center(child: widget.appbarWidget)
                          : null,
                    ),
                  ],
                ),
              ),
              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.widgetStack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
