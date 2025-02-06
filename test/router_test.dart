import 'package:ac_flutter/ac_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test routes regexps', () {
    const String vehicles = '[/:pid]/vehicles';
    expect(vehicles.applyRouteArgs({'pid': 'project'}), '/project/vehicles');
    expect(vehicles.applyRouteArgs({'pid': null}), '/vehicles');
    expect(vehicles.applyRouteArgs({}), '/vehicles');

    final RegExp vehiclesRe = vehicles.routeRegExp!;
    expect(vehiclesRe.hasMatch('/vehicles'), true);
    expect(vehiclesRe.hasMatch('//vehicles'), false);
    expect(vehiclesRe.hasMatch('/dphlmp/vehicles'), true);
    expect(vehiclesRe.hasMatch('/dphlmp/dd/vehicles'), false);
  });
}
