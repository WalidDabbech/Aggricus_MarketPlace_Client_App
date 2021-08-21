import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/location_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id='login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Visibility(
                    visible: auth.error=='Invalid OTP'?true:false,
                    child: Container(
                      child:Column(
                        children: [
                          Text(auth.error,style: TextStyle(color:Colors.red,fontSize:12,  ),),
                          SizedBox(height: 5,),
                        ],
                      ) ,
                    ),
                  ),
                  Text('LOGIN',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),),
                  Text('Enter your phone number to process',style:TextStyle(fontSize: 12,color: Colors.grey,),),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      prefixText: '+216',
                      labelText: '8 digit mobile number',
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 8,
                    controller: _phoneNumberController,
                    onChanged: (value){
                      if(value.length==8)
                      {
                        setState((){
                          _validPhoneNumber =true;
                        });
                      }else{
                        setState((){
                          _validPhoneNumber =false;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: _validPhoneNumber ? false:true,
                          child: TextButton(
                              onPressed:(){
                                setState((){
                                  auth.loading=true;
                                  auth.screen ='MapScreen';
                                  auth.latitude=locationData.latitude;
                                  auth.longitude=locationData.longitude;
                                  auth.address=locationData.selectedAddress.addressLine;

                                });
                                final String number = '+216${_phoneNumberController.text}';
                                auth.verifyPhone(
                                    context: context,
                                    number: number
                                ).then((value) {
                                  _phoneNumberController.clear();
                                  setState(() {
                                    auth.loading=false;
                                  });
                                });

                              },
                              style: TextButton.styleFrom(backgroundColor:  _validPhoneNumber? Theme.of(context).primaryColor : Colors.grey),
                              child: auth.loading ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ):Text(_validPhoneNumber ? 'CONTINUE':'ENTER PHONE NUMBER',style: TextStyle(color: Colors.white),)
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
