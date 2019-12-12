import 'package:flutter/material.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/utils/constants.dart';

class EditCustomer extends StatelessWidget {
  final String currentCustomer;
  final Function onEdit;
  EditCustomer({@required this.currentCustomer, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () async {
        bool isUpdated = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return AddCustomerScreen(
              currentMode: DurationEnum.Monthly,
              currentCustomer: currentCustomer,
            );
          }),
        );
        onEdit(isUpdated);
      },
    );
  }
}
