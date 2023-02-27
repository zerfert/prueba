<?php
session_start();
$inactivo=300;
if(isset($_SESSION['timeout'])){
 $session_life=time() - $_SESSION['timeout'];
  if($session_life>$inactivo){
  	session_destroy();
  	header("location:index.html");
  }
}
$_SESSION['timeout']=time();
if($_SESSION['user']){
?>
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8">
      <link rel="stylesheet " href="css/styleschat.css">
      <link rel="icon" type="image/png" href="https://cdn-icons-png.flaticon.com/512/625/625769.png">
      <title>Chatbot Educativo</title>
      <style>
        body {
          background-image: url('https://fondosmil.com/fondo/35293.jpg');
        }
        h1 {
          color: white;
          text-shadow: 2px 2px 2px;
          font-size: 26px; /* tamaño de fuente predeterminado */
          text-align: left; /* alinear el texto al centro */
        }
        h3 {
          color: white;
          font-size: 24px; /* tamaño de fuente predeterminado */
          text-align: left; /* alinear el texto al centro */
        }
        /* media query para dispositivos móviles */
        @media only screen and (max-width: 600px) {
          h1 {
            font-size: 46px; /* tamaño de fuente reducido */
            text-align: center;
          }
          h3 {
            font-size: 40px; /* tamaño de fuente reducido */
            text-align: center;
          }
        }
        @media only screen and (max-width: 400px) {
          /* reglas CSS para dispositivos aún más pequeños */
          h1 {
            font-size: 24px;
            margin-top: 50px;
          }
          h3 {
            font-size: 18px;
          }
        }
      </style>
    </head>
    <body>
      <h1>Chabot Educativo</h1>
      <h3>Este es un Chatbot creado especificamente un curso de Ingenieria de software.</h3>
      <ul>
      <li><a href='./salir.php'><span>Cerrar Sesion</span></a></li>
      </ul>
      <div id="chat-container"></div>

      <script src="javascript/scriptui.js"></script>

      <script>
      createChatBot(host = 'http://192.168.100.85:5005/webhooks/rest/webhook',
      botLogo = "icons/icon.png",
      title = "Chatbot educativo ", welcomeMessage = "Bienvenido al chat",
      inactiveMsg = "El servicio esta fuera de servicio, pronto se volvera activar",
      theme="blue")
      </script>
    </body>
  </html>
<?php
}else{
	echo "<script type='text/javascript'>
     alert('No se pudo acceder');
     window.location='index.html';
     </script>";
}
?>