
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workapp/src/core/constants/api_constants.dart';
import 'package:workapp/src/core/constants/app_colors.dart';
import 'package:workapp/src/core/constants/assets_constants.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';
import 'package:workapp/src/core/constants/model_keys.dart';
import 'package:workapp/src/core/constants/route_constants.dart';
import 'package:workapp/src/core/routes/app_router.dart';

/// @AUTHOR: Prakash Software Solutions Pvt Ltd
/// @DATE: 19/09/24
/// @Message: Refactored MessageTail widget for chat container with dynamic bubble sizing

class MessageTail extends StatelessWidget {
  final bool isSender;
  final String text;
  final bool hasTail;
  final Color bubbleColor;
  final TextStyle textStyle;
  final BoxConstraints? constraints;
  final int? messageStatus;
  final VoidCallback? onLinkTapped;

  const MessageTail({
    super.key,
    required this.isSender,
    required this.text,
    required this.hasTail,
    required this.bubbleColor,
    required this.textStyle,
    this.constraints,
    this.messageStatus,
    this.onLinkTapped,
  });

  Future<void> _handleLink(String url, BuildContext context, {String? initialMessageText}) async {
    try {
      final uri = Uri.parse(url);
      final baseHost = ApiConstant.baseUriDynamic;

      if ('https://${uri.host}' == baseHost) {
        int? listingId;
        String? category;

        final pathSegments = uri.pathSegments;
        for (int i = 0; i < pathSegments.length; i++) {
          if (pathSegments[i].toLowerCase() == 'listing-detail') {
            if (i + 1 < pathSegments.length) {
              listingId = int.tryParse(pathSegments[i + 1]);
              if (i + 2 < pathSegments.length) {
                category = pathSegments[i + 2];
              }
            }
            break;
          }
        }

        if (listingId != null) {
          final category = extractCategoryFromText(initialMessageText ?? '');
          print(category);

          AppRouter.push(AppRoutes.itemDetailsViewRoute, args: {
            ModelKeys.itemId: listingId,
            ModelKeys.category: '',
          });
        } else {
          AppRouter.push(AppRoutes.homeScreenRoute);
        }
      } else {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        }
      }
    } catch (e) {
      debugPrint('Error handling link: $e');
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    }
  }

  bool containsHtml(String text) {
    // Regular expression to detect HTML tags
    final RegExp htmlRegExp = RegExp(r'<[^>]+>');

    // Returns true if the text contains HTML tags
    return htmlRegExp.hasMatch(text);
  }

  // Function to update the color in the HTML string
  String updateHtmlColor(String text, bool isSender) {
    final RegExp styleRegExp = RegExp(r'style="([^"]*)"', caseSensitive: false);
    final color = isSender ? '#FFFFFF' : '#000000';

    if (styleRegExp.hasMatch(text)) {
      // If there's a style attribute, replace or append the color
      return text.replaceAllMapped(styleRegExp, (match) {
        String styleContent = match.group(1)!;
        if (styleContent.contains('color:')) {
          // Replace existing color
          final colorRegExp = RegExp(r'color:\s*#[0-9A-Fa-f]{6}');
          return 'style="${styleContent.replaceAll(colorRegExp, 'color: $color')}"';
        } else {
          // Append color to existing style
          return 'style="$styleContent; color: $color"';
        }
      });
    } else if (text.contains('<a')) {
      // If there's an <a> tag but no style, add style attribute
      return text.replaceAllMapped(RegExp(r'<a([^>]*)>'), (match) {
        return '<a${match.group(1)} style="color: $color">';
      });
    }
    // Return unchanged if no style or <a> tag to modify
    return text;
  }

  String? extractCategoryFromText(String text) {
    // Look for the phrase "Please reply to this "
    const marker = 'Please reply to this ';
    final startIndex = text.indexOf(marker);
    if (startIndex != -1) {
      final substring = text.substring(startIndex + marker.length);
      // Find the next <br> or end of category
      final endIndex = substring.indexOf('<br>');
      if (endIndex != -1) {
        return substring.substring(0, endIndex).trim();
      }
      return substring.trim(); // Fallback if no <br> is found
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: CustomPaint(
          painter: ChatBubblePainter(
            color: bubbleColor,
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            hasTail: hasTail,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            constraints: constraints ??
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Html(
                      data: updateHtmlColor(text, isSender),
                      onLinkTap: (link, _, __) {
                         onLinkTapped?.call();
                        _handleLink(link ?? '', context, initialMessageText: text);
                      },
                      style: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          color: isSender ? AppColors.whiteColor : AppColors.blackColor,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          textDecoration: TextDecoration.none,
                        ),
                        'html': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                        'p': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                        'a': Style(
                          color: isSender ? AppColors.whiteColor : AppColors.blackColor,
                          textDecoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                        ),
                      },
                    )
                  ),
                  const SizedBox(width: 5),
                  if (isSender) ...[
                    SvgPicture.asset(
                      _getMessageStatusIcon(),
                      width: 15,
                      height: 10,
                      fit: BoxFit.contain,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMessageStatusIcon() {
    if (messageStatus == MessageStatus.read.value) {
      return AssetPath.messageReadIcon;
    } else if (messageStatus == MessageStatus.delivered.value) {
      return AssetPath.messageDeliveredIcon;
    }
    return AssetPath.messageSentIcon;
  }
}

class ChatBubblePainter extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool hasTail;

  const ChatBubblePainter({
    required this.color,
    required this.alignment,
    required this.hasTail,
  });

  static const double _radius = 10.0;
  static const double _tailOffset = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final bubblePath = Path();

    if (alignment == Alignment.centerRight) {
      // Sender bubble: tail on bottom right
      bubblePath.addRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          size.width - (hasTail ? _tailOffset : 0),
          size.height,
          topLeft: const Radius.circular(_radius),
          topRight: const Radius.circular(_radius),
          bottomLeft: const Radius.circular(_radius),
          bottomRight: const Radius.circular(_radius),
        ),
      );
      if (hasTail) {
        bubblePath.moveTo(size.width - _tailOffset - 10, size.height);
        bubblePath.lineTo(size.width - _tailOffset, size.height - 15);
        bubblePath.lineTo(size.width + 5, size.height);
        bubblePath.close();
      }
    } else {
      // Receiver bubble: tail on top left
      bubblePath.addRRect(
        RRect.fromLTRBAndCorners(
          hasTail ? _tailOffset : 0,
          0,
          size.width,
          size.height,
          topLeft: const Radius.circular(_radius),
          topRight: const Radius.circular(_radius),
          bottomLeft: const Radius.circular(_radius),
          bottomRight: const Radius.circular(_radius),
        ),
      );
      if (hasTail) {
        bubblePath.moveTo(_tailOffset + 8, 0);
        bubblePath.lineTo(10, 15);
        bubblePath.lineTo(-5, 0);
        bubblePath.close();
      }
    }

    canvas.drawPath(bubblePath, paint);
  }

  @override
  bool shouldRepaint(covariant ChatBubblePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.alignment != alignment ||
        oldDelegate.hasTail != hasTail;
  }
}