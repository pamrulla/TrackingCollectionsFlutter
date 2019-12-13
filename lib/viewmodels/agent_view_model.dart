import 'package:tracking_collections/models/agent.dart';

class AgentViewModel {
  String id = '';
  String name = '';
  String number = '';
  String city = '';
  String userId = '';
  String role = '';
  bool isFirstTime = true;
  String head = '';

  static AgentViewModel createFromAgent(Agent agent, String c) {
    AgentViewModel avm = AgentViewModel();
    avm.id = agent.id;
    avm.name = agent.name;
    avm.number = agent.number;
    avm.city = c;
    avm.userId = agent.userId;
    avm.role = agent.role;
    avm.isFirstTime = agent.isFirstTime;
    avm.head = agent.head;
    return avm;
  }

  static List<AgentViewModel> fromAgent(Agent agent) {
    List<AgentViewModel> agents = [];
    agent.city.forEach((c) {
      agents.add(createFromAgent(agent, c));
    });
    return agents;
  }
}
