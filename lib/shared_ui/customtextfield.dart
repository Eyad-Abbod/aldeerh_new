import 'package:byahmed_eyone/utilities/app_theme.dart';
import 'package:flutter/material.dart';

class CustTextFormSign extends StatefulWidget {
  final TextInputType? ourInput;
  final String hint;
  final IconData icon;
  final int maxl;
  final int myMaxlength;
  final String? Function(String?) valid;
  final TextEditingController mycontroller;
  const CustTextFormSign(
      {Key? key,
      required this.ourInput,
      required this.hint,
      required this.icon,
      required this.maxl,
      required this.myMaxlength,
      required this.mycontroller,
      required this.valid})
      : super(key: key);

  @override
  State<CustTextFormSign> createState() => _CustTextFormSignState();
}

class _CustTextFormSignState extends State<CustTextFormSign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: widget.myMaxlength == 0
          ? widget.icon == Icons.ac_unit
              ? Column(
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: widget.ourInput,
                      maxLines: widget.maxl,
                      validator: widget.valid,
                      controller: widget.mycontroller,
                      decoration: InputDecoration(
                          labelText: widget.hint,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 30),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 10)
                  ],
                )
              : Column(
                  children: [
                    TextFormField(
                      keyboardType: widget.ourInput,
                      maxLines: widget.maxl,
                      validator: widget.valid,
                      controller: widget.mycontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            widget.icon,
                            color: AppTheme.appTheme.primaryColor,
                          ),
                          labelText: widget.hint),
                    ),
                    const SizedBox(height: 10)
                  ],
                )
          : widget.icon == Icons.ac_unit
              ? TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: widget.ourInput,
                  maxLength: widget.myMaxlength,
                  maxLines: widget.maxl,
                  validator: widget.valid,
                  controller: widget.mycontroller,
                  decoration: InputDecoration(
                      labelText: widget.hint,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 30),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                )
              : TextFormField(
                  keyboardType: widget.ourInput,
                  maxLength: widget.myMaxlength,
                  maxLines: widget.maxl,
                  validator: widget.valid,
                  controller: widget.mycontroller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        widget.icon,
                        color: AppTheme.appTheme.primaryColor,
                      ),
                      labelText: widget.hint),
                ),
    );
  }
}






// class CustTextFormSign extends StatelessWidget {
//   final TextInputType? ourInput;
//   final String hint;
//   final IconData icon;
//   final int maxl;
//   final int myMaxlength;
//   final String? Function(String?) valid;
//   final TextEditingController mycontroller;
//   const CustTextFormSign(
//       {Key? key,
//       required this.ourInput,
//       required this.hint,
//       required this.icon,
//       required this.maxl,
//       required this.myMaxlength,
//       required this.mycontroller,
//       required this.valid})
//       : super(key: key);

  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       child: myMaxlength == 0
//           ? icon == Icons.ac_unit
//               ? Column(
//                   children: [
//                     TextFormField(
//                       textAlign: TextAlign.center,
//                       keyboardType: ourInput,
//                       maxLines: maxl,
//                       validator: valid,
//                       controller: mycontroller,
//                       decoration: InputDecoration(
//                           labelText: hint,
//                           contentPadding: const EdgeInsets.symmetric(
//                               vertical: 5, horizontal: 30),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10))),
//                     ),
//                     const SizedBox(height: 10)
//                   ],
//                 )
//               : Column(
//                   children: [
//                     TextFormField(
//                       keyboardType: ourInput,
//                       maxLines: maxl,
//                       validator: valid,
//                       controller: mycontroller,
//                       decoration: InputDecoration(
//                           prefixIcon: Icon(
//                             icon,
//                             color: AppTheme.appTheme.primaryColor,
//                           ),
//                           labelText: hint),
//                     ),
//                     const SizedBox(height: 10)
//                   ],
//                 )
//           : icon == Icons.ac_unit
//               ? TextFormField(
//                   textAlign: TextAlign.center,
//                   keyboardType: ourInput,
//                   maxLength: myMaxlength,
//                   maxLines: maxl,
//                   validator: valid,
//                   controller: mycontroller,
//                   decoration: InputDecoration(
//                       labelText: hint,
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 5, horizontal: 30),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                 )
//               : TextFormField(
//                   keyboardType: ourInput,
//                   maxLength: myMaxlength,
//                   maxLines: maxl,
//                   validator: valid,
//                   controller: mycontroller,
//                   decoration: InputDecoration(
//                       prefixIcon: Icon(
//                         icon,
//                         color: AppTheme.appTheme.primaryColor,
//                       ),
//                       labelText: hint),
//                 ),
//     );
//   }
// }
