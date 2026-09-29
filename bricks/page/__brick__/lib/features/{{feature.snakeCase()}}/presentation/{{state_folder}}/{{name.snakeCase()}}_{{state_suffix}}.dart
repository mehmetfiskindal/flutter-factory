{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';

final {{name.camelCase()}}ControllerProvider =
    AsyncNotifierProvider<{{name.pascalCase()}}Controller, String>(
  {{name.pascalCase()}}Controller.new,
);

class {{name.pascalCase()}}Controller extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return '{{name.titleCase()}} ready';
  }
}
{{/is_riverpod}}{{#is_bloc}}
import 'package:flutter_bloc/flutter_bloc.dart';

class {{name.pascalCase()}}Cubit extends Cubit<String> {
  {{name.pascalCase()}}Cubit() : super('{{name.titleCase()}} ready');
}
{{/is_bloc}}
{{#is_native}}
import 'package:flutter/foundation.dart';

final class {{name.pascalCase()}}ViewModel extends ChangeNotifier {
  String _title = '{{name.titleCase()}} ready';
  bool _isLoading = false;

  String get title => _title;
  bool get isLoading => _isLoading;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(Duration.zero);
    _title = '{{name.titleCase()}} refreshed';
    _isLoading = false;
    notifyListeners();
  }
}
{{/is_native}}
