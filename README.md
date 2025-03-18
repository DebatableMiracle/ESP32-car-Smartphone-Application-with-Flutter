# ESP32 Car Control with Flutter

This project enables remote control of an RC car using an ESP32 microcontroller and a Flutter-based smartphone application. The system leverages Bluetooth Low Energy (BLE) for communication between the smartphone and the car, facilitating real-time control and feedback.

## Features

- **BLE Communication**: Utilizes BLE to establish a reliable connection between the smartphone and the ESP32-equipped RC car.
- **Flutter Application**: Provides an intuitive interface for controlling the car, including directional movement and speed adjustments.
- **Real-Time Control**: Ensures immediate response to user inputs for a seamless driving experience.

## Getting Started

### Prerequisites

- **ESP32 Development Board**
- **RC Car Chassis**
- **Flutter SDK**
- **Compatible Smartphone**

### Setup Instructions

1. **ESP32 Firmware**:
   - Navigate to the `esp32 code` directory.
   - Upload the provided firmware to the ESP32 using the Arduino IDE or preferred platform.

2. **Flutter Application**:
   - Ensure Flutter is installed on your development machine.
   - Open the project in your preferred IDE.
   - Run `flutter pub get` to install dependencies.
   - Build and install the application on your smartphone.

3. **Hardware Assembly**:
   - Integrate the ESP32 board with the RC car chassis, connecting motors and power supply as per the schematic provided in the `assets/images` directory.

4. **Operation**:
   - Power on the ESP32 and the RC car.
   - Launch the Flutter application on your smartphone.
   - Establish a BLE connection between the app and the ESP32.
   - Use the on-screen controls to operate the car.


## Contributors
<a href="https://github.com/DebatableMiracle">
  <img src="https://github.com/DebatableMiracle.png" width="50" height="50" alt="DebatableMiracle">
</a>
<a href="https://github.com/01bps">
  <img src="https://github.com/01bps.png" width="50" height="50" alt="01bps">
</a>

- **[Anubhav Verma](https://github.com/DebatableMiracle)** - Main Developer
- **[01bps](https://github.com/01bps)** - Contributor


## License

This project is licensed under the MIT License.

## Acknowledgements

Special thanks to the open-source community for resources and inspiration.

For further information and updates, visit the [GitHub repository](https://github.com/01bps/ESP32-car-Smartphone-Application-with-Flutter). 
