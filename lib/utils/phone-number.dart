library intl_phone_field;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '/utils/commons.dart';

class PhoneField extends StatefulWidget {
  final bool obscureText;
  final TextAlign textAlign;
  final VoidCallback onTap;

  final bool readOnly;
  final FormFieldSetter<PhoneNumber> onSaved;
  final ValueChanged<PhoneNumber> onChanged;
  final ValueChanged<PhoneNumber> onCountryChanged;
  final FormFieldValidator<String> validator;
  final bool autoValidate;

  final Widget suffix;

  final TextInputType keyboardType;

  final TextEditingController controller;

  final FocusNode focusNode;

  final void Function(String) onSubmitted;

  final bool enabled;

  final Brightness keyboardAppearance;

  final String initialValue;

  final String initialCountryCode;

  final List<String> countries;
  final TextStyle style;
  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;
  final List<TextInputFormatter> inputFormatters;
  final String searchText;

  final Color countryCodeTextColor;

  final Color dropDownArrowColor;

  final bool autofocus;

  TextInputAction textInputAction;

  PhoneField({
    this.initialCountryCode,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType = TextInputType.number,
    this.autoValidate = true,
    this.controller,
    this.focusNode,
    this.style,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.suffix,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance = Brightness.light,
    this.searchText = 'Search by Country Name',
    this.countryCodeTextColor,
    this.dropDownArrowColor,
    this.autofocus = false,
    this.textInputAction,
  });

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  List<Map<String, dynamic>> _countryList;
  Map<String, dynamic> _selectedCountry;
  List<Map<String, dynamic>> filteredCountries;

  FormFieldValidator<String> validator;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries == null
        ? countries
        : countries.where((country) => widget.countries.contains(country['code'])).toList();
    filteredCountries = _countryList;
    _selectedCountry = _countryList.firstWhere((item) => item['code'] == (widget.initialCountryCode ?? 'US'),
        orElse: () => _countryList.first);

    validator = widget.autoValidate
        ? ((value) => value != null && value.length != 10 ? 'Invalid Mobile Number' : null)
        : widget.validator;
  }

  Future<void> _changeCountry() async {
    filteredCountries = _countryList;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: widget.searchText,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredCountries = _countryList
                          .where((country) => country['name'].toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredCountries.length,
                    itemBuilder: (ctx, index) => Column(
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset(
                            'assets/flags/${filteredCountries[index]['code'].toLowerCase()}.png',
                            package: 'intl_phone_field',
                            width: 32,
                          ),
                          title: Text(
                            filteredCountries[index]['name'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            '+${filteredCountries[index]['dial_code']}',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            _selectedCountry = filteredCountries[index];

                            if (widget.onCountryChanged != null) {
                              widget.onCountryChanged(
                                PhoneNumber(
                                  countryISOCode: _selectedCountry['code'],
                                  countryCode: '+${_selectedCountry['dial_code']}',
                                  number: '',
                                ),
                              );
                            }

                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(thickness: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Commons.bgColor, width: 1.5)),
      child: ListTile(
        leading: Container(
          height: 45,
          width: 75,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: _changeCountry,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: AssetImage('assets/flags/${_selectedCountry['code'].toLowerCase()}.png',
                              package: 'intl_phone_field'),
                          fit: BoxFit.cover)),
                ),
                Text(
                  ' - ',
                  style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        title: TextFormField(
          initialValue: widget.initialValue,
          controller: widget.controller,
          decoration: InputDecoration(
              prefixText: '(+${_selectedCountry['dial_code']}) ',
              prefixStyle: TextStyle(color: Colors.black),
              hintText: 'Phone Number',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffix: widget.suffix,
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
              counterText: ''),
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            if (widget.onChanged != null) print(_selectedCountry['code']);
            widget.onChanged(
              PhoneNumber(
                countryISOCode: _selectedCountry['code'],
                countryCode: '+${_selectedCountry['dial_code']}',
                number: value,
              ),
            );
          },
          validator: validator,
          maxLength: _selectedCountry['max_length'],
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          keyboardAppearance: widget.keyboardAppearance,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
        ),
      ),
    );
  }
}
