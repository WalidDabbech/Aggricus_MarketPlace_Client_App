
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/providers/coupon_provider.dart';
import 'package:untitled/providers/location_provider.dart';
import 'package:untitled/providers/order_provider.dart';
import 'package:untitled/providers/store_provider.dart';
import 'package:untitled/screens/cart_screen.dart';
import 'package:untitled/screens/homeScreen.dart';
import 'package:untitled/screens/landing_screen.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/main_screen.dart';
import 'package:untitled/screens/map_screen.dart';
import 'package:untitled/screens/product_details_screen.dart';
import 'package:untitled/screens/product_list_screen.dart';
import 'package:untitled/screens/profile_screen.dart';
import 'package:untitled/screens/profile_update_screen.dart';
import 'package:untitled/screens/splash_screen.dart';
import 'package:untitled/screens/vendor_home_screen.dart';
import 'package:untitled/screens/welcome_screen.dart';
void main() async{
  Provider.debugCheckInvalidValueType =null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (_)=>AuthProvider() ,
      ),
        ChangeNotifierProvider(
          create: (_)=>LocationProvider() ,
        ),
        ChangeNotifierProvider(
          create: (_)=>StoreProvider() ,
        ),
        ChangeNotifierProvider(
          create: (_)=>CartProvider() ,
        ),
        ChangeNotifierProvider(
          create: (_)=>CouponProvider() ,
        ),
        ChangeNotifierProvider(
          create: (_)=>OrderProvider() ,
        )
      ],
  child: MyApp(),),);
}
Map<int, Color> color =
{
  50:Color.fromRGBO(42,183,72, .1),
  100:Color.fromRGBO(42,183,72, .2),
  200:Color.fromRGBO(42,183,72, .3),
  300:Color.fromRGBO(42,183,72, .4),
  400:Color.fromRGBO(42,183,72, .5),
  500:Color.fromRGBO(42,183,72, .6),
  600:Color.fromRGBO(42,183,72, .7),
  700:Color.fromRGBO(42,183,72, .8),
  800:Color.fromRGBO(42,183,72,.9),
  900:Color.fromRGBO(42,183,72, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF84c225, color);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(243, 244, 253,1),
          primaryColor:Color(0xff2ab748),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch:colorCustom
          ).copyWith(
            secondary: Color(0xff2ab748),
          ),
          fontFamily: 'Lato'
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LandingScreen.id:(context)=>LandingScreen(),
        MainScreen.id:(context)=>MainScreen(),
        VendorHomeScreen.id:(context)=>VendorHomeScreen(),
        ProductListScreen.id:(context)=>ProductListScreen(),
        ProductDetailsScreen.id:(context)=>ProductDetailsScreen(),
        CartScreen.id:(context)=>CartScreen(),
        ProfileScreen.id:(context)=>ProfileScreen(),
        UpdateProfile.id:(context)=>UpdateProfile(),



      },
      builder: EasyLoading.init(),
    );
  }
}



