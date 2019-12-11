import 'package:flutter/material.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/utils/constants.dart';

class EditCustomer extends StatelessWidget {
  final String currentCustomer;
  EditCustomer({@required this.currentCustomer});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return AddCustomerScreen(
              currentMode: DurationEnum.Monthly,
              currentCustomer: currentCustomer,
            );
          }),
        );
      },
    );
  }
}
