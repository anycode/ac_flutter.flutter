import 'package:ac_flutter/ac_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test routes regexps', () {
    const String path0 = '[/:pid]/vehicles';
    expect(path0.applyRouteArgs({'pid': 'project'}), '/project/vehicles');
    expect(path0.applyRouteArgs({'pid': null}), '/vehicles');
    expect(path0.applyRouteArgs({}), '/vehicles');

    final RegExp path0Re = path0.routeRegExp!;
    expect(path0Re.hasMatch('/vehicles'), true);
    expect(path0Re.hasMatch('//vehicles'), false);
    expect(path0Re.hasMatch('/dphlmp/vehicles'), true);
    expect(path0Re.hasMatch('/dphlmp/dd/vehicles'), false);

    const String path1 = '/[:pid/]vehicles';
    expect(path1.applyRouteArgs({'pid': 'project'}), '/project/vehicles');
    expect(path1.applyRouteArgs({'pid': null}), '/vehicles');
    expect(path1.applyRouteArgs({}), '/vehicles');

    final RegExp path1Re = path1.routeRegExp!;
    expect(path1Re.hasMatch('/vehicles'), true);
    expect(path1Re.hasMatch('//vehicles'), false);
    expect(path1Re.hasMatch('/dphlmp/vehicles'), true);
    expect(path1Re.hasMatch('/dphlmp/dd/vehicles'), false);

    const String path2 = '/[:pid]/vehicles';
    expect(path2.applyRouteArgs({'pid': 'project'}), '/project/vehicles');
    expect(path2.applyRouteArgs({'pid': null}), '//vehicles');
    expect(path2.applyRouteArgs({}), '//vehicles');

    final RegExp path2Re = path2.routeRegExp!;
    expect(path2Re.hasMatch('//vehicles'), true);
    expect(path2Re.hasMatch('/vehicles'), false);
    expect(path2Re.hasMatch('/dphlmp/vehicles'), true);
    expect(path2Re.hasMatch('/dphlmp/dd/vehicles'), false);

    const String path3 = '[/:pid/]vehicles';
    expect(path3.applyRouteArgs({'pid': 'project'}), '/project/vehicles');
    expect(path3.applyRouteArgs({'pid': null}), 'vehicles');
    expect(path3.applyRouteArgs({}), 'vehicles');

    final RegExp path3Re = path3.routeRegExp!;
    expect(path3Re.hasMatch('vehicles'), true);
    expect(path3Re.hasMatch('/vehicles'), false);
    expect(path3Re.hasMatch('/dphlmp/vehicles'), true);
    expect(path3Re.hasMatch('/dphlmp/dd/vehicles'), false);

    const String path4 = '/partner/:pid/detail[/:did]';
    expect(path4.applyRouteArgs({'pid': 'como', 'did': 1}), '/partner/como/detail/1');
    expect(path4.applyRouteArgs({'pid': 'como', 'did': null}), '/partner/como/detail');
    expect(path4.applyRouteArgs({'pid': 'como'}), '/partner/como/detail');
    expect(path4.applyRouteArgs({'pid': null}), '/partner//detail');
    expect(path4.applyRouteArgs({}), '/partner//detail');

  });
}
