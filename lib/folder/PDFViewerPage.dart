import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class FileViewerPage extends StatefulWidget {
  final File file;
  FileViewerPage({required this.file});
  @override
  _FileViewerPageState createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
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
      print("Fehler beim Öffnen der Datei: ${result.message}");
    }
    Navigator.pop(context);
  }
}
