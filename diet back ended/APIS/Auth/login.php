<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

session_start();
include("./connection/connection.php");


if ($_SERVER["REQUEST_METHOD"] === "POST") {
  
    $postData = json_decode(file_get_contents("php://input"), true);

  
    if (isset($postData['username']) && isset($postData['password'])) {
        $username = $postData['username'];
        $password = $postData['password'];

       
        $sql = "SELECT * FROM user WHERE username=? AND password=?";
        $stmt = $connect->prepare($sql);

      
        if ($stmt) {
        
            $stmt->bind_param("ss", $username, $hashedPassword);

           
            $hashedPassword = md5($password);

           
            $stmt->execute();

            
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $_SESSION['user_id'] = $row['user_id'];
                $_SESSION['username'] = $row['username'];
                $_SESSION['role'] = $row['role'];

            
                $response = array();
                $response['success'] = true;
                $response['message'] = 'Login successful';
                 $response['user_id'] = $row['user_id'];
                $response['role'] = $row['role'];
                $response['username'] = $row['username']; 
                $response['phone'] = $row['phone']; 
            
                echo json_encode($response);
            } else {
               
                $response = array();
                $response['success'] = false;
                $response['message'] = 'Wrong username or password. Please try again.';
                echo json_encode($response);
            }
        } else {
            
            $response = array();
            $response['success'] = false;
            $response['message'] = 'Failed to prepare SQL statement.';
            echo json_encode($response);
        }
    } else {
      
        $response = array();
        $response['success'] = false;
        $response['message'] = 'Username or password missing in request.';
        echo json_encode($response);
    }
}