import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/components/contact_tile.dart';
import 'package:login_app/resources/strings.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final userNameFocusNode = FocusNode();

  bool obscureText = true;
  DateTime? selectedBirthDate;
  bool emailChecked = true;
  bool phoneChecked = true;
  bool acceptedTerms = false;

  final emailRegex = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  }

  void showSignUpDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(Strings.appName),
          content: const Text(Strings.confirmationMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sim'),
            )
          ],
        );
      },
    ).then((confirmedSignUp) {
      if (confirmedSignUp != null && confirmedSignUp) {
        emailChecked = true;
        phoneChecked = true;
        acceptedTerms = false;

        Form.of(context)?.reset();
        birthDateController.clear();
        userNameFocusNode.requestFocus();

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(Strings.userSignedUp)));
      }
    });
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
                focusNode: userNameFocusNode,
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
                  helperText: Strings.passwordHelper,
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
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: passwordValidator,
              ),
              const SizedBox(height: 18.0),
              buildHeader(Strings.personalInformation),
              TextFormField(
                decoration: buildInputDecoration(Strings.fullName),
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: fullNameValidator,
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
                        validator: emptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      inputFormatters: [phoneMask],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: phoneValidator,
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
              FormField<bool>(
                validator: (_) {
                  if (!acceptedTerms) {
                    return Strings.errorMessageNotAcceptedTerms;
                  }
                  return null;
                },
                builder: (formFieldState) {
                  final errorText = formFieldState.errorText;
                  return SwitchListTile(
                    focusNode: termsFocusNode,
                    title: Text(Strings.termsMessage,
                        style: theme.textTheme.subtitle2),
                    subtitle: errorText != null
                        ? Text(errorText,
                            style: theme.textTheme.bodyText2
                                ?.copyWith(color: theme.errorColor))
                        : null,
                    value: acceptedTerms,
                    contentPadding: const EdgeInsets.only(right: 8.0),
                    onChanged: (value) => setState(() {
                      acceptedTerms = value;
                    }),
                  );
                },
              ),
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    final formState = Form.of(context);
                    if (formState != null && formState.validate()) {
                      showSignUpDialog(context);
                    }
                  },
                  child: const Text(Strings.signUp),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  String? phoneValidator(phone) {
    final emptyError = emptyValidator(phone);
    if (emptyError == null && phone != null) {
      final phoneDigits = phoneMask.unmaskText(phone);
      if (phoneDigits.length < 11) {
        return Strings.errorMessageInvalidPhone;
      }
    }
    return emptyError;
  }

  String? fullNameValidator(fullName) {
    final emptyError = emptyValidator(fullName);
    if (emptyError == null && fullName != null) {
      if (fullName.split(' ').length == 1) {
        return Strings.errorMessageInvalidFullName;
      }
    }
    return emptyError;
  }

  String? passwordValidator(password) {
    final emptyError = emptyValidator(password);
    if (emptyError == null && password != null) {
      if (password.length < 8) {
        return Strings.passwordHelper;
      }
    }
    return emptyError;
  }

  String? emailValidator(email) {
    final emptyError = emptyValidator(email);
    if (emptyError == null && email != null) {
      if (!emailRegex.hasMatch(email)) {
        return Strings.errorMessageInvalidEmail;
      }
    }
    return emptyError;
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
    userNameFocusNode.dispose();
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