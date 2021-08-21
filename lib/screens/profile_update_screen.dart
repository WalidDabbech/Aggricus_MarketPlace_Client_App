import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/services/user_services.dart';

class UpdateProfile extends StatefulWidget {
static const String id ='update-profile';
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  User ? user = FirebaseAuth.instance.currentUser;
  final UserServices _user = UserServices();
  final _formKey = GlobalKey<FormState>();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var mobile = TextEditingController();
  var email = TextEditingController();

  updateProfile(){
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'firstName' : firstName.text,
      'lastName' : lastName.text,
      'email' : email.text,
    });
  }

  @override
      void initState() {
      _user.getUserById(user!.uid).then((value) {
        if ( mounted ){
          setState(() {
            firstName.text = value['firstName'];
            lastName.text = value['lastName'];
            email.text  = value['email'];
            mobile.text = user!.phoneNumber!;
          });
        }
      });
        super.initState();
      }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text('Update Profile',style: TextStyle(color: Colors.white),),
      ),
      bottomSheet: InkWell(
        onTap: (){
         if(_formKey.currentState!.validate()){
           EasyLoading.show(status:'Updating profile....');
           updateProfile().then((value){
             EasyLoading.showSuccess('Updated Successfully');
             Navigator.pop(context);
           });
         }
        },
        child: Container(
          color: Colors.blueGrey[900],
          width: double.infinity,
          height: 56,
          child: Center(child: Text('Update',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key:_formKey,
          child: Column(
            children: [
                Row(
                  children: [
                    Expanded(child:TextFormField(
                      controller: firstName,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                        labelText: 'First Name',
                        labelStyle: TextStyle (color:Colors.grey),
                        contentPadding: EdgeInsets.zero
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter first name';
                        }
                        return null;
                      },
                    )),
                    SizedBox(width: 20,),
                    Expanded(child:TextFormField(
                      controller: lastName,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                          labelText: 'Last Name',
                          labelStyle: TextStyle (color:Colors.grey),
                          contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter last name';
                        }
                        return null;
                      },
                    ),
                    ),
                  ],
                ),
              SizedBox(width: 40,),
              TextFormField(
                controller: mobile,
                cursorColor: Theme.of(context).primaryColor,
                enabled: false,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  labelText: 'Mobile',
                  labelStyle: TextStyle (color:Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter Mobile';
                  }
                  return null;
                },
              ),
              SizedBox(width: 40,),
              TextFormField(
                controller: email,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  labelText: 'Eamil',
                  labelStyle: TextStyle (color:Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter Email';
                  }
                  return null;
                },
              ),
              ],
          ),
        ),
      ),
    );
  }
}
