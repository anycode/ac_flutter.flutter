import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'ac_loader.dart';
import 'ac_widget_builder.dart';

typedef _Stream<T> = Stream<T> Function(T fetched);

/// [AcLoadingBuilder] allow fetching data asynchronously from a [Future]<T> or a [Stream]<T>.
/// When [future] is specified, [stream] must be null or a function which takes a
/// value obtained from [future] and returns a [Stream]<T>.
/// When [future] is null, [stream] must be a [Stream]<T>.
/// Use [AcSliverLoadingBuilder] if you need to use it in slivers.
class AcLoadingBuilder<T> extends StatelessWidget {
  /// [future] is a [Future]<T?> whose value is passed to [builder] (if [stream] is null) or as
  /// a seed value to [stream] which must be [Stream<T> Function(T seed)]
  final Future<T?>? future;

  /// [stream] is either a [Stream]<T> (if [future] is null) or a [Stream<T> Function(T seed)]
  /// seeded by a value from [future] (if [future] is not null)
  final dynamic stream;

  /// [seed] is an optional seed value for [future] or [stream].
  final T? seed;

  /// [builder] is a called with a value from [future] or [stream]. If [seed] is not
  /// null, it's called with this value until there's other value available.
  final TypedWidgetBuilder<T> builder;

  /// [loadingBuilder] is called when there is no value available yet from [future] or [stream]
  /// and [seed] was not set
  final WidgetBuilder? loadingBuilder;

  /// [emptyBuilder] is called when there are empty data (no value, empty list, empty map)
  final WidgetBuilder? emptyBuilder;

  /// [errorBuilder] is called when there is an error
  final TypedWidgetBuilder? errorBuilder;

  const AcLoadingBuilder({
    super.key,
    this.future,
    this.stream,
    this.seed,
    required this.builder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
  })  : assert((future != null && (stream == null || stream is _Stream<T?>)) || (future == null && stream is Stream<T?>),
            'either `future` or `stream` must be set, when `future` is set `stream` must be `null` or `Stream<$T> Function($T? seed)`'),
        super();

  @override
  Widget build(BuildContext context) {
    if (future != null && stream != null && stream is _Stream<T?>) {
      // both Future and Stream are specified, first call seeded FutureBuilder to fetch a value which is then seeded to a stream
      return _FutureBuilder<T>(
        future: future!,
        seed: seed,
        builder: (context, fetched) => _StreamBuilder<T>(
          stream: (stream! as _Stream<T?>)(fetched),
          seed: fetched,
          builder: builder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          emptyBuilder: emptyBuilder,
        ),
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        emptyBuilder: emptyBuilder,
        inSlivers: false,
      );
    } else if (future != null) {
      return _FutureBuilder<T>(
        future: future!,
        builder: builder,
        loadingBuilder: loadingBuilder,
        emptyBuilder: emptyBuilder,
        errorBuilder: errorBuilder,
        seed: seed,
        inSlivers: false,
      );
    } else {
      return _StreamBuilder<T>(
        stream: stream! as Stream<T?>,
        builder: builder,
        loadingBuilder: loadingBuilder,
        emptyBuilder: emptyBuilder,
        errorBuilder: errorBuilder,
        seed: seed,
        inSlivers: false,
      );
    }
  }
}

/// [AcSliverLoadingBuilder] allow fetching data asynchronously from a [Future]<T> or a [Stream]<T>.
/// It has the very same functionality as [AcLoadingBuilder] but it's suitable for use in slivers.
/// When [future] is specified, [stream] must be null or a function which takes a
/// value obtained from [future] and returns a [Stream]<T>.
/// When [future] is null, [stream] must be a [Stream]<T>.
class AcSliverLoadingBuilder<T> extends StatelessWidget {
  /// [future] is a [Future]<T> whose value is passed to [builder] (if [stream] is null) or as
  /// a seed value to [stream] which must be [Stream<T> Function(T seed)]
  final Future<T>? future;

  /// [stream] is either a [Stream]<T> (if [future] is null) of a [Stream<T> Function(T seed)]
  /// seeded by a value from [future] (if [future] is not null)
  final dynamic stream;

  /// [seed] is an optional seed value for [future] or [stream].
  final T? seed;

  /// [builder] is a called with a value from [future] or [stream]. If [seed] is not
  /// null, it's called with this value until there's other value available.
  /// Must return a [Sliver]
  final TypedWidgetBuilder<T> builder;

  /// [loadingBuilder] is called when there is no value available yet from [future] or [stream]
  /// and [seed] was not set
  /// Must return a [Sliver]
  final WidgetBuilder? loadingBuilder;

  /// [emptyBuilder] is called when there are empty data (no value, empty list, empty map)
  /// Must return a [Sliver]
  final WidgetBuilder? emptyBuilder;

  /// [errorBuilder] is called when there is an error
  /// Must return a [Sliver]
  final TypedWidgetBuilder? errorBuilder;

  const AcSliverLoadingBuilder({
    super.key,
    this.future,
    this.stream,
    this.seed,
    required this.builder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
  })  : assert((future != null && (stream == null || stream is _Stream<T>)) || (future == null && stream is Stream<T>),
            'either `future` or `stream` must be set, when `future` is set `stream` must be `null` or `Stream<T> Function(T? seed)`'),
        super();

  @override
  Widget build(BuildContext context) {
    if (future != null && stream != null && stream is _Stream<T>) {
      // both Future and Stream are specified, first call seeded FutureBuilder to fetch a value which is then seeded to a stream
      return _FutureBuilder<T>(
        future: future!,
        seed: seed,
        builder: (context, fetched) => _StreamBuilder<T>(
          stream: (stream! as _Stream<T>)(fetched),
          seed: fetched,
          builder: builder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          emptyBuilder: emptyBuilder,
        ),
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        emptyBuilder: emptyBuilder,
        inSlivers: true,
      );
    } else if (future != null) {
      return _FutureBuilder<T>(
        future: future!,
        builder: builder,
        loadingBuilder: loadingBuilder,
        emptyBuilder: emptyBuilder,
        errorBuilder: errorBuilder,
        seed: seed,
        inSlivers: true,
      );
    } else {
      return _StreamBuilder<T>(
        stream: stream! as Stream<T>,
        builder: builder,
        loadingBuilder: loadingBuilder,
        emptyBuilder: emptyBuilder,
        errorBuilder: errorBuilder,
        seed: seed,
        inSlivers: true,
      );
    }
  }
}

class _ErrorWidget extends ErrorWidget {
  _ErrorWidget(Object? error) : super(error ?? 'Unknown error') {
    if (error != null) {
      if (error is Error) {
        debugPrintStack(stackTrace: error.stackTrace, label: error.toString());
      } else {
        debugPrint(error.toString());
      }
    } else {
      debugPrint('Unknown error');
    }
  }
}

class _FutureBuilder<T> extends StatelessWidget {
  final Future<T?> future;
  final T? seed;
  final TypedWidgetBuilder<T> builder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final TypedWidgetBuilder? errorBuilder;
  final bool inSlivers;

  const _FutureBuilder({
    super.key,
    required this.future,
    this.seed,
    required this.builder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    required this.inSlivers,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return seed != null ? builder(context, seed as T) : loadingBuilder?.call(context) ?? _slivered(const Center(child: AcLoader()));
        } else if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error) ?? _slivered(SizedBox(height: 128, child: _ErrorWidget(snapshot.error!)));
        } else if (snapshot.hasData) {
          if (snapshot.data == null || snapshot.data is Map && (snapshot.data as Map).isEmpty || snapshot.data is List && (snapshot.data as List).isEmpty) {
            return emptyBuilder?.call(context) ?? _slivered(Container());
          } else {
            return builder(context, snapshot.data as T);
          }
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (null is T) {
            return builder(context, null as T);
          } else {
            return emptyBuilder?.call(context) ?? _slivered(Container());
          }
        } else {
          return seed != null ? builder(context, seed as T) : loadingBuilder?.call(context) ?? _slivered(const Center(child: AcLoader()));
        }
      },
    );
  }

  Widget _slivered(Widget widget) {
    return inSlivers ? SliverToBoxAdapter(child: widget) : widget;
  }
}

class _StreamBuilder<T> extends StatelessWidget {
  final Stream<T?> stream;
  final T? seed;
  final TypedWidgetBuilder<T> builder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final TypedWidgetBuilder? errorBuilder;
  final bool? inSlivers;

  const _StreamBuilder(
      {super.key,
      required this.stream,
      this.seed,
      required this.builder,
      this.loadingBuilder,
      this.emptyBuilder,
      this.errorBuilder,
      this.inSlivers});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
      stream: seed != null ? stream.startWith(seed as T) : stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return seed != null ? builder(context, seed as T) : loadingBuilder?.call(context) ?? _slivered(const Center(child: AcLoader()));
        } else if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error) ?? _slivered(SizedBox(height: 128, child: _ErrorWidget(snapshot.error!)));
        } else if (snapshot.hasData) {
          if (snapshot.data == null || snapshot.data is Map && (snapshot.data as Map).isEmpty || snapshot.data is List && (snapshot.data as List).isEmpty) {
            return emptyBuilder?.call(context) ?? _slivered(Container());
          } else {
            return builder(context, snapshot.data as T);
          }
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (null is T) {
            return builder(context, null as T);
          } else {
            return emptyBuilder?.call(context) ?? _slivered(Container());
          }
        } else {
          return loadingBuilder?.call(context) ?? _slivered(const Center(child: AcLoader()));
        }
      },
    );
  }

  Widget _slivered(Widget widget) {
    return (inSlivers ?? false) ? SliverToBoxAdapter(child: widget) : widget;
  }
}
