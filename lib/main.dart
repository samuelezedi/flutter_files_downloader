import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController url = TextEditingController();
  TextEditingController fileName = TextEditingController();
  TextEditingController fileType = TextEditingController();
  GlobalKey formKey = GlobalKey();

  bool downloading = false;
  String progressString = "";

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try{
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(url.text, "${dir.path}/downloads/${fileName}", onReceiveProgress: (rec,total){
        print("Rec: $rec, total: $total");
        setState(() {
          downloading = true;
          progressString = ((rec/total) * 100).toStringAsFixed(0) + " %";
        });
      });

    }catch(e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('File Downloader'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text('Enter link below'),
                TextFormField(
                  controller: url,
                  keyboardType: TextInputType.url,
                  validator: (value){
                    if(value.trim() == ""){
                      return 'Please enter a valid url';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Link',
                    hintText: 'Enter link'
                  ),

              ),
              TextFormField(
                controller: fileName,
                keyboardType: TextInputType.text,
                validator: (value){
                  if(value.trim() == ""){
                    return 'Please enter a name';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'File name',
                    hintText: 'Enter name'
                ),

              ),
              TextFormField(
                controller: fileType,
                keyboardType: TextInputType.text,
                validator: (value){
                  if(value.trim() == "" || value.trim() != 'jpeg' || value.trim() != 'png' || value.trim() != 'jpg'){
                    return 'Please enter a valid file type';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Type',
                    hintText: 'accepts. jpg, pdf, jpeg'
                ),

              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        tooltip: 'Download file',
        child: Icon(Icons.file_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  loading() {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text('Downloading file...')
            ],
          ),
        )
    );
  }
}
