import 'package:code/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code/repositories/repositories.dart';
import 'package:code/widgets/widget.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'bloc/signin_bloc.dart';

class PinCodeVerificationScreenArgs {
  final String phoneNumber;
  PinCodeVerificationScreenArgs({
    required this.phoneNumber,
  });
}

class PinCodeVerificationScreen extends StatefulWidget {
  static const routename = '/pincode_screen';

  static Route route({required PinCodeVerificationScreenArgs args}) {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routename),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<SigninBloc>(
        child: PinCodeVerificationScreen(phoneNumber: args.phoneNumber),
        create: (_) =>
            SigninBloc(authRepository: context.read<AuthRepository>()),
      ),
    );
  }

  final String phoneNumber;
  const PinCodeVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  int time = otpDuration;

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(235, 236, 237, 1),
    borderRadius: BorderRadius.circular(5.0),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
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
                context: (context),
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            } else if (state.status == SigninStatus.verifyOTP) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Verifying! Please Wait'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state.status == SigninStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Yay !! Verified'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.grey[300],
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 15,
                      color: Colors.teal[100],
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 8),
                            const Text(
                              'Phone Number Verification',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Enter the OTP sent to ",
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 15),
                                children: [
                                  TextSpan(
                                    text: widget.phoneNumber,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: PinPut(
                                useNativeKeyboard: true,
                                withCursor: true,
                                fieldsCount: 6,
                                fieldsAlignment: MainAxisAlignment.spaceAround,
                                textStyle: const TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                                eachFieldMargin: const EdgeInsets.all(1),
                                eachFieldWidth: 45.0,
                                eachFieldHeight: 55.0,
                                focusNode: _pinPutFocusNode,
                                controller: textEditingController,
                                submittedFieldDecoration: pinPutDecoration,
                                selectedFieldDecoration:
                                    pinPutDecoration.copyWith(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromRGBO(160, 215, 220, 1),
                                  ),
                                ),
                                followingFieldDecoration: pinPutDecoration,
                                pinAnimationType: PinAnimationType.fade,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CountdownTimer(
                              endTime: DateTime.now().millisecondsSinceEpoch +
                                  1000 * time,
                              widgetBuilder: (_, time) {
                                if (time == null) {
                                  return const Center(child: Text('Time Up !'));
                                }
                                return RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: "Time Remaining : ",
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: "${time.sec} seconds",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Didn't receive the code?  ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    context.read<SigninBloc>().add(
                                        OTPSignInEvent(
                                            phone: widget.phoneNumber));
                                    setState(() {
                                      time = otpDuration;
                                    });
                                  },
                                  child: const Text(
                                    "RESEND",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            ElevatedButton(
                              onPressed: submit,
                              child: Center(
                                  child: Text(
                                "VERIFY".toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  child: const Text("Clear"),
                                  onTap: () {
                                    textEditingController.clear();
                                  },
                                ),
                                GestureDetector(
                                  child: const Text("Cancel"),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
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
    if (textEditingController.text.length == 6) {
      context
          .read<SigninBloc>()
          .add(OTPVerifyEvent(otp: textEditingController.text));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the cells'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
