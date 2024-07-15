<?php

include("./connection/connection.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");


if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $diet_id = $_GET['diet_id'];


    $diet_id = mysqli_real_escape_string($connect, $diet_id); 
    $sql = "DELETE FROM diet WHERE diet_id = '$diet_id'";
    if (mysqli_query($connect, $sql)) {
        echo "Record deleted successfully";
    } else {
        echo "Error deleting record: " . mysqli_error($connect);
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    

    http_response_code(200);
} else {


    http_response_code(405);
    echo "Method Not Allowed";
}
?>