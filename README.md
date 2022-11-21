A precision stopwatch to measure the difference in time (timestamps) using both milliseconds AND nanoseconds, then combining the difference in nanos to give the milliseconds decimal accuracy. If the millisecond measurement is over the limit for what nanoseconds can hold in an integer, a flat double milliseconds will be returned instead.

## Features

* Precision Stopwatch profiling
* Sync / Async callable profiling
* Sync / Async callable profiling with result

## Usage

```dart
import 'package:precision_stopwatch/precision_stopwatch.dart';

void main() {
  // Basic stopwatch usage
  PrecisionStopwatch stopwatch = PrecisionStopwatch.start();
  func();
  // We dont need to actually stop the stopwatch, it's just a timestamp
  print(stopwatch.getMilliseconds()); // Prints 3.64621 (for example)
  print(stopwatch.getMillis()); // Prints 3 (flat millis)
  print(stopwatch.getNanos()); // Prints the nanoseconds measured
  stopwatch.reset(); // Reset the stopwatch to now (for reuse if needed)
  
  // Callables to get the milliseconds from a call inline
  double ms = stopwatch.precisionProfile(() => func());
  Future<double> = stopwatch.precisionProfileAsync(() => await asyncFunc());
  
  // Callables to print the milliseconds if kDebugMode is enabled
  String name = stopwatch.precisionProfileResult(() => getName(), 
  tag: "Get Name");
  // Returns the value and prints "[PSW] Get Name: 3.64ms" if kDebugMode is enabled
  Future<String> = stopwatch.precisionProfileAsyncResult(
  () => await getNameAsync(), tag: "Get Name");
  // Returns the value and prints "[PSW] Get Name: 3.64ms" if kDebugMode is enabled
  
  // You can also use custom printing
  String name = stopwatch.precisionProfileResult(() => getName(), 
      tag: "Get Name", 
      reporter: (ms) => doSomethingWith(ms));
  
  // You can also use the future extension
  getNameAsync().profile(
      tag: "Get Name", 
      reporter: (ms) => doSomethingWith(ms));
  ).then((name) => print(name));
}

String getName() => "A name";

Future<String> getNameAsync() async => "A name";

void func()
{
  // expensive call
}

Future<void> asyncFunc() async
{
  // expensive call
}
```