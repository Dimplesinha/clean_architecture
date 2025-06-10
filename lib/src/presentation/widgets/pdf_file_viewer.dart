import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfFileViewer extends StatelessWidget {
  final String filePath;

  PdfFileViewer({super.key, required this.filePath});

  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      child: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        pageFling: false,
        onError: (error) {
          if (kDebugMode) {
            print(error.toString());
          }
        },
        onPageError: (page, error) {
          if (kDebugMode) {
            print('$page: ${error.toString()}');
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onPageChanged: (int? page, int? total) {
          if (kDebugMode) {
            print('$page / $total');
          }
        },
      ),
    );
  }
}
