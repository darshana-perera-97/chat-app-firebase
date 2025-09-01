// Firebase Configuration
// Replace these values with your Firebase project configuration
const firebaseConfig = {
    apiKey: "AIzaSyDZWBs4wucLv22ri2PNzf_zFJ0dDTzJ1AE",
    authDomain: "chat-app-89d9f.firebaseapp.com",
    projectId: "chat-app-89d9f",
    storageBucket: "chat-app-89d9f.firebasestorage.app",
    messagingSenderId: "81201995663",
    appId: "1:81201995663:web:137a704673167edc0cf5fa",
    measurementId: "G-YJRTS5SLTZ"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Initialize Firebase services
const auth = firebase.auth();
const db = firebase.firestore();

// Enable offline persistence
db.enablePersistence()
    .catch((err) => {
        if (err.code == 'failed-precondition') {
            console.log('Multiple tabs open, persistence can only be enabled in one tab at a time.');
        } else if (err.code == 'unimplemented') {
            console.log('The current browser does not support persistence.');
        }
    });
