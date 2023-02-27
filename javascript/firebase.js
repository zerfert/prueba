import { initializeApp } from "https://www.gstatic.com/firebasejs/9.10.0/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/9.10.0/firebase-auth.js"
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.10.0/firebase-firestore.js"

const firebaseConfig = {
    apiKey: "AIzaSyAmfcj3vOwlsZfkkAq4ZRCA5tdt1LDO8-8",
    authDomain: "chatbotedu-375202.firebaseapp.com",
    databaseURL: "https://chatbotedu-375202-default-rtdb.firebaseio.com",
    projectId: "chatbotedu-375202",
    storageBucket: "chatbotedu-375202.appspot.com",
    messagingSenderId: "1070089261577",
    appId: "1:1070089261577:web:4ffdd48350fcaf5939ded8",
    measurementId: "G-J0B3BFCSC4"
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app)
export const db = getFirestore(app)