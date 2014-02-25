objCVCD
=======

A VCD parser aiming to support IEEE 1364-1995.


Usage
-----

### Opening a document

To load an VCD file from local storage use

```objC
[VCD loadWithPath:filePath callback:^(VCD *vcd) {
	if(vcd == nil) {
		NSLog(@"VCD Parsing Error!");
		return;
	}
	
	// ...
}];
```

To load a VCD file from a web based location, use

```objC
[VCD loadWithURL:[NSURL URLWithString:@"http://your.location/test.vcd"] callback:^(VCD *vcd) {
	if(vcd == nil) {
		NSLog(@"VCD Parsing Error!");
		return;
	}
	
	// ...
}];
```

To simplify prototyping, we support a list of sample VCD files which can
be accessed by this piece of code:

```objC
NSDictionary *samples = [VCD loadAvailableSamples];

for(NSString title in [samples allKeys]) {
	NSURL *url = [samples objectForKey:title];
	
	NSLog(@"Title: %@; URL: %@", title, url);
}
```
Please keep in mind, that loadAvailableSamples uses blocking I/O.

#### Elements of VCD:

* ```[VCD loadWithPath:path callback:^(VCD *vcd) { /* ... */}]```: Loads VCD from NSString path and calls callback
* ```[VCD loadWithURL:url callback:^(VCD *vcd) { /* ... */}]```: Loads VCD from NSURL and calls callback
* ```[VCD loadAvailableSamples]```: Loads NSDictionary of samples of NSURLs and NSString as its key.
* ```[vcd signals]```: returns NSDictionary of signals, identified by signal name
* ```[vcd timeScale]```: returns int of timescale factor
* ```[vcd timeScaleUnit]```: returns NSString of timescale unit (e.g. `ns`)
* ```[vcd date]```: returns NSDate of creation
* ```[vcd version]```: returns NSString version
* ```[vcd scope]```: returns NSString scope

### Accessing Signals

```objC
VCD *vcd = nil;

// Magically loading a VCD file
// ...

for(VCDSignal *signal in [[vcd signals] allValues]) {
	NSLog("Name of signal: %@", [signal name]);
}
```

#### Elements of VCDSignal:
* ```[signal name]```: returns NSString name of signal
* ```[signal symbol]```: returns NSString symbol of signal
* ```[signal symbol]```: returns NSString symbol of signal
* ```[vcd valueAtTime:time]```: returns value at specific time.

### Accessing Signal Values

```objC
VCDSignal *signal = nil;

// Magically loads VCD Signal
// ...

// Access value at specific time.
// Please note, that valueAtTime does NOT respect the timescale!
VCDValue *v = [signal valueAtTime:500];

NSLog(@"First ValueChange at %d", [v time]);
// The VCDValue will be the value current value at that point in time.
// This means valueAtTime will search for the very next value before the
// given time.
// Therefore, [v time] will be lesser equal 500.

// Iterate through values:
do {
	NSLog("ValueChange at: %d: newValue: %@", [v time], [v value]);
} while(v = [v next]);

// Or in short:
for(VCDValue *v = [signal valueAtTime:500]; v != nil; v = [v next]) {
	// ...
}
```
