import 'package:flutter/material.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class AddCustomerScreen extends StatefulWidget {
  final DurationEnum currentMode;
  AddCustomerScreen({this.currentMode});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List<Step> steps = [
    Step(
      title: Text('One'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('Two'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('3'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('4'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('5'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('6'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('7'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('8'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('9'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('10'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('11'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('11'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('12'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('13'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
    Step(
      title: Text('14'),
      isActive: true,
      state: StepState.indexed,
      content: TextFormField(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Line'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Utils.logOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Stepper(
                  steps: steps,
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepTapped: (step) {
                    setState(() {
                      _currentStep = step;
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep = _currentStep - 1;
                      } else {
                        _currentStep = 0;
                      }
                    });
                  },
                  onStepContinue: () {
                    setState(() {
                      if (_currentStep < steps.length - 1) {
                        _currentStep = _currentStep + 1;
                      } else {
                        _currentStep = 0;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyRaisedButton(
                    name: 'Add Customer',
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
