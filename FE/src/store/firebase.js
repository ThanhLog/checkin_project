// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBdTZrxx3jVyuLOx6gTVWSLiquQ9soxfkM",
  authDomain: "smes-34a34.firebaseapp.com",
  projectId: "smes-34a34",
  storageBucket: "smes-34a34.firebasestorage.app",
  messagingSenderId: "28582999679",
  appId: "1:28582999679:web:2e3a56a0ca714796ed314a",
  measurementId: "G-DCJPCSZBXY",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth(app);
const db = getFirestore(app);

export { auth, analytics, db };
