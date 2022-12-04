library precision_stopwatch;

import 'package:fast_log/fast_log.dart';

typedef AsyncVoidCallback<T> = Future<void> Function();
typedef SyncVoidCallback<T> = void Function();
typedef AsyncVoidCallbackR<T> = Future<T> Function();
typedef SyncVoidCallbackR<T> = T Function();
typedef ProfileReporterCallback = void Function(double ms);

extension XFuture<T> on Future<T> {
  Future<T> profiled({String? tag, ProfileReporterCallback? reporter}) async {
    PrecisionStopwatch p = PrecisionStopwatch.start();
    T t = await this;
    double ms = p.getMilliseconds();

    if (reporter != null) {
      reporter(ms);
    } else {
      verbose("${tag ?? "Runner"} took ${ms.toStringAsFixed(2)}ms");
    }

    return t;
  }
}

double precisionProfile(SyncVoidCallbackR cb) {
  PrecisionStopwatch p = PrecisionStopwatch.start();
  cb();
  return p.getMilliseconds();
}

Future<double> precisionProfileAsync(AsyncVoidCallbackR cb) async {
  PrecisionStopwatch p = PrecisionStopwatch.start();
  await cb();
  return p.getMilliseconds();
}

T precisionProfileResult<T>(SyncVoidCallbackR<T> cb,
    {String? tag, ProfileReporterCallback? reporter}) {
  PrecisionStopwatch p = PrecisionStopwatch.start();
  T t = cb();
  double ms = p.getMilliseconds();

  if (reporter != null) {
    reporter(ms);
  } else {
    verbose("[PSW] ${tag ?? "Runner"} took ${ms.toStringAsFixed(2)}ms");
  }
  return t;
}

Future<T> precisionProfileAsyncResult<T>(AsyncVoidCallbackR<T> cb,
    {String? tag, ProfileReporterCallback? reporter}) async {
  PrecisionStopwatch p = PrecisionStopwatch.start();
  T t = await cb();
  double ms = p.getMilliseconds();

  if (reporter != null) {
    reporter(ms);
  } else {
    verbose("[PSW]${tag ?? "Runner"} took ${ms.toStringAsFixed(2)}ms");
  }

  return t;
}

class PrecisionStopwatch {
  int _nanos = 0;
  int _startNano = 0;
  int _millis = 0;
  int _startMillis = 0;
  double _time = 0;
  bool _profiling = false;

  PrecisionStopwatch() {
    reset();
    _profiling = false;
  }

  static PrecisionStopwatch start() {
    PrecisionStopwatch p = PrecisionStopwatch();
    p.begin();

    return p;
  }

  void begin() {
    _profiling = true;
    _startNano = DateTime.now().microsecondsSinceEpoch;
    _startMillis = DateTime.now().millisecondsSinceEpoch;
  }

  void end() {
    if (!_profiling) {
      return;
    }

    _profiling = false;
    _nanos = DateTime.now().microsecondsSinceEpoch - _startNano;
    _millis = DateTime.now().millisecondsSinceEpoch - _startMillis;
    _time = _nanos / 1000.0;
    _time = ((_millis - _time) > 1.01 ? _millis : _time).toDouble();
  }

  void reset() {
    _nanos = -1;
    _millis = -1;
    _startNano = -1;
    _startMillis = -1;
    _time = -0;
    _profiling = false;
  }

  double getTicks() {
    return getMilliseconds() / 50.0;
  }

  double getSeconds() {
    return getMilliseconds() / 1000.0;
  }

  double getMinutes() {
    return getSeconds() / 60.0;
  }

  double getHours() {
    return getMinutes() / 60.0;
  }

  double getMilliseconds() {
    _nanos = DateTime.now().microsecondsSinceEpoch - _startNano;
    _millis = DateTime.now().millisecondsSinceEpoch - _startMillis;
    _time = _nanos / 1000.0;
    _time = ((_millis - _time) > 1.01 ? _millis : _time).toDouble();
    return _time;
  }

  int getNanoseconds() {
    return (_time * 1000.0).round();
  }

  int getNanos() {
    return _nanos;
  }

  int getStartNano() {
    return _startNano;
  }

  int getMillis() {
    return _millis;
  }

  int getStartMillis() {
    return _startMillis;
  }

  double getTime() {
    return _time;
  }

  bool isProfiling() {
    return _profiling;
  }

  void rewind(int l) {
    _startMillis -= l;
  }
}
