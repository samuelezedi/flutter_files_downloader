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
  BuildContext context;
  TextEditingController url = TextEditingController();
  TextEditingController fileName = TextEditingController();
  TextEditingController fileType = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FocusNode textFieldFocus = FocusNode();

  bool downloading = false;
  String progressString = "";

  Future<void> downloadFile() async {
    textFieldFocus.unfocus();
    setState(() {
      downloading = true;
    });
    Dio dio = Dio();

    try{
      var dir = await getApplicationDocumentsDirectory();
      var path = "${dir.path}/downloads/${fileName.text}.${fileType.text}";

      await dio.download(url.text, path, onReceiveProgress: (rec,total){
        setState(() {
          progressString = ((rec/total) * 100).toStringAsFixed(0) + " %";
        });
      });
    successful(path);
    }catch(e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "";
    });
  }

  successful(path) {
    return Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Download Succesful, you can find your downloaded file here ${path}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white
            ),
          ),
          duration: Duration(seconds: 20),
        )
    );
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
      body: Builder(
        builder: (context) {
          this.context = context;
          return Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Text('Enter link below'),
                    TextFormField(
                      focusNode: textFieldFocus,
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
                    focusNode: textFieldFocus,
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
                    focusNode: textFieldFocus,
                    controller: fileType,
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value.trim() == "" && (value.trim() != 'jpeg' || value.trim() != 'png' || value.trim() != 'jpg')){
                        return 'Please enter a valid file type';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Type',
                        hintText: 'accepts. jpg, pdf, jpeg'
                    ),

                  ),
                  SizedBox(height: 20,),
                  downloading ? ListTile(
                        leading : CircularProgressIndicator(),
                        title: Text(progressString,style: TextStyle(color: Colors.black),)
                  ) : Offstage(),
                ],
              ),
            )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(formKey.currentState.validate()){
            formKey.currentState.save();
            downloadFile();
          }
        },
        tooltip: 'Download file',
        child: Icon(Icons.file_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
