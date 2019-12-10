import 'package:flutter/material.dart';
import 'package:tracking_collections/models/city.dart';

enum DurationEnum { Monthly, Weekly, Daily }
const List<String> durations = ['Monthly', 'Weekly', 'Daily'];
const List<IconData> icons = [Icons.filter_1, Icons.filter_2, Icons.filter_3];
enum CityEnum { Kakinada, Rajahmundry, Ongole, Gannavaram, Khammam, Narsapuram }
List<City> cities = [];
enum TransactionTypeEnum { Repayment, Penalty }
enum agentListActionsEnum { CustomersList, NewCustomer }
const List<String> agentListActions = [
  'View Customers List',
  'Add New Customer'
];
const List<IconData> agentListActionsIcons = [
  Icons.view_list,
  Icons.add_circle
];
const String userNameTail = "@trackingcollectionsapp.com";
