import 'package:expacto_patronam/Screens/home_screen.dart';
import 'package:expacto_patronam/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "LOGIN_SCREEN";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Color? backgroundColorTheme = Color.lerp(const Color(0xff4b4032), Colors.blueAccent,0.2);
  Color? textColor = const Color(0xff8F7959);
  bool hidePassword = true;
  IconData iconVisiblePassword = Icons.visibility_off_outlined;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF7F3DA),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: SingleChildScrollView(
                child:  Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        width: double.infinity,
                        child: Image.asset("assets/images/login_assets.jpg"),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Your Email";
                          }else if (!value.toString().contains("@")) {
                            return "Invalid Email";
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
                          suffixIcon: IconButton(
                            icon: Icon(iconVisiblePassword),
                            onPressed: () {
                              setState(() {
                                if(hidePassword){
                                  iconVisiblePassword = Icons.visibility;
                                  hidePassword = false;
                                }else {
                                  iconVisiblePassword = Icons.visibility_off;
                                  hidePassword = true;
                                }
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: hidePassword,
                        validator: (value){
                            if(value!.isEmpty){
                              return "Enter Your Password";
                            }else if (value.length < 4) {
                              return "Invalid password";
                            }

                        },

                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                        height: 60,
                        minWidth: double.infinity,
                        color: backgroundColorTheme,
                        textColor: textColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        onPressed: (){
                          logIn();

                        },
                        child: const Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,)),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed(SignUpScreen.routeName);

                        },
                        child: const Text("Don't have an account?"),
                      ),




                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
  logIn(){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      username = emailController.text.trim();
      password = passwordController.text.hashCode.toString();
      signIn();
    }
  }
  Future signIn() async {
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),barrierDismissible: false);
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      ).then((UserCredential value) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      });
    }on FirebaseAuthException catch(e){
      print(e);
      Navigator.of(context).pop();
    }
  }
}
/*
* ,onError: (UserCredential value){
        if(value.user!.email!.isNotEmpty && !value.user!.emailVerified){
          setState(() {
            passwordController.text = "";
          });
          logIn();
        }else{
          setState(() {
            emailController.text = "";
            passwordController.text = "";
          });
          logIn();
      }},
*
*
* */