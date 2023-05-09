import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';


class PdfViewerPage extends StatefulWidget {
  final File file;

  PdfViewerPage({required this.file});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _fileExtension;
  @override
  void initState() {
    super.initState();
    _fileExtension = widget.file.path.split('.').last.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    if ( false ) {
      return Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
        ),
        body: Container (
          //  _openFileWithNativeApp(widget.file.path);
        )
        /*
        PDFView(
          filePath: widget.file.path,
        ),

         */
      );
    } else {
      _openFileWithNativeApp(widget.file.path);
      return Container();
    }
  }

  void _openFileWithNativeApp(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Fehler beim Öffnen der Datei
      print("Fehler beim Öffnen der Datei: ${result.message}");
    }
  }
}

