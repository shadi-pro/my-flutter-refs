// # [ 12  : 31 ]

// A] importing  public  packages:

// 1- importing [flutter/material]  :
import 'package:flutter/material.dart';

// 2- importing  [dropdown list ] package :
import 'package:drop_down_list/drop_down_list.dart';

// 3- importing  [dropdown list ] model  :
import 'package:drop_down_list/model/selected_list_item.dart';
// --------------------------------

// B] Parent class :

class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hint;
  final bool isCitySelected;
  final List<SelectedListItem>? datalist;

  //  constructor function of the parent class [AppTextField] (incliude attrbiutes of the [AppTextField]  to be assgined wiht values when being called )  :
  const AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.isCitySelected,
    this.datalist, //  [ represent one of datalist to be displayed insisde the  search box result {can define several datalists variables} ]
    Key? key,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}
// ------------------------------------------------

//  Child class   :
class _AppTextFieldState extends State<AppTextField> {
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        isDismissible: true,
        bottomSheetTitle: Text(
          widget.title , //  [the title value of bottom sheet ]
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        submitButtonChild: const Text(
          "Done",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        data: widget.datalist ?? [],
        selectedItems: (List<dynamic> selectedList) {
          // [this function returning the values of selected items values (as a list)  ]
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(
                item.name,
              ); // [adding the selected value into the defined list]
              print(item.name); // [testing printing of the selected value  ]

              widget.textEditingController.text =
                  item.name; // [ adding hte added selcted item value into the displayed text of search box     ]
            }
          }
          showSnackBar(list.toString());
        },
        enableMultipleSelection: // [ this property for activate , deactivate  multiple selection feauture { true:able to seclect multiple items ,  false :able to seclect only one item }   ]
            true,
      ),
    ).showModel(context);
  }
  // ------------------------------------------

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
  // -----------------------------------

  // builder function  :
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          onTap:
              widget.isCitySelected
                  ? () {
                    FocusScope.of(context).unfocus();
                    onTextFieldTap();
                  }
                  : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            contentPadding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 0,
              bottom: 0,
            ),

            // condititional assign of the value inside textEditingController text field
            hintText:
                widget.textEditingController.text == ""
                    ? widget.hint
                    : widget.textEditingController.text,

            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }
}
