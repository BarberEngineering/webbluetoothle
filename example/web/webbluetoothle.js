let device;
let characteristic;
let charServiceUUID = 0x180F;
let gattServer;
let batteryLevel = 0;

// let's us see JS console.logs in flutter land
window.logger = (flutter_value) => {
    console.log({ js_context: this, flutter_value });
}

// checkBleHardware needs to be called first to ensure the hardware is supported
// Returns true if machine has bluetooth hardware, false if not
// Doesn't seem to check if hardware is 'on' or 'off'
function checkBleHardware() {
    return navigator.bluetooth.getAvailability();
}

// connectBleDevice shows a prompt to the user to select a device
async function connectBleDevice() {

    try {
        // Reset Battery Level
        batteryLevel = 0;

        console.log('Requesting Bluetooth device...');
        device = await navigator.bluetooth.requestDevice({
            // filters: [...] <- Use filters to show relevant devices
            // filters: [{services: [serviceUUID]}],
            // standard UUIDS: https://www.bluetooth.com/specifications/assigned-numbers/

            // see all devices but cant connect without specifying optionalServices:
            acceptAllDevices: true,

            // Must specify an optional service or it won't let you connect
            // see 'Name Filter' on https://web.dev/bluetooth/
            optionalServices: [
                'battery_service'
            ],
        });

        console.log('> Requested ' + device.name + ' (' + device.id.toString(16) + ')');

        console.log('> Connecting to GATT Server...');
        gattServer = await device.gatt.connect();

        console.log('> Getting Service...');
        const service = await gattServer.getPrimaryService('battery_service');

        // Want to see what services are available?
        // const services = await server.getPrimaryServices();

        console.log('> Getting Characteristics...');
        characteristic = await service.getCharacteristic('battery_level');

        batt = await characteristic.readValue()
        console.log('> Battery Value: ' + batt.getUint8() + '%')
        batteryLevel = await batt.getUint8()

        return batt
    } catch (error) {
        console.log('connectBleDevice() error: ' + error);
        return error;
    }
}

// start listening for notifications from the given characteristic
function listenForCharNotifications() {

    // await characteristic.startNotifications();
    // console.log('> Notifications started');

    characteristic.addEventListener('characteristicvaluechanged', charHandler);

    // Handler to take the bytes from BLE and send them to Dart/Flutter
    function charHandler(event) {
        window.dartFuncWithBytesInput(event.target.value);
    }
}

async function getBatteryLevel() {
    batteryLevel = 0;
    batt = await characteristic.readValue()
    console.log('> Battery Value: ' + batt.getUint8() + '%')
    return batt.getUint8()
}

function stopListener() {
    try {
        characteristic.stopNotifications();
        device.gatt.disconnect();
    } catch (e) {
        console.log(e);
    }
}
