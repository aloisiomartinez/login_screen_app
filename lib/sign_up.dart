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
  final birthDateController = TextEditingController();

  final birthDateFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final termsFocusNode = FocusNode(descendantsAreFocusable: false);

  bool obscureText = true;
  DateTime? selectedBirthDate;
  bool emailChecked = true;
  bool phoneChecked = true;
  bool acceptedTerms = false;

  final emailRegex = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  @override
  void initState() {
    super.initState();
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  }

  void showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(Strings.appName),
          content: const Text(Strings.confirmationMessage),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Sim'),
            )
          ],
        );
      },
    );
  }

  void showBirthDatePicker() {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
    showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: selectedBirthDate ?? eighteenYearsAgo,
      lastDate: eighteenYearsAgo,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
    ).then((selectedDate) {
      if (selectedDate != null) {
        selectedBirthDate = selectedDate;
        birthDateController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
        phoneFocusNode.requestFocus();
      }
    });
    birthDateFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.appName),
            actions: [
              const IconButton(
                onPressed: debugDumpFocusTree,
                icon: Icon(Icons.center_focus_strong),
              ),
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
              TextFormField(
                autofocus: true,
                decoration: buildInputDecoration(Strings.userName),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: emptyValidator,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: buildInputDecoration(Strings.email),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: emailValidator,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                obscureText: obscureText,
                decoration: buildInputDecoration(Strings.password).copyWith(
                  suffixIcon: ExcludeFocus(
                    child: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() {
                        obscureText = !obscureText;
                      }),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18.0),
              buildHeader(Strings.personalInformation),
              TextFormField(
                decoration: buildInputDecoration(Strings.fullName),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Focus(
                      focusNode: birthDateFocusNode,
                      descendantsAreFocusable: false,
                      onFocusChange: (hasFocus) {
                        debugPrint(hasFocus.toString());
                        if (hasFocus) {
                          showBirthDatePicker();
                        }
                      },
                      child: TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        decoration: buildInputDecoration(Strings.birthDate),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onTap: showBirthDatePicker,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      focusNode: phoneFocusNode,
                      decoration: buildInputDecoration(Strings.phone),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
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
                focusNode: termsFocusNode,
                title: Text(Strings.termsMessage,
                    style: theme.textTheme.subtitle2),
                value: acceptedTerms,
                contentPadding: const EdgeInsets.only(right: 8.0),
                onChanged: (value) => setState(() {
                  acceptedTerms = value;
                }),
              ),
              ElevatedButton(
                onPressed: showSignUpDialog,
                child: const Text(Strings.signUp),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? emailValidator(email) {
                final emptyError = emptyValidator(email);
                if (emptyError == null && email != null) {
                  if (!emailRegex.hasMatch(email)) {
                    return Strings.errorMessageInvalidEmail;
                  }
                }
                return null;
              }

  String? emptyValidator(String? text) {
    if (text == null || text.isEmpty) {
      return Strings.errorMessageEmptyField;
    }
    return null;
  }

  @override
  void dispose() {
    birthDateController.dispose();
    birthDateFocusNode.dispose();
    phoneFocusNode.dispose();
    termsFocusNode.dispose();
    super.dispose();
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
}