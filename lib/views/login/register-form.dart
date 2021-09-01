import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/provider/auth.dart';
import '/provider/session.dart';
import '/utils/commons.dart';
import '/utils/dio-request.dart';

class RegistrationPage extends StatefulWidget {
  final User user;

  const RegistrationPage({Key key, this.user}) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _areaCode = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  AuthProvider _authProvider = AuthProvider();
  SessionProvider _sessionProvider = SessionProvider();
  String userNameError;
  String mailError;
  bool isLoading = false;
  bool formValid = false;
  setUserNameError(String value) {
    setState(() {
      userNameError = value;
    });
  }

  setFormValid() {
    if (widget.user == null)
      setState(() {
        formValid = _userName.text != '' &&
            _firstName.text != '' &&
            _lastName.text != '' &&
            _email.text != '' &&
            validateEmail(_email.text) &&
            _areaCode.text != '';
      });
    else if (widget.user != null)
      setState(() {
        formValid = !(widget.user.firstName == _firstName.text &&
            widget.user.secondName == _lastName.text &&
            widget.user.emailId == _email.text &&
            widget.user.pincode == _areaCode.text);
      });
  }

  setMailError(String value) {
    setState(() {
      mailError = value;
    });
  }

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> registerUser(BuildContext context, User data, {bool edit = false}) async {
    print(data.toJson());
    try {
      print(Commons.baseURL + 'customer');
      setLoading(true);
      setUserNameError(null);
      if (edit) {
        dioRequest.options.headers.addAll({'Authorization': 'Bearer ${_sessionProvider.bearer}'});
        await dioRequest.put('customer', data: data.toJson(edit: true));
      } else {
        await dioRequest.post('customer', data: data.toJson());
      }
      await _sessionProvider.initializeSession(data.phoneNumbers[0].phoneNumber);

      if (edit)
        Navigator.pop(context);
      else {
        _sessionProvider.initializeSession(_authProvider.phoneNumber);
        await Navigator.pushReplacementNamed(context, '/home');
      }

      setLoading(false);
    } on DioError catch (e) {
      if (e.error != null) {
        if (e.response != null) {
          String message = e.response?.data;
          print(message);
          if (message == 'User Name Already Exists') {
            print('User Name');
            setState(() {
              userNameError = 'User Name Already Exists';
            });
          } else if (message == 'Phone number Already Exists') {
            _sessionProvider.initializeSession(_authProvider.phoneNumber);
            Navigator.pushReplacementNamed(context, '/profile');
          } else {
            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
          }
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
      setLoading(false);
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _firstName.text = widget.user.firstName;
      _lastName.text = widget.user.secondName;
      _userName.text = widget.user.userName;
      _areaCode.text = widget.user.pincode;
      _email.text = widget.user.emailId;
    }
    setFormValid();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    _sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Commons.topBar(context, showBackButton: widget.user != null),
            Container(
              constraints: BoxConstraints(minWidth: 250, maxWidth: 600),
              child: Column(
                children: [
                  profileField(),
                  SizedBox(height: 15),
                  if (widget.user == null)
                    textField(
                        controller: _userName,
                        title: 'User Name',
                        errorText: userNameError,
                        onChange: (value) {
                          setFormValid();
                        }),
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          constraints: BoxConstraints(minWidth: 125, maxWidth: 300),
                          child: textField(
                              controller: _firstName,
                              title: 'First Name',
                              onChange: (value) {
                                setFormValid();
                              })),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          constraints: BoxConstraints(minWidth: 125, maxWidth: 300),
                          child: textField(
                              controller: _lastName,
                              title: 'Last Name',
                              onChange: (value) {
                                setFormValid();
                              })),
                    ],
                  ),
                  textField(
                      controller: _email,
                      title: 'Email',
                      errorText: mailError,
                      onChange: (String value) {
                        validateEmail(value) ? setMailError(null) : setMailError('Please Enter Proper MailId');
                        setFormValid();
                      }),
                  ListTile(
                    title: Text('Phone Number'),
                    subtitle: TextFormField(
                      initialValue:
                      widget.user == null ? _authProvider.phoneNumber : widget.user.phoneNumbers[0].phoneNumber,
                      cursorColor: Commons.bgColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                  textField(
                      controller: _areaCode,
                      title: 'Area Code',
                      onChange: (value) {
                        setFormValid();
                      }),
                  SizedBox(height: 60),
                  if (widget.user == null) button() else if (formValid) button(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (formValid) {
          User data = User(
            firstName: _firstName.text,
            secondName: _lastName.text,
            userName: _userName.text,
            emailId: _email.text,
            phoneNumbers: [PhoneNumbers(phoneNumber: _authProvider.phoneNumber)],
            pincode: _areaCode.text,
          );
          if (widget.user == null)
            await registerUser(context, data);
          else {
            User _data = User(
              sId: widget.user.sId,
              customerCode: widget.user.customerCode,
              createdBy: widget.user.createdBy,
              createdDate: widget.user.createdDate,
              isActive: widget.user.isActive,
              firstName: _firstName.text,
              secondName: _lastName.text,
              userName: _userName.text,
              emailId: _email.text,
              phoneNumbers: widget.user.phoneNumbers,
              pincode: _areaCode.text,
            );
            await registerUser(context, _data, edit: true);
          }
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Fill All the fields')));
        }
      },
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: formValid ? Commons.bgColor : Commons.bgColor.withOpacity(.4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.user == null ? 'CREATE ACCOUNT' : 'SAVE',
              style: TextStyle(color: Colors.white),
            ),
            if (isLoading) CircularProgressIndicator(color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget textField(
      {TextEditingController controller,
        String title,
        bool enabled = true,
        Function(String) onChange,
        String errorText}) {
    return ListTile(
      title: Text(title),
      subtitle: TextField(
        controller: controller,
        cursorColor: Commons.bgColor,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          errorText: errorText,
        ),
        enabled: enabled,
        onChanged: onChange,
      ),
    );
  }

  Widget profileField() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(image: AssetImage('assets/images/profile.png')),
          ),
        ),
        if (widget.user != null)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('@' + widget.user.userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
      ],
    );
  }
}
