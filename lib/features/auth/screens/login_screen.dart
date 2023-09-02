import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widget/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class loginscreen extends ConsumerStatefulWidget {
  static const routename = '/login-screen';
  const loginscreen({super.key});

  @override
  ConsumerState<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends ConsumerState<loginscreen> {
  final phonecontroller = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phonecontroller.dispose();
  }

  void pickcountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendphonenumber() {
    String phonenumber = phonecontroller.text.trim();
    if (country != null && phonenumber.isNotEmpty) {
      ref
          .read(authcontrollerprovider)
          .signinwithphone(context, '+${country!.phoneCode}$phonenumber');
    } else {
      showsnackbar(context, 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0).copyWith(right: 55),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'WhatsApp will need to verify your phone number',
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  pickcountry();
                },
                child: Text('Pick Country'),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  if (country != null)
                    Text(
                      '+${country!.phoneCode}',
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phonecontroller,
                      decoration: InputDecoration(
                        hintText: 'phone number',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.51,
                    ),
                    SizedBox(
                      width: 90,
                      child: Custombutton(
                        onpressed: () {
                          sendphonenumber();
                        },
                        text: 'NEXT',
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
