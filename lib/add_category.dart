import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String baseUrl = 'mobileweek10.000webhostapp.com';


class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  
  void update(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(text)));
  }
  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        centerTitle: true,
      ),
      body: Center(
          child: Form(
        key: _formkey,
        child: Column(children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
           
            child: TextFormField(
              controller: _controllerID,
              validator: (value)=>((value==null || value.isEmpty)? 'Please Enter Id':null),
              decoration: const InputDecoration(
                  hintText: 'Enter Id', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,

            child: TextFormField(
              controller: _controllerName,
              validator: (value)=>((value==null || value.isEmpty)? 'Please Enter Name':null),
              decoration: const InputDecoration(
                  hintText: 'Enter Name', border: OutlineInputBorder()),
            ),
          ),
           const SizedBox(height: 10),
           ElevatedButton(onPressed: (){
            if(_formkey.currentState!.validate()){
               saveCategory(update,int.parse(_controllerID.text), _controllerName.text);
            }
           }, child:const Text('Save')),
        ]),
      )),
    );
  }
}


void saveCategory(Function(String) update,int cid,String name)async{
  try{
   final url=Uri.https(baseUrl,'save.php');
   final response= await http.post(url,
   headers: <String,String>{'content-type':'application/json;charset=UTF-8'},
   body: convert.jsonEncode(<String,String>{
    'cid':'$cid','name':name,'key':'123'
   })).timeout(const Duration(seconds: 10));

   if(response.statusCode==200){
    update(response.body);
   }
  }catch(e){
    update('Connection Error');
  }
}