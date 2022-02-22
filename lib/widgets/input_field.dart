import 'package:flutter/material.dart';
import 'package:todo/ui/themes.dart';

class InputField extends StatelessWidget {
  final String title;
  // ignore: constant_identifier_names
  final String Hint;
  final TextEditingController? controller;
  final Widget? widget;
  const InputField(
      {Key? key,
      required this.title,
      required this.Hint,
      required this.controller,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
              margin:  EdgeInsets.only(top: 8.2),
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding:  EdgeInsets.all(7),
                child: Row(
                  
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: widget==null?false:true,
                        autofocus: false,
                        cursorColor: Colors.grey,
                        controller: controller,
                        style: SubtitleStyle,
                        decoration: InputDecoration(
                          hintText: Hint,
                          hintStyle: SubtitleStyle,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 0),
                          ),
                          enabledBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 0),
                          ),
                        ),
                      ),
                    ),
                    widget==null?Container():Container(child: widget,)
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
