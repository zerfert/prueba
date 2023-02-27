<?php
session_start();
$_SESSION["user"]='user';
echo "<script type='text/javascript'>
        window.location='inicio.php';
        </script>";
?>