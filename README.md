# iOS Arduino Control (WIP)

School project for an Arduino which is going to be controlled via Bluetooth on the iPhone or iPad.

#### Work allocation

  * Damir: UI on the iDevice (iPhone,iPad)
  * Christoph: UI on the Apple Watch + Communication with Damir's UI
  * Basti: Convenience layer between Philipp's Bluetooth API and UI
       * Write to motor (0...180)
       * Turn LED on or off
       * Read distance value (-1...4500)
       * Read button state
       * Read motion sensor
       * Read potentiometer value (0...1023)
  * Philipp: Backend Bluetooth Communication
    * Start scan
    * Stop scan
    * Connect
    * Read 
    * Write

HomeKit implementation!!! (ex. Siri turn on the motor)

### Results

switch on|off
motion on|off
poti 0..1023
dist -1..4500

### Source control

Either use source control which is directly built into XCode or use the Github.app for committing. You could also use the scripts which were kindly provided by Christoph.

Usage:

```sh
$ ./push commitMessage
```
```sh
$ ./pull
```

### Usage of BluetoothKit class

First you need to conform to the BluetoothReceiver protocol

```swift
class BastisClass: BluetoothReceiver {

//Store all those CBPeripherals somewhere in a list and call the connect(peripheral) when someone clicked on it in a ListView
func bluetoothManager(didReceiveBroadcastForDevice name: String, uuid: String, peripheral: CBPeripheral) //This is being called when a new device was discovered
func bluetoothManager(didReceiveDataFromDevice data: String) //This will be called as soon as the device is connected with the data as parameter
}
```

Now the usage:
```swift
let bluetoothKit = BluetoothKit.sharedManager
bluetoothKit.brDelegate = self

//broadcastManager will be called everytime I found a new device after startScan() was called
bluetoothKit.startScan() //Returns false if brDelegate was not set or timeout was hit
bluetoothKit.stopScan()

bluetoothKit.startReading("uuid-of-hells-device") //stopScan() is being called here, no need to call it again
bluetoothKit.write("help", "uuid-of-hells-device")
```
