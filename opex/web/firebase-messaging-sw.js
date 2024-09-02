importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

const firebaseConfig = {
  apiKey: "AIzaSyDD6a93rw23pGVSYc9MipHVExobYqIzke0",
  authDomain: "sidrateams-d9972.firebaseapp.com",
  projectId: "sidrateams-d9972",
  storageBucket: "sidrateams-d9972.appspot.com",
  messagingSenderId: "793852669363",
  appId: "1:793852669363:web:89668f6104adf08bccafc6",
  measurementId: "G-DZFYRLTM7X"
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };
});
messaging.setBackgroundMessageHandler(function (payload) {
 console.log('SET background message ', payload);
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});