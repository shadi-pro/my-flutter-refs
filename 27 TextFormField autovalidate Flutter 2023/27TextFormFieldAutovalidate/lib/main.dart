/*
 Lessons applied in this application :  
            
  -----------------------------
  
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
  
 
  21-  [ TextFormField ]  (part 3 -  autovalidate  ) 

    a - determining  public [autovalidateMode]  within the [Form] the parent container of the all   (inner  textformfields)     of certain type  (for all inner textformfields)  :
    b - determining  private [autovalidateMode] of certain type  (for  this textformfield only  )  :

  // -----------------------------
 

*/
// --------------------------

// import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(), // MaterialApp في الأعلى مرة واحدة فقط
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AutoValidate Form Example")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  helperText: "Required format: example@mail.com",
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required!";
                  } else if (!value.contains('@')) {
                    return "Invalid email format!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // استخدم Builder لتوفير context جديد تابع للـScaffold
              Builder(
                builder: (BuildContext innerContext) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(innerContext).showSnackBar(
                          const SnackBar(content: Text("Form is valid ✅")),
                        );
                      } else {
                        ScaffoldMessenger.of(innerContext).showSnackBar(
                          const SnackBar(
                            content: Text("Please correct the errors ❌"),
                          ),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
