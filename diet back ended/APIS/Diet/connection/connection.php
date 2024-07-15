<?php
//connection Open
$servername = "localhost";
$username = "root";
$password = "";
$db_name = "dietdiary_db";



$connect = mysqli_connect($servername, $username, $password, $db_name);

if (!$connect) {


    die("connection failure try again" . mysqli_connect_error());
}