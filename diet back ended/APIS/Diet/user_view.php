<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Content-Type: application/json");

include("./connection/connection.php");

if (isset($_GET['username']) && isset($_GET['phone'])) {
    $username = $_GET['username'];
    $phone = $_GET['phone'];

    try {
        // Prepare SQL query
        $sql = "SELECT u.username, u.phone, d.from_age, d.to_age, d.from_weight, d.to_weight, d.name, d.description, d.image 
                FROM diet d
                JOIN user u ON d.user_id = u.user_id
                WHERE u.username = ? AND u.phone = ?
                ORDER BY d.diet_id DESC";
        $stmt = $connect->prepare($sql);

        // Bind parameters and execute query
        $stmt->bind_param("ss", $username, $phone);
        $stmt->execute();

        // Get result set
        $result = $stmt->get_result();

        // Process results
        if ($result->num_rows > 0) {
            $diets = array();
            while ($row = $result->fetch_assoc()) {
                // Build diet details array
                $diet = array(
                    "username" => $row["username"],
                    "phone" => $row["phone"],
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
            echo json_encode(array("success" => false, "message" => "No diets found for this user."));
        }
    } catch (Exception $e) {
        // Handle exceptions
        echo json_encode(array("success" => false, "message" => "An error occurred: " . $e->getMessage()));
    } finally {
        // Clean up resources
        $stmt->close();
        $connect->close();
    }
} else {
    // Handle missing parameters
    echo json_encode(array("success" => false, "message" => "Missing username or phone number."));
}
