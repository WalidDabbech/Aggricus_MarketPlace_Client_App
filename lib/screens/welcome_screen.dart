import 'package:flutter/material.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/location_provider.dart';
import 'package:untitled/screens/map_screen.dart';
import 'package:untitled/screens/onboard_screen.dart';
import 'package:provider/provider.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id ='welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    final _phoneNumberController = TextEditingController();
    void showBottomSheet(context){
      showModalBottomSheet(
        context:context,
        isScrollControlled: true,
        builder:(context)=>StatefulBuilder(
          builder: (context,StateSetter myState){
            return SingleChildScrollView(
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
                            myState((){
                              _validPhoneNumber =true;
                            });
                          }else{
                            myState((){
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
                                    myState((){
                                      auth.loading=true;
                                    });
                                    final String number = '+216${_phoneNumberController.text}';
                                    auth.verifyPhone(
                                        context: context,
                                        number:number).then((value) {
                                      _phoneNumberController.clear();
                                      auth.loading=false;

                                    });
                                  },
                                  style: TextButton.styleFrom(backgroundColor: _validPhoneNumber? Theme.of(context).primaryColor : Colors.grey,),
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
            );
          },
        ),
      ).whenComplete((){
        setState(() {
          auth.loading=false;
          _phoneNumberController.clear();

        });
      });
    }
    final locationData = Provider.of<LocationProvider>(context,listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
             child:  TextButton(
               onPressed:(){},
               child: Text('SKIP',style: TextStyle(color: Theme.of(context).primaryColor),),
             ),
            ),
            Column(
              children: [
                Expanded(child: OnBaordScreen(),),
                Text('Ready to order from your nearest shop?',style: TextStyle(color: Colors.grey),),
                SizedBox(height: 20,),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,),
                  onPressed: () async{
                      if (mounted) {
                        setState(() {
                          locationData.loading = true;

                        });
                      }

                   await locationData.getCurrentPosition();
                   if(locationData.permissionAllowed==true){
                     Navigator.pushReplacementNamed(context, MapScreen.id);
                          if (mounted) {
                     setState(() {
                       locationData.loading=false;

                     });
                          }
                   }
                   else
                     {
                       print('Permission not allowed');
                       if (mounted) {
                         setState(() {
                           locationData.loading = false;
                         });
                       }
                     }
                  },
                  child: locationData.loading ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white) ,
                  ) : Text('SET DELIVERY LOCATION',
                    style: TextStyle(color: Colors.white),),
                ),

                TextButton(
                  onPressed: (){
                     if (mounted) {
                       setState(() {
                         auth.screen = 'Login';
                       });
                     }
                    showBottomSheet(context);
                  },
                  child: RichText(
                    text: TextSpan(
                    text: 'Already a customer ?', style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          text: 'Login',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orangeAccent)
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
