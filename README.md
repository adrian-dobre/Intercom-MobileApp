# Electra PAS.17A Smart Intercom Adapter - (Flutterbased ) Mobile Application

## Special thanks to [Nicolae Simpalean for inspiration](https://simpalean.site/interfon/)

You can contact him for a ready made solution adapted to you, which you can install yourself or have
Mr. Simpalean send you a new device that "just works" :)
If, however you like DIY work and have time on your hands, you can stay here and read a bit :) and
use these resources free of change :).

If you like my work, and want to give something back, you can
also [Buy me a beer](https://www.paypal.com/donate/?hosted_button_id=LH4JS85SDZPKN)

## What's this about

This is a "smart" adapter tailor made for Electra PAS.17A units, that allows you to get Push
Notifications on your phone whenever your Intercom device is ringing and also control de device via
Talk/Open commands.

Note: It will NOT forward audio to/from device.

## How does it work

The solution is composed from 3 components:

1. A device that interfaces with the Electra device - [see this page](https://github.com/adrian-dobre/Nano33IoT-Electra-Intercom)

2. An application server - [see this page](https://github.com/adrian-dobre/Intercom-Server)

3. A mobile application - this repository contains the source code for the mobile application.

![App Demo](./demo/images/app_demo.gif?raw=true)
![App Settings](./demo/images/app_settings.png?raw=true)
![App Call Log](./demo/images/app_call_log.png?raw=true)

## The "Mobile Application part"

The mobile application connects to the Application Server and can:

- receive Push Notifications from the Application Server
- see the status of the Intercom device (via Rest APIs/WebSockets)
- send Talk/Listen/Open commands to the Intercom device (via WebSockets)
- change the configuration of the Intercom device (via Rest APIs)
- see the call log (via Rest APIs)

It uses [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) for pushing
notifications to the device, but you'll have to configure your own Firebase application access
tokens and add them to your project for all targets you want to use ([android](./android/app) as
google-services.json/[ios](./ios) as GoogleService-Info.plist). For more info, please check official
documentation provided by Firebase
and [Flutter Fire](https://firebase.flutter.dev/docs/messaging/overview/)
or just disable push notifications in the code.
