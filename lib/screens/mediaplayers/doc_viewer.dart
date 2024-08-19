import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String url;

  const PdfViewer({
    super.key,
    required this.url,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController( );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: Colors.white,
      body: SfPdfViewer.network(
      
        widget.url,
        controller: _pdfViewerController,
      ),
    );
  }
}
