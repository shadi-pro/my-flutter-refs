/*
   
  17-  [ TextField  ] & [  TextFormField ]  (part 1)  =>  
      examples =>   
        a- First example [ (2) {TextField} widget description ] =>  applying some of the properites of {textfield} of : 
        - [decoration] group properties ->    InputDecoration  -> 
          -- hintText 
          -- hintStyle
          -- labelText
          -- labelStyle
          -- label 
 
          -- prefix          
          -- prefixIcon         
          -- prefixIconColor 
          -- prefixText
          -- prefixStyle 

          -- filled  
          -- filledColor 
          
          -- icon  
          -- iconColor 
            
  -----------------------------
 
  18-  [ TextField  ] & [  TextFormField ]  (part 2) =>  
      examples =>   
        example [ (2) {TextField} widget description ] =>  [  applying some of the properites of {textfield} of  :
          - enabled
          - maxLength 
          - keyboardType:  TextInputType.datatype value 
          - maxLines :  int value  
          - minLines :  int value  
          
          - decoration -> 
            -- border  : OutlineInputBorder || UnderlineInputBorder ->   [type of the border]
            -- focusedBorder : borderSide ||  borderRadius =>  [ textField's border properties of (focus event) for this textField ] 
            -- enabledBorder : borderSide ||  borderRadius =>  [ textField's border properties of (enabled event) for this textField ]  
            -- disbledBorder : borderSide ||  borderRadius =>  [textField's border properties of ( disabled event) for this textField ] 
              
  -----------------------------
  
  19-  [ TextField ]  (part 3) -  
      (3) examples =>   
        a- First example [Exp1] =>
          - displaying the value inserted inside the Textfield [ via on click event] -> by using Button's {onPressed()} property to display the defined controller variable    
          - this example including next widgets : 
            1- [(1) {TextField} widget] => will receive the inserted value that will be stored inside the controller assinged defined variable      
            2- [(1) {Button} widget] => the  button will displaying assigned variable of {controller} property of {Textfield}  [ which is the Textfield's inserted value  ]

         b- Second example [Exp2] =>
          - displaying the value inserted inside the Textfield [via on Change event - live change -] -> using Button's {onChange()} property to display the defined controller variable [in console]    
          - this example including next widgets : 
            1- [(1) {TextField} widget] => will receive the inserted value that will be stored inside the controller assinged defined variable      
            2- [(1) {Button} widget] => the  button will displaying assigned variable of {controller} property of {Textfield}  [ which is the Textfield's inserted value  ]

        c- Third example [Exp3] =>
          - displaying the value inserted inside the Textfield [via on Change event - live change -] -> using Button's {onChange()} property to display the defined controller variable in [Text Widget]   
          - this ecxample including next widgets : 
            1- [(1) {TextField} widget] => will receive the inserted value that will be stored inside the controller assinged defined variable      
            2- [(1) {Button} widget] => the  button will displaying assigned variable of {controller} property of {Textfield}  [ which is the Textfield's inserted value  ]

  -----------------------------
  
  20-  [ TextFormField ]  (part 1 - validator )  - [this lesson   ]    
      (1) examples =>   
        a- First example [Exp1] =>

          🎯 Objective:

            In this lesson, you’ll learn how to:

              1- Add live hints and helper texts that guide the user while typing.

              2- Make your validation more interactive and user-friendly.

              3- Combine real-time feedback with Form-level validation (on button press).

          🧠 Concept Explanation:
            1. [helperText] Property:
              This property in InputDecoration allows you to show a small line of hint text below the input field.
              You can use it to tell the user about your validation rules (e.g., “The name must be 3–10 letters”).

            2. Real-Time Feedback (Using onChanged() ):
              We use the onChanged event of the TextFormField to update the hint text while the user types.
              When the input changes, we check its length and change the helper message dynamically using setState().

            3. Form Validation on Button Press :
              Even with live feedback, the validator function inside the TextFormField still handles the final validation when the form is submitted.

            4. displaying the validatuion result within {snackBar} widget with using [ScaffoldMessenger] + [showSnackBar()]  method  :
              Even with live feedback, the validator function inside the TextFormField still handles the final validation when the form is submitted.
 
          🧱 Summary of What Happens:
              Step	Action	Result : 
              1	User opens the screen	A helper text shows basic input rule
              2	User starts typing	Helper text changes according to input length
              3 User presses “تحقق”	Form validation runs (error messages appear if needed)
              4	Input is valid	SnackBar message appears confirming success
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _usernameHint = "✏️ الاسم يجب أن يكون من 3 إلى 10 أحرف";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TextFormField Validator + Live Hint'),
        ),
        body: Builder(
          // ✅ Builder gives us a new context that can access ScaffoldMessenger
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "اسم المستخدم",
                      border: const OutlineInputBorder(),
                      helperText: _usernameHint,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _usernameHint = "⚠️ لا تترك الحقل فارغًا";
                        } else if (value.length < 3) {
                          _usernameHint = "✏️ يجب إدخال 3 أحرف على الأقل";
                        } else if (value.length > 10) {
                          _usernameHint = "🚫 لا يمكن إدخال أكثر من 10 أحرف";
                        } else {
                          _usernameHint = "✅ ممتاز! الاسم مقبول";
                        }
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "❌ الحقل فارغ";
                      } else if (value.length < 3) {
                        return "❌ يجب أن يكون الاسم أطول من 3 أحرف";
                      } else if (value.length > 10) {
                        return "❌ لا يمكن أن يتجاوز الاسم 10 أحرف";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // ✅ Works now — because we're inside Builder
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم التحقق بنجاح ✅"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("❌ لم يتم التحقق"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text("تحقق"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
