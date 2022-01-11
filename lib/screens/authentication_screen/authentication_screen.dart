import 'package:code/repositories/auth/repositories.dart';
import 'package:code/screens/authentication_screen/bloc/signin_bloc.dart';
import 'package:code/screens/screens.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'widgets/auth_button.dart';

class AuthenticationScreen extends StatefulWidget {
  static const routename = '/auth_screen';
  const AuthenticationScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routename),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<SigninBloc>(
        child: const AuthenticationScreen(),
        create: (_) =>
            SigninBloc(authRepository: context.read<AuthRepository>()),
      ),
    );
  }

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool checkBox = true;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController number = TextEditingController();
  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninBloc, SigninState>(
          listener: (context, state) {
            if (state.status == SigninStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            } else if (state.status == SigninStatus.sendingOTP) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Sending OTP'),
                duration: Duration(seconds: 2),
              ));
            } else if (state.status == SigninStatus.sentOTP) {
              Navigator.of(context)
                  .pushNamed(PinCodeVerificationScreen.routename,
                      arguments: PinCodeVerificationScreenArgs(
                        phoneNumber: phoneNumber.text,
                      ));
            } else if (state.status == SigninStatus.loading) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Authenticating'),
                duration: Duration(seconds: 2),
              ));
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.grey[300],
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 15,
                    color: Colors.teal[100],
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                'assets/Icons/code.png',
                                fit: BoxFit.cover,
                              ),
                              iconSize: 100,
                              onPressed: null,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            if (checkBox)
                              IntlPhoneField(
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  phoneNumber.text = phone.completeNumber;
                                  number.text = phone.number!;
                                },
                              ),
                            if (checkBox)
                              ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white)),
                                ),
                                onPressed: submit,
                                child: const Text('Send OTP'),
                              ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            if (checkBox)
                              AuthButton(
                                  socialMedia: 'Google',
                                  onPressed: () {
                                    context
                                        .read<SigninBloc>()
                                        .add(SignInWithGoogle());
                                  }),
                            const SizedBox(
                              height: 10.0,
                            ),
                            if (checkBox)
                              AuthButton(
                                  socialMedia: 'GitHub',
                                  onPressed: () {
                                    context.read<SigninBloc>().add(
                                        SignInWithGitHub(context: context));
                                  }),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      checkBox = !checkBox;
                                    });
                                  },
                                  icon: Icon(
                                    checkBox
                                        ? Icons.check_box_outlined
                                        : Icons.check_box_outline_blank,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: Text(
                                    checkBox
                                        ? 'Aceepting our Terms of Service and Privacy Policy. Thanks!'
                                        : 'Please accept our Terms of Service and Privacy Policy. Thank You !!',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: checkBox ? 10 : 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void submit() {
    if (number.text.length == 10) {
      context.read<SigninBloc>().add(
            OTPSignInEvent(phone: phoneNumber.text),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter 10 digits'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
