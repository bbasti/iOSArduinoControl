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

### TODO
 * HomeKit Implementation
 * Apple Watch
 * Fix motor slider
 * Implement better error handling

### Results

switch on|off

motion on|off

poti 0..1023

dist -1..4500

### Frameworks used
 * iOS and macOS communicate with the Arduino through the **CoreBluetooth.framework** (to a Bluetooth LE adapter)
 * For Home Automation we used **HomeKit.framework** (brings also support for Siri)
 * For navigation we used **FoldingTabBar.framework**
 * For the sliders we used **SAMultiselectorControl.framework**
