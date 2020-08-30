# LittleBlueToothTestApp
Test application for LittleBlueTooth iOS library

## Installation
* Clone the repo
* Download the [LightBlue application](https://apps.apple.com/it/app/lightblue/id557428110) for macOS or iOS
* Go into _Virtual Devices_ tab press on `+` select `Heart Rate` and press `Save`, now you have a simulated hearth rate monitor
* Build and run the project on a device
* Tap on `Connect` and on `Listen` and you will see the heart rate change from time to time

*NOTE* Before reading the sensor position you __must__ set a value inside the LightBlue sensor simulation, to do that select the simulated peripheral, scroll down to the `Body sensor location` select and where is written no value put and hex value from 0x00 to 0x06
## About LittleBlueTooth
You can download the full project [here](https://github.com/DrAma999/LittleBlueTooth).
