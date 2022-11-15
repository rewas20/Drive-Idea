import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/user.dart';
import 'package:expacto_patronam/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SignUpScreen extends StatefulWidget {
  static const routeName = "SIGNUP_SCREEN";
  const SignUpScreen({Key? key}) : super(key: key);


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String userName = "";
  String userID = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Color? backgroundColorTheme = Color.lerp(const Color(0xff4b4032), Colors.blueAccent,0.2);
  Color? textColor = const Color(0xff8F7959);
  bool hidePassword = true;
  IconData iconVisiblePassword = Icons.visibility_off_outlined;
  String showPassword = "show password";
  double padTop = 50;

  @override
  void dispose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F3DA),

      body: Container(
          padding: EdgeInsets.only(left: 25,right: 25,top: padTop),
          child: Center(
            child: SingleChildScrollView(
              child:  Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        onTap: ()=> setState(() {
                           padTop = 100;
                        }),
                        onEditingComplete: ()=> setState(() {
                           padTop = 0;
                        }),
                      controller: userNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: "Enter username",
                        prefixIcon: const Icon(Icons.drive_file_rename_outline),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a username";
                        } else if (value.length < 6) {
                          return "username must be at least 5 characters";
                        }
                      }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onTap: ()=> setState(() {
                        padTop = 100;
                      }),
                      onEditingComplete: ()=> setState(() {
                         padTop = 0;
                      }),
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value){
                        if(value!.isEmpty){
                          return "A valid phone is required";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onTap: ()=> setState(() {
                        padTop = 100;
                      }),
                      onEditingComplete: ()=> setState(() {
                        padTop = 0;
                      }),
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value!.isEmpty){
                          return "A valid email is required";
                        }else if(!value.contains("@gmail.com")) {
                          return "A valid email is with gmail";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(

                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.vpn_key),
                        suffixIcon: Icon(iconVisiblePassword),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: hidePassword,
                      validator: (value){
                        if(value!.isEmpty){
                          return "A password is required";
                        }else if(value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onTap: ()=> setState(() {
                        padTop = 0;
                      }),
                      controller: passwordConfirmController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: "Confirm Password",
                        prefixIcon: const Icon(Icons.vpn_key),

                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: hidePassword,
                      validator: (value){
                        if(value!.isEmpty){
                          return "A password is required here to";
                        }
                        else if(value!=passwordController.text.trim()){
                          return "Password doesn't match";
                        }
                      },
                    ),

                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (){
                          setState(() {
                            if(hidePassword){
                              showPassword = "hide password";
                              iconVisiblePassword = Icons.visibility;
                              hidePassword = false;
                            }else {
                              showPassword = "show password";
                              iconVisiblePassword = Icons.visibility_off;
                              hidePassword = true;
                            }
                          });
                        },
                        child: Text(showPassword),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      color: backgroundColorTheme,
                      textColor: textColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      onPressed: (){
                        createAccount();
                        //Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: const Text("Create",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,)),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text("I already have an account"),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
  createAccount(){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      userName = userNameController.text.trim();
      phoneNumber = phoneNumberController.text.trim();
      email = emailController.text.trim();
      password = passwordController.text.hashCode.toString();
      signUp();
    }
  }
  Future signUp() async{
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),barrierDismissible: false);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        Fluttertoast.showToast(msg: "Successful Created");
        userID = value.user!.uid;
          users.doc(userID).set(UserAccount(userId: userID, userName: userName, phoneNumber: phoneNumber, email: email, password: password).getMap());
      });
    }on FirebaseAuthException catch(e){
      print(e);
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Failed");
    }
  }
}
