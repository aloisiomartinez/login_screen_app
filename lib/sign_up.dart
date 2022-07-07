import 'package:flutter/material.dart';
import 'package:login_app/components/contact_tile.dart';
import 'package:login_app/resources/strings.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
    required this.onThemeModePressed,
  }) : super(key: key);

  final VoidCallback onThemeModePressed;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool obscureText = true;
  final birthDateController = TextEditingController();
  DateTime? selectedBirthDate;
  bool emailChecked = true;
  bool phoneChecked = true;
  bool acceptedTerms = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          IconButton(
            onPressed: widget.onThemeModePressed,
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          buildHeader(Strings.accessData),
          TextField(
            autofocus: true,
            decoration: buildInputDecoration(Strings.userName),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10.0),
          TextField(
            decoration: buildInputDecoration(Strings.email),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10.0),
          TextField(
            obscureText: obscureText,
            decoration: buildInputDecoration(Strings.password).copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() {
                  obscureText = !obscureText;
                }),
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18.0),
          buildHeader(Strings.personalInformation),
          TextField(
            decoration: buildInputDecoration(Strings.fullName),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: TextField(
                  controller: birthDateController,
                  readOnly: true,
                  decoration: buildInputDecoration(Strings.birthDate),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onTap: showBirthDatePicker,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 5,
                child: TextField(
                  decoration: buildInputDecoration(Strings.phone),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                ),
              )
            ],
          ),
          const SizedBox(height: 18.0),
          buildHeader(Strings.contactMessage),
          ContactTile(
            contactTitle: Strings.email,
            contactIcon: Icons.email,
            value: emailChecked,
            onChanged: (value) => setState(() {
              emailChecked = value!;
            }),
          ),
          ContactTile(
            contactTitle: Strings.phone,
            contactIcon: Icons.phone,
            value: phoneChecked,
            onChanged: (value) => setState(() {
              phoneChecked = value!;
            }),
          ),
           SwitchListTile(
            title: Text(Strings.termsMessage, style: theme.textTheme.subtitle2),
            value: acceptedTerms,
            contentPadding: const EdgeInsets.only(right: 8.0),
            onChanged: (value) => setState(() {
              acceptedTerms = value;
            }),
          ),
          ElevatedButton(
              onPressed: showSignUpDialog, child: const Text(Strings.signUp))
        ],
      ),
    );
  }

  Padding buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Text(text, style: Theme.of(context).textTheme.subtitle2),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
    );
  }

  void showSignUpDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(Strings.appName),
            content: const Text('Deseja finalizar o cadastro?'),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Não')),
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Sim'))
            ],
          );
        });
  }

  void showBirthDatePicker() {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
    showDatePicker(
            context: context,
            initialDate: selectedBirthDate ?? eighteenYearsAgo,
            firstDate: DateTime(1900),
            lastDate: eighteenYearsAgo,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDatePickerMode: DatePickerMode.year)
        .then((selectedDate) {
      if (selectedDate != null) {
        selectedBirthDate = selectedDate;
        birthDateController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      }
    });
  }
}
