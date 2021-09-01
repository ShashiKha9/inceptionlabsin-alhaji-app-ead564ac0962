import 'package:alhaji_user_app/utils/phone-number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '/provider/auth.dart';
import '/provider/session.dart';
import '/utils/commons.dart';
import '/utils/timer_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller = TextEditingController();
  String completeNumber;
  String countryCode = 'GB';
  String verificationId;
  AuthProvider _authProvider;
  SessionProvider _sessionProvider;
  bool showWholePageLoading = false;
  bool showOtp = false;
  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void setWholePageLoading(bool value) {
    setState(() {
      showWholePageLoading = value;
    });
  }

  void setLoading(bool value) {
    setState(() {
      showLoading = value;
    });
  }

  void verifyOtp(String value) async {
    _authProvider.changeOtp(value);
    if (value.length == 6) {
      FocusScope.of(context).unfocus();
      setLoading(true);
      print(controller.text);
      bool value = await _authProvider.signInWithPhoneAuthCredential(_scaffoldKey, context);
      if (value) {
        await _sessionProvider.initializeSession(controller.text).then((value) {
          print('success');
          if (_sessionProvider.currentUser != null) {
            Navigator.pushNamed(context, '/branches');
          } else {
            Navigator.pushNamed(context, '/registration');
          }
        });
      }
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    _sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        body: WillPopScope(
            onWillPop: () => Commons.onWillPop(context),
            child: SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Commons.topBar(context),
              SizedBox(height: 15),
              if (showWholePageLoading) Center(child: CircularProgressIndicator(backgroundColor: Commons.bgColor)),
              if (!showWholePageLoading)
                Container(constraints: BoxConstraints(minWidth: 250, maxWidth: 600), child: phoneNumberField())
            ]))));
  }

  Widget phoneNumberField() {
    return Column(children: [
      if (MediaQuery.of(context).size.height > 600)
        SizedBox(height: MediaQuery.of(context).size.height > 1200 ? 120 : 60),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text('Enter Mobile Number',
            style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.w800)),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text('Enter your phone number to verify your account and place order.',
            style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w800)),
      ),
      SizedBox(height: 15),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
              child: PhoneField(
            controller: controller,
            initialCountryCode: countryCode,
            onChanged: (phone) {
              _authProvider.changePhoneNumber(phone.completeNumber, controller.text);
              setState(() {
                countryCode = phone.countryISOCode;
              });
            },
          ))),
      SizedBox(height: 25),
      showOtp ? otpField() : sendOtpButton(),
      if (showOtp && showLoading) CircularProgressIndicator(color: Commons.bgColor)
    ]);
  }

  Widget otpField() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFieldPin(
                borderStyle: OutlineInputBorder(),
                borderStyeAfterTextChange: OutlineInputBorder(),
                codeLength: 6,
                onOtpCallback: (code, isFilled) {
                  verifyOtp(code);
                })),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I don\'t receive the code! ',
                style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w800)),
            TimerButton(
              label: "Please Resend",
              timeOutInSeconds: 30,
              onPressed: () async {
                setWholePageLoading(true);
                await _authProvider.sendOtp(scaffoldkey: _scaffoldKey, context: context);
                setWholePageLoading(false);
              },
              buttonType: ButtonType.FlatButton,
              disabledColor: Colors.red,
              color: Colors.transparent,
              disabledTextStyle: new TextStyle(fontSize: 12.0, color: Colors.grey),
              activeTextStyle: new TextStyle(fontSize: 12.0, color: Commons.bgColor, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  Widget sendOtpButton() {
    return GestureDetector(
      onTap: () async {
        setWholePageLoading(true);
        FocusScope.of(context).unfocus();
        bool value = await _authProvider.sendOtp(scaffoldkey: _scaffoldKey, context: context);
        setWholePageLoading(false);
        if (value) {
          setState(() {
            showOtp = value;
          });
        }
      },
      child: Container(
        width: 250,
        height: 60,
        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(40)),
        alignment: Alignment.center,
        child: Text('SEND',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
      ),
    );
  }
}
