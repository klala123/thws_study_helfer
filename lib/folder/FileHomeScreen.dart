import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'Folder.dart';
import 'PDFViewerPage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FileHomeScreen extends StatefulWidget {
  final Folder folder;
  final urlPdf = "https://www.africau.edu/images/default/sample.pdf";
  var dio = Dio () ;

  FileHomeScreen({required this.folder});

  @override
  _FileHomeScreenState createState() => _FileHomeScreenState();
}

class _FileHomeScreenState extends State<FileHomeScreen> {
  List<String> _filePaths = [];
  List<String> _fileNames = [];
  DatabaseReference? _fileRef;
  late Map<dynamic, dynamic> files ;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();

  }
  static const platform = MethodChannel('com.example.androidstorage.android_12_flutter_storage/storage');
  Future<void> requestStoragePermission() async {
    try{
      await platform.invokeMethod('requestStoragePermission');
    } on PlatformException catch (e) {
      print(e) ;
    }
  }

  Future<void> _initializeFirebase() async {
    _fileRef = FirebaseDatabase.instance
        .reference()
        .child('folders/${widget.folder.key}/files');
    _getFileList();
  }

  Future<void> _getFileList() async {
    DataSnapshot dataSnapshot = (await _fileRef!.once()).snapshot;
     files = dataSnapshot.value as Map<dynamic, dynamic>;
    files.forEach((key, value) {
      setState(() {
        _filePaths.add(value['path']);
        _fileNames.add(value['name']);
      });
    });
  }

  Future<void> _uploadFile() async {
    await checkAndRequestStoragePermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      Reference storageReference =
      FirebaseStorage.instance.ref().child('folders/${widget.folder.key}/files/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() async {
        // Get download URL and save the file path to Firebase Realtime Database
        String filePath = await storageReference.getDownloadURL();
        DatabaseReference fileRef = _fileRef!.push();
        fileRef.set({'name': fileName, 'path': filePath});
        setState(() {
          _filePaths.add(filePath);
          _fileNames.add(fileName);
        });
      });
    }
  }

  Future<String?> getPublicDownloadPath() async {
    if (Platform.isAndroid) {
      try {
        return '/storage/emulated/0/Download/';
      } catch (e) {
        print('Failed to get public download path: $e');
        return null;
      }
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<void> checkAndRequestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }
    }
    else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) { throw Exception('Storage permission denied');}

  }
@override
Widget build(BuildContext context) {
  double _w = MediaQuery.of(context).size.width;
  double _h = MediaQuery.of(context).size.height;
  double scaleFactor = MediaQuery.of(context).textScaleFactor;
  return Scaffold(
   // backgroundColor: Color(0xFF111010),
    body: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(10),
          right: Radius.circular(10),

        ),
        gradient: LinearGradient(
          colors: [
            // Color(0xFFDADDDF)
            Color(0xFF272928),
            Color(0xFF4D5D68),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(top: _h * 0.1, left: _w * 0.05, right: _w * 0.05, bottom: _w * 0.05),
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: _fileNames.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              delay: Duration(milliseconds: 100),
              child: SlideAnimation(
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeInOutCubic,
                verticalOffset: -850,
                child: FadeInAnimation(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.easeInOutCubic,
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: _h * 0.01, horizontal: _w * 0.05),
                      title: Row(
                          children: [
                            Icon(Icons.insert_drive_file, size: _h * 0.050, color: Colors.white),
                            SizedBox(width: _w * 0.05),
                            Expanded(child: Text(_fileNames[index], style: TextStyle(fontSize: _h * 0.02 * scaleFactor, color: Colors.white))),
  ]
                      ),
                      onTap: () async {
                        final http.Response downloadData =
                        await http.get(Uri.parse(_filePaths[index]));
                        final Directory tempDir = await getApplicationDocumentsDirectory();
                        final File tempFile =
                        File('${tempDir.path}/${_fileNames[index]}');
                        if (tempFile.existsSync()) {
                          await tempFile.delete();
                        }
                        await tempFile.create();
                        final StorageFile =
                        await tempFile.writeAsBytes(downloadData.bodyBytes);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FileViewerPage(file: StorageFile),
                          ), );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _uploadFile,
      child: Icon(Icons.add_comment_rounded  ,
        size: MediaQuery.of(context).size.width* 0.08,),
      backgroundColor: Colors.transparent,
      elevation: 0,
      splashColor: Colors.transparent,
    ),
  );
}
}





