import 'package:casestudy/presentation/modules/core/base_page.dart';
import 'package:casestudy/presentation/modules/core/screen_configuration.dart';
import 'package:casestudy/presentation/modules/employee/employee_configuration.dart';
import 'package:casestudy/presentation/modules/employee/employee_page.dart';
import 'package:casestudy/presentation/modules/list_employees/list_employees_configuration.dart';
import 'package:casestudy/presentation/modules/list_employees/list_employees_page.dart';
import 'package:casestudy/presentation/modules/splash/splash_configuration.dart';
import 'package:casestudy/presentation/modules/splash/splash_page.dart';
import 'package:flutter/cupertino.dart';

class AppRouterDelegate extends RouterDelegate<ScreenConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ScreenConfiguration> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  ScreenConfiguration? _buildConfiguration;

  set buildConfiguration(ScreenConfiguration value) {
    _buildConfiguration = value;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    List<BasePage> pages = _getPages();
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }

  List<BasePage> _getPages() {
    if (_buildConfiguration == null ||
        _buildConfiguration is SplashConfiguration) {
      return _getSplashStack();
    } else if (_buildConfiguration is ListEmployeesConfiguration) {
      return _getListEmployeesStack();
    } else if (_buildConfiguration is EmployeeConfiguration) {
      return _getEmployeeStack(_buildConfiguration as EmployeeConfiguration);
    }
    return _getSplashStack();
  }

  List<BasePage> _getSplashStack() => const [SplashPage()];

  List<BasePage> _getListEmployeesStack() => const [ListEmployeesPage()];

  List<BasePage> _getEmployeeStack(EmployeeConfiguration buildConfiguration) =>
      [
        const ListEmployeesPage(),
        EmployeePage(
          buildConfiguration.employeeId,
          buildConfiguration.employeeModel,
        )
      ];

  @override
  Future<void> setNewRoutePath(ScreenConfiguration configuration) async {
    _buildConfiguration = configuration;
  }

  @override
  ScreenConfiguration? get currentConfiguration => _buildConfiguration;
}
