// Wait for the deviceready event before using any of Cordova's device APIs.
// See https://cordova.apache.org/docs/en/latest/cordova/events/events.html#deviceready
document.addEventListener('deviceready', onDeviceReady, false);

// DON'T DO IT IN PRODUCTION
const watchProperty = (object, prop, callback) => {
    object[`__${prop}`] = object[prop];
    delete object[prop];
    Object.defineProperty(object, prop, {
        get() {
            return this[`__${prop}`];
        },
        set(v) {
            this[`__${prop}`] = v;
            callback(v);
        }
    });
}

const checkStatus = (hashedSubscriberId) => {
    const statusEl = document.getElementById('sdk-status');
    if (hashedSubscriberId) {
        statusEl.innerHTML = 'connected to Solitics SDK';
        statusEl.classList.add('connected');
    } else {
        statusEl.innerHTML = 'disconnected';
        statusEl.classList.remove('connected');
    }
}

const updateSdkConnectionStatus = () => {
    checkStatus($solitics.solitics_configuration?.hashedSubscriberId);

    watchProperty($solitics, 'solitics_configuration', (val) => {
        checkStatus(val?.hashedSubscriberId);
    });
}

function onDeviceReady() {
    updateSdkConnectionStatus();

    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);

    document.getElementById('deviceready').classList.add('ready');

    document.getElementById('sdk-login-form').addEventListener('submit', event => {
        event.preventDefault();
        const {memberId, email, brand, token} = event.currentTarget.elements;
        $solitics.onLoginSuccess(memberId.value, email.value, brand.value, token.value);
    });

    document.getElementById('logout').addEventListener('click', () => $solitics.onLogout());
}
