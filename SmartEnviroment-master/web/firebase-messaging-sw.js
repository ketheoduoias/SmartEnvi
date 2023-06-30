importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
    apiKey: "AIzaSyDZUra8Uh6Bgv3VuPqQMfVsC9gUIjbGf_4",
    authDomain: "smartenviroment.firebaseapp.com",
    projectId: "smartenviroment",
    storageBucket: "smartenviroment.appspot.com",
    messagingSenderId: "86534504753",
    appId: "1:86534504753:web:ee8ddb5fc22d6f4cf3b010",
    measurementId: "G-73V9V9P3H7"
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
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
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});