import 'package:delivery_boy/core/view_model/auth_view_model/auth_view_model_provider.dart';
import 'package:delivery_boy/ui/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var authModel = watch(authViewModelProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Theme(
        data: ThemeData.dark().copyWith(
          accentColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: authModel.phoneNumberController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone Number", prefixText: "+91 "),
                      ),
                    ),
                    authModel.phoneLoading
                        ? CircularProgressIndicator()
                        : OutlinedButton(
                            style: Theme.of(context).textButtonTheme.style,
                            onPressed: () {
                              authModel.startPhoneAuth(
                                onVerify: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrdersPage(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Send OTP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: authModel.smsController,
                  enabled: authModel.otpSent,
                  autofocus: true,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "OTP",
                  ),
                ),
              ),
              authModel.loading
                  ? CircularProgressIndicator()
                  : MaterialButton(
                      color: Theme.of(context).primaryColor,
                      colorBrightness: Brightness.light,
                      onPressed: authModel.otpSent
                          ? () async {
                              var user =
                                  await authModel.verifyOtp();
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrdersPage(),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text("VERIFY"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
