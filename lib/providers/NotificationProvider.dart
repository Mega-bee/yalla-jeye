import 'package:flutter/cupertino.dart';

import '../Services/ApiLink.dart';
import '../Services/NotificationService.dart';
import '../Services/ServiceAPi.dart';
import '../models/Notifications.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationService _notificationService = NotificationService();
  NotificationModel _notificationModel = NotificationModel();

  NotificationModel get notificationModel => _notificationModel;

  set notificationModel(NotificationModel value) {
    _notificationModel = value;
  }

  Map<String, dynamic> _allData = {};
  List<NotificationModel> _services = [];
  bool _loading = true;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  List<NotificationModel> get services => _services;

  set services(List<NotificationModel> value) {
    _services = value;
  }

  Map<String, dynamic> get allData => _allData;

  set allData(Map<String, dynamic> value) {
    _allData = value;
  }

  NotificationService get notificationService => _notificationService;

  set notificationService(NotificationService value) {
    _notificationService = value;
  }

  ServiceAPi _serviceAPi = ServiceAPi();

  ServiceAPi get serviceAPi => _serviceAPi;

  set serviceAPi(ServiceAPi value) {
    _serviceAPi = value;
  }

  getNotifications() async {
    allData = await _serviceAPi.getAPi(ApiLink.Notification, [], {});
    print(" api in if");
    if (allData["error"] != null) {
      print(allData["error"]);
    } else {
      print(" api in else");

      loading = true;

      services = List<NotificationModel>.from(
        allData["data"].map(
          (model) => NotificationModel.fromJson(model),
        ),
      );

      loading = false;

      print(allData.length);
    }
    notifyListeners();
  }
}
