<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("./connection/connection.php");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $user_id = $_POST["user_id"];
    $from_age = $_POST["from_age"];
    $to_age = $_POST["to_age"];
    $from_weight = $_POST["from_weight"];
    $to_weight = $_POST["to_weight"];
    $name = $_POST["name"];
    $description = $_POST["description"];

    $imageData = file_get_contents($_FILES['image']['tmp_name']);
    $fileName = $_FILES['image']['name'];
    $targetDir = "./uploads/";
    $targetFilePath = $targetDir . $fileName;
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $targetFilePath)) {
        
        $sql = "INSERT INTO diet (user_id, from_age, to_age, from_weight, to_weight, name, description, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $connect->prepare($sql);
        $stmt->bind_param("ssssssss", $user_id, $from_age, $to_age, $from_weight, $to_weight, $name, $description, $fileName);
        if ($stmt->execute()) {
            echo json_encode(array("success" => true, "message" => "Diet details added successfully."));
        } else {
            echo json_encode(array("success" => false, "message" => "Error occurred while adding diet details."));
        }
        $stmt->close();
    } else {
        echo json_encode(array("success" => false, "message" => "Sorry, there was an error uploading your file."));
    }
}
?>