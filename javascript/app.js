import { GoogleAuthProvider, signInWithPopup } from "https://www.gstatic.com/firebasejs/9.10.0/firebase-auth.js"
import { auth } from "./firebase.js";

const googleButton = document.querySelector("#loginBtn");
googleButton.addEventListener("click", async (e) => {
  e.preventDefault();

  const provider = new GoogleAuthProvider();
  try {
    const credentials = await signInWithPopup(auth, provider)
    console.log(credentials);
    console.log("google sign in");
    window.location= './log.php';
  } catch (error) {
    console.log(error);
    alert('Error de inicio de sesion, vuelve a intentarlo');
    window.location= './index.html';
  }
});

const microsoftButton = document.querySelector("#microsoftBtn");
microsoftButton.addEventListener("click", (e) => {
  e.preventDefault();

});





