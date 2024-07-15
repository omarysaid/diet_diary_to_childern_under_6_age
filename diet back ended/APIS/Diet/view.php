<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Content-Type: application/json");

include("./connection/connection.php");

try {
    
    $sql = "SELECT * FROM diet ORDER BY diet_id DESC";
    $result = $connect->query($sql);

    if ($result->num_rows > 0) {
        $diets = array();
        while ($row = $result->fetch_assoc()) {
            $diet = array(
                "diet_id" => $row["diet_id"],
                "from_age" => $row["from_age"],
                "to_age" => $row["to_age"],
                "from_weight" => $row["from_weight"],
                "to_weight" => $row["to_weight"],
                "name" => $row["name"],
                "description" => $row["description"],
                "image" => "http://192.168.120.183/dietDiary/APIS/Diet/uploads/" . $row["image"] 
            );
            array_push($diets, $diet);
        }
        echo json_encode(array("success" => true, "diets" => $diets));
    } else {
        echo json_encode(array("success" => false, "message" => "No diets found."));
    }
} catch (Exception $e) {
   
    echo json_encode(array("success" => false, "message" => "An error occurred: " . $e->getMessage()));
} finally {
   
    $connect->close();
}