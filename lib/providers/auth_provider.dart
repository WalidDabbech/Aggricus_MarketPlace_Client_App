import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/providers/location_provider.dart';
import 'package:untitled/screens/landing_screen.dart';
import 'package:untitled/screens/main_screen.dart';
import 'package:untitled/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
late String smsOtp;
late String verificationId;
String error='';
late String screen;
final UserServices _userServices = UserServices();
bool loading = false ;
LocationProvider locationData = LocationProvider();
double? latitude;
double? longitude;
String? address;
String? location;
DocumentSnapshot? snapshot;

  Future <void> verifyPhone ({ required BuildContext context, required String number}) async{
    loading=true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      loading=false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
        loading=false;
        print(e.code);
        error=e.toString();
        notifyListeners();
      };
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      smsOtpDialog(context,number);

    };
    try{
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },);
      
    }
    catch(e){
      error=e.toString();
      loading=false;
      notifyListeners();
      print(e);

    }

  }
  Future<bool>?smsOtpDialog(BuildContext context , String number ) async{
    return await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(height: 6,),
                Text('Enter 6 digit OTP received as SMS',
                  style: TextStyle(color: Colors.grey,fontSize: 12),)
              ],
            ),
            content:Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center ,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged:(value){
                  smsOtp = value;
                } ,
              ),
            ) ,
            actions: [
              TextButton(onPressed:()async{
                try{
                  final PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: smsOtp);
                  final User? user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                  if(user!=null){
                      loading=false;
                      notifyListeners();
                      _userServices.getUserById(user.uid).then((snapShot) {
                        if(snapShot.exists){
                          if (screen=='Login'){
                            if(snapShot['address']!=null){
                              Navigator.pushReplacementNamed(context, MainScreen.id);
                            }

                            Navigator.pushReplacementNamed(context, LandingScreen.id);
                          }
                          else {
                            updateUser(id: user.uid, number: user.phoneNumber.toString());
                            Navigator.pushReplacementNamed(
                                context, MainScreen.id);
                          }
                        }
                        else {
                            _createUser(id: user.uid, number: user.phoneNumber.toString());
                            Navigator.pushReplacementNamed(context, LandingScreen.id);
                        }
                      });

                  }
                  else {
                    print('Login Failed');
                  }

                }
                catch(e){
                  error='Invalid OTP';
                  print(e.toString());
                  Navigator.of(context).pop();

                }
              },
                  child: Text('DONE',style: TextStyle(color: Theme.of(context).primaryColor),),
              )
            ],
          );
        }).whenComplete(() {
          loading=false;
          notifyListeners();
    });
  }
  void _createUser({required String id , required String number }) {
   _userServices.createUserData({
     'id':id,
     'number':number,
     'latitude':latitude,
     'longitude':longitude,
     'address':address,
     'location':location,
     'firstName':null,
     'lastName' : null,
      'email' : null,
      'userName': null
   });
   loading=false;
   notifyListeners();
}
  Future<bool> updateUser(
      {required String id ,
        required String number })async{
   try{
     _userServices.updateUserData({
       'id':id,
       'number':number,
       'latitude':latitude,
       'longitude':longitude,
       'address':address,
       'location':location

     });
     loading=false;
     notifyListeners();
     return true;
   }
   catch(e){
      print('Error $e');
      return false;
   }
  }

  getUserDetails() async{
    final DocumentSnapshot  result = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
    if (result.exists ){
      snapshot = result;
      notifyListeners();
    }
    else {
      snapshot = null;
      notifyListeners();
    }
    return result;
  }
}

