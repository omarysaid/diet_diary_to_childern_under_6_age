<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

session_start();
include("./connection/connection.php");

$userAddStatus = "";


if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $postData = json_decode(file_get_contents("php://input"), true);

    $username = $postData['username'];
    $phone = $postData['phone'];
    $password = md5($postData['password']);
      $role = $postData['role'];

    $insert_new_user = "INSERT INTO user (username, phone,password,role) 
                        VALUES ('$username', '$phone','$password','$role')";

    if (mysqli_query($connect, $insert_new_user)) {

        $userAddStatus = "User ($username) added successfully";
        echo json_encode(["status" => "success", "message" => $userAddStatus]);
    } else {

        $userAddStatus = "Error occurred while adding user";
        echo json_encode(["status" => "error", "message" => $userAddStatus]);
    }
}