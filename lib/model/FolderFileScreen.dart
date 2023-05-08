import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;


import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'Folder.dart';
import 'PDFViewerPage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';


class FolderFilesScreen extends StatefulWidget {
  final Folder folder;
  final urlPdf = "https://www.africau.edu/images/default/sample.pdf";
  var dio = Dio () ;

  FolderFilesScreen({required this.folder});

  @override
  _FolderFilesScreenState createState() => _FolderFilesScreenState();
}

class _FolderFilesScreenState extends State<FolderFilesScreen> {
  List<String> _filePaths = [];
  List<String> _fileNames = [];
  DatabaseReference? _fileRef;
  late Map<dynamic, dynamic> files ;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();

  }
  Future<void> _requestDownloadPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.storage.request();
      if (!newStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Zugriff auf den Download-Ordner wurde verweigert'),
          ),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Zugriff auf den Download-Ordner wurde gewährt'),
          ),
        );
      }
    }
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // Upload file to Firebase Storage
      Reference storageReference =
      FirebaseStorage.instance.ref().child('folders/${widget.folder.key}/files/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        // Get download URL and save the file path to Firebase Realtime Database
        String filePath = await storageReference.getDownloadURL();
        DatabaseReference fileRef = _fileRef!.push();
        fileRef.set({'name': fileName, 'path': filePath});

        // Update the list of files in the UI
        setState(() {
          _filePaths.add(filePath);
          _fileNames.add(fileName);
        });
      });
    }
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }
  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(Uint8List  bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file= File('$path/$name');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
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

  Future<void> downloadFileExample(String fileName ) async {
    await _requestDownloadPermission();
    final directory = await getExternalStorageDirectory();
    final path =  '${directory?.path}/Downloads';
    final downloadFolder = Directory(path);
    if (!await downloadFolder.exists()) {
      await downloadFolder.create(recursive: true);
    }

    print (" Glala  ${path}");
    try {
      final storageReference = FirebaseStorage.instance.ref().child('files/$fileName');
      final downloadUrl = await storageReference.getDownloadURL();

      //final http.Client httpClient = http.Client();

      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode != 200) {
        throw 'Error: Failed to download file with status code ${response.statusCode}';
      }

      final Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
      print("Tess  ${downloadsDirectory?.path}");
      final File file = File('$path/$fileName');

      await file.writeAsBytes(response.bodyBytes);

      print('File downloaded and saved: ${file.path}');
    } on PlatformException catch (e) {
      print('Error: Failed to download and save file. $e');
    }
  }

  /*
   await _requestDownloadPermission();
    final directory = await getExternalStorageDirectory();
    final path =  '${directory?.path}/Downloads';
    final downloadFolder = Directory(path);
    if (!await downloadFolder.exists()) {
      await downloadFolder.create(recursive: true);
    }

    print (" Glala  ${path}");
    try {
      final storageReference = FirebaseStorage.instance.ref().child('files/$fileName');
      final downloadUrl = await storageReference.getDownloadURL();

      //final http.Client httpClient = http.Client();

      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode != 200) {
        throw 'Error: Failed to download file with status code ${response.statusCode}';
      }

      final Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
      print("Tess  ${downloadsDirectory?.path}");
      final File file = File('$path/$fileName');

      await file.writeAsBytes(response.bodyBytes);

      print('File downloaded and saved: ${file.path}');
    } on PlatformException catch (e) {
      print('Error: Failed to download and save file. $e');
    }
   */

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hintergrundBild.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimationLimiter(
          child: ListView.builder(
           // padding: EdgeInsets.all(_w / 30),
            padding: EdgeInsets.only(top: 100, left: _w / 30, right: _w / 30, bottom: _w / 30),

            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: _fileNames.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                delay: Duration(milliseconds: 100),
                child: SlideAnimation(
                  duration: Duration(milliseconds: 2500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  horizontalOffset: -300,
                  verticalOffset: -850,
                  child: Card(
                   color:  Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                     // leading: Icon(Icons.insert_drive_file),

                      title:
                      Row(
                        children: [
                          Icon(Icons.insert_drive_file, size: 50, color: Colors.white),
                          SizedBox(width: 16),
                          Expanded(child: Text(_fileNames[index] , style: TextStyle(fontSize: 15, color: Colors.white),)
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.white),
                              onPressed: () async {
                                downloadFileExample(_fileNames[index]);

                              }

                          )

                        ]

                      ),
                      onTap: () async {
                        // Download the file from Firebase Storage
                        final http.Response downloadData =
                        await http.get(Uri.parse(_filePaths[index]));
                        final Directory tempDir = await getTemporaryDirectory();
                        final File tempFile =
                        File('${tempDir.path}/${_fileNames[index]}');
                        if (tempFile.existsSync()) {
                          await tempFile.delete();
                        }
                        await tempFile.create();
                        final StorageFile =
                        await tempFile.writeAsBytes(downloadData.bodyBytes);

                        // Open the file using PdfViewerPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerPage(file: StorageFile),
                          ),
                        );
                      },
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
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }


}
