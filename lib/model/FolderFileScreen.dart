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
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
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

  static const platform = MethodChannel('com.example.androidstorage.android_12_flutter_storage/storage');

  Future<void> requestStoragePermission() async {
    try{
      await platform.invokeMethod('requestStoragePermission');
    } on PlatformException catch (e) {
      print(e) ;
    }
  }
//----------------------------------------------------------
  Future<void> _initializeFirebase() async {
    _fileRef = FirebaseDatabase.instance
        .reference()
        .child('folders/${widget.folder.key}/files');
    _getFileList();
  }
//----------------------------------------------------------
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
//----------------------------------------------------------
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

  //----------------------------------------------------------

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

  //----------------------------------------------------------

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  //----------------------------------------------------------
  static Future<File> writeCounter(Uint8List  bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file= File('$path/$name');
    print("Save file");

    // Write the data in the file you have created

      try {
        file.writeAsBytes(bytes);
      } on FileSystemException catch (e) {
        print(" Erorrrrrr ");
      }

    return file.writeAsBytes(bytes);
  }


  //----------------------------------------------------------
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

  //----------------------------------------------------------

/*
  @override
  Widget build(BuildContext context) {

    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    double scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Color(0xFF111010),
      body: Container(
        /*
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hintergrundBild.png'),
            fit: BoxFit.cover,
          ),
        ),

         */
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
                  duration: Duration(milliseconds: 2500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  horizontalOffset: -300,
                  verticalOffset: -850,
                  child: Card(
                    color:  Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: _h * 0.01),
                      title: Row(
                          children: [
                            Icon(Icons.insert_drive_file, size: _h * 0.050, color: Colors.white),
                            SizedBox(width: _w * 0.05),
                            Expanded(child: Text(_fileNames[index], style: TextStyle(fontSize: _h * 0.02 * scaleFactor, color: Colors.white))),
                            IconButton(
                                icon: Icon(Icons.download, color: Colors.white),
                                onPressed: () async {
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
                                }
                            )
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
      floatingActionButton: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double textScaleFactor = MediaQuery.of(context).textScaleFactor;
          double screenHeight = MediaQuery.of(context).size.height;

          return 
            
            Stack(
              children:
              [
              Positioned(
                bottom: screenHeight * 0.02,
                left: screenWidth * 0.73,
                child: Container(
                width: screenWidth * 0.25,
                height: screenWidth * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _uploadFile,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(width: 8),
                        Text(
                          'Datei hochladen',
                          style: TextStyle(color: Colors.white, fontSize: 16 * textScaleFactor),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
              ),
          ]
            );
        },
      ),
    );
  }

 */

@override
Widget build(BuildContext context) {
  double _w = MediaQuery.of(context).size.width;
  double _h = MediaQuery.of(context).size.height;
  double scaleFactor = MediaQuery.of(context).textScaleFactor;

  return Scaffold(
    backgroundColor: Color(0xFF111010),
    body: Container(
      /*
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img_12.png'),
          fit: BoxFit.fill,
        ),
      ),

       */
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
                            IconButton(
                              icon: Icon(Icons.download, color: Colors.white),
                              onPressed: () async {
                                // Berechtigungen überprüfen und anfordern
                                PermissionStatus status = await Permission
                                    .storage.status;
                                if (!status.isGranted) {
                                  status = await Permission.storage.request();
                                }
                                if (status.isGranted) {
                                  // Datei herunterladen
                                  final http.Response downloadData =
                                  await http.get(Uri.parse(_filePaths[index]));
                                  final Directory? downloadDir = Directory('/storage/emulated/0/Download/') ;
                                  //await getExternalStorageDirectory(); // Download-Verzeichnis abrufen
                                  final File downloadFile = File('${downloadDir}${_fileNames[index]}'); // Datei im Download-Ordner erstellen

                                  if (downloadFile.existsSync()) {
                                    await downloadFile.delete();
                                  }
                                  await downloadFile.create(recursive: true);
                                  await downloadFile.writeAsBytes(
                                      downloadData.bodyBytes);

                                  try {
                                    await downloadFile.writeAsBytes(downloadData.bodyBytes);
                                  } on FileSystemException catch (err) {
                                    print (err);
                                  }

                                  // Bestätigungsnachricht anzeigen
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Datei heruntergeladen: ${downloadFile.path}'),
                                      action: SnackBarAction(
                                        label: 'Öffnen',
                                        onPressed: () async {
                                          // Datei-Explorer öffnen und den Download-Ordner anzeigen
                                          final Uri uri = Uri.directory(downloadDir?.path ?? '');
                                          if (await canLaunch(uri.toString())) {
                                            await launch(uri.toString());
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Datei-Explorer kann nicht geöffnet werden'),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );

                                }
                              })
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
                            builder: (context) => PdfViewerPage(file: StorageFile),
                          ),
                        );
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
    floatingActionButton: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double textScaleFactor = MediaQuery.of(context).textScaleFactor;
        double screenHeight = MediaQuery.of(context).size.height;

        return Stack(
          children: [
            Positioned(
              bottom: screenHeight * 0.02,
              left: screenWidth * 0.73,
              child: Container(
                width: screenWidth * 0.25,
                height: screenWidth * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _uploadFile,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          'Datei hochladen',
                          style: TextStyle(color: Colors.white, fontSize: 16 * textScaleFactor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
}





