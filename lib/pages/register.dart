// ignore_for_file: use_build_context_synchronously

import 'package:ecomm/components/mybutton.dart';
import 'package:ecomm/components/mytextfield.dart';
import 'package:ecomm/pages/auth_services.dart';
import 'package:ecomm/pages/loginpage.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});
  final Function()? onTap;

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //sign up method
    // void signUserUp() async {
    //   if (passwordController.text == confirmPasswordController.text) {
    //     try {
    //       UserCredential userCredential = await FirebaseAuth.instance
    //           .createUserWithEmailAndPassword(
    //               email: emailController.text,
    //               password: passwordController.text);

    //       // Create a new document in the "Ecomm Users" collection using the user's UID
    //       await FirebaseFirestore.instance
    //           .collection("Ecomm Users")
    //           .doc(userCredential.user!.email) // Use UID instead of email
    //           .set({
    //         'email': emailController.text,
    //         'username': nameController.text,
    //         'phonenumber': phoneController.text,
    //         'address': addressController.text,
    //         'savedPosts': [],
    //       });

    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => const HomePage()),
    //       );
    //     } catch (error) {
    //       print('Error: $error');
    //       // Handle error here
    //     }
    //   } else {
    //     print('Passwords do not match');
    //     // Handle password mismatch error here
    //   }
    // }

    void signUp() async {
      FocusManager.instance.primaryFocus!.unfocus();
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      }

      await AuthServices().signUpUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phonecontact: phoneController.text,
      );

      Navigator.pop(context);
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 35,
                ),

                const SizedBox(
                  height: 50,
                ),

                //welcome back
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 97, 86, 86),
                    fontSize: 30,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                //name
                MyTextFeild(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),

                //email
                MyTextFeild(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),

                //phone
                MyTextFeild(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),

                //address
                MyTextFeild(
                  controller: addressController,
                  hintText: 'Address',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 25,
                ),

                //password
                MyTextFeild(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),

                //confirm password
                MyTextFeild(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),

                //button
                MyButton(
                  text: "Sign Up",
                  onTap: signUp,
                ),
                const SizedBox(
                  height: 25,
                ),

                //already a member login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a Member? ',
                        style:
                            TextStyle(color: Color.fromARGB(255, 97, 96, 96)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      onTap: () {},
                                    )),
                          );
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              color: Color.fromARGB(255, 30, 137, 236),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
