/* 
  20-  [ TextFormField ]  (part 2 - onSaved ) - 
       (1) examples =>   
         First example [Exp1] =>
          a - main processes :  
           1- vaidation process  =>  
            -- [assign valdiation logics] :  using [validator] property method of a the [textformfield] to assign the valdiatoin  logics       
            -- [activation of validatoin logics ] : using [validate()] in seprated button'event property in the same Form,  with defined form key to activate the assigned valdiatoins  logics           
           
           
           2- saving process   => 
            -- [assign inserted value ] :  using [onSaved] of [TextFormField] to assing the inserted field value into the predfined varlable  
            -- [ activation of the save process   ] : using [save()] of in seprated button'event property in the same Form,  with defined form key to activate the assigned  saved value in the onSaved   

          
          b - implementing assigned logics of all   {TextFormField} inside the Form , by using a one submit button  {MaterialButton}
          - this example including next widgets : 
            1- [(2) {TextFormField} widget] =>  each will include : 
              - saved textformfield using [ onSaved ] functional property for each textformField + predefined specefied variable        
              - several [ validation logics ] including    : 
                --  inserted amount empty + limitations  
                 
            2- [(1) {Button} widget] => the button will execute assigned [validaton logic]  of all textFormField : 
              - assigning onPressed property by   conditional executing of assigned validations logics for th current textformfiled   
              - actvating the {save()} of [onSaved] incase of validations is true  
  -----------------------------
  
*/
// --------------------------

// import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? username;
  String? phone;

  String usernameHelper = 'يجب أن يحتوي الاسم على 3 إلى 20 حرفًا';
  String phoneHelper = 'أدخل رقم بين 9 و12 رقمًا';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ✅ the ScaffoldMessenger is now correctly scoped
      home: Scaffold(
        appBar: AppBar(
          title: const Text('[TextFormField] onSaved + validation'),
        ),
        body: Builder(
          // ✅ this Builder gives a fresh context *inside* the Scaffold
          builder: (BuildContext innerContext) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      onSaved: (val) => username = val,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'أدخل اسم المستخدم',
                        helperText: usernameHelper,
                        helperStyle: const TextStyle(
                          color: Colors.black54,
                          decoration: TextDecoration.underline,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          if (val.isEmpty) {
                            usernameHelper = '⚠️ لا تترك الحقل فارغًا';
                          } else if (val.length < 3) {
                            usernameHelper = '✏️ أدخل 3 أحرف على الأقل';
                          } else if (val.length > 20) {
                            usernameHelper = '🚫 لا تتجاوز 20 حرفًا';
                          } else {
                            usernameHelper = '✅ الاسم مقبول';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'الحقل فارغ';
                        if (value.length < 3) return 'أقل من 3 حروف غير مقبول';
                        if (value.length > 20)
                          return 'أكبر من 20 حرف غير مقبول';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onSaved: (val) => phone = val,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: 'أدخل رقم الهاتف',
                        helperText: phoneHelper,
                        helperStyle: const TextStyle(
                          color: Colors.black54,
                          decoration: TextDecoration.underline,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          if (val.isEmpty) {
                            phoneHelper = '⚠️ الحقل فارغ';
                          } else if (val.length < 9) {
                            phoneHelper = '✏️ يجب أن يكون 9 أرقام على الأقل';
                          } else if (val.length > 12) {
                            phoneHelper = '🚫 يجب ألا يزيد عن 12 رقمًا';
                          } else {
                            phoneHelper = '✅ رقم مقبول';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'الحقل فارغ';
                        if (value.length < 9)
                          return 'رقم أقل من 9 أرقام غير مقبول';
                        if (value.length > 12)
                          return 'رقم أكبر من 12 رقم غير مقبول';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formstate.currentState!.validate()) {
                          formstate.currentState!.save();
                          ScaffoldMessenger.of(innerContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ Username: $username | Phone: $phone',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(innerContext).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Please fix the errors'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Validate & Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
