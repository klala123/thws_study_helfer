import 'dart:io';
import 'package:flutter/material.dart';
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
    WidgetsBinding.instance!.addPostFrameCallback((_) => _openFileAndPop(context, widget.file.path));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _openFileAndPop(BuildContext context, String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Fehler beim Öffnen der Datei
      print("Fehler beim Öffnen der Datei: ${result.message}");
    }
    Navigator.pop(context);
  }
}
