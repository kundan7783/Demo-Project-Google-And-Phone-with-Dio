import 'package:demo_phone_google_auth/bloc/auth/auth_bloc.dart';
import 'package:demo_phone_google_auth/bloc/auth/auth_event.dart';
import 'package:demo_phone_google_auth/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerifyScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.data.message ?? 'Success')),
            );
            final profileExists = state.data.profileExists ?? false;
            if (profileExists) {
              context.goNamed('home');
            } else {
              context.goNamed('profile');
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Verification",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    "Enter the code send to the number",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "+91 ${widget.phoneNumber}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                PinCodeTextField(
                  controller: otpController,
                  appContext: context,
                  length: 6,
                  animationType: AnimationType.fade,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 55,
                    fieldWidth: 50,
                    activeColor: Colors.blue,
                    selectedColor: Colors.blue,
                    inactiveColor: Colors.grey.shade400,

                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.grey.shade100,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  onChanged: (value) {},
                ),
                const Spacer(),

                /// Submit Bottom
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    onPressed: () async {
                      if (otpController.text.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter valid OTP")),
                        );
                        return;
                      }
                      context.read<AuthBloc>().add(
                        VerifyOtpEvent(widget.phoneNumber, otpController.text),
                      );
                    },

                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
