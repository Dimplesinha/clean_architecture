import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:workapp/src/presentation/common_widgets/common_widgets_exports.dart';

class WorkAppWebView extends StatefulWidget {
  final String url;

  const WorkAppWebView({Key? key, required this.url}) : super(key: key);

  @override
  _WorkAppWebViewState createState() => _WorkAppWebViewState();
}

class _WorkAppWebViewState extends State<WorkAppWebView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final pdfUrl =
        'https://docs.google.com/gview?embedded=true&url=${widget.url}';

    return Scaffold(
      appBar: const MyAppBar(title: 'PDF Viewer'),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.url.endsWith('.pdf') ? pdfUrl : widget.url),
            ),
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load URL: $message')),
              );
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
