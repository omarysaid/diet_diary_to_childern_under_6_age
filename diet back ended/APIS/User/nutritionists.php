<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Content-Type: application/json");

include("../Diet/connection/connection.php");

try {
    $nutritionistId = isset($_GET['nutritionistId']) ? intval($_GET['nutritionistId']) : null;
    $sql = "
        SELECT 
            u.user_id,
            u.username, 
            u.phone, 
            u.role,
            d.diet_id,
            d.from_age,
            d.to_age,
            d.from_weight,
            d.to_weight,
            d.name AS diet_name,
            d.description AS diet_description,
            d.image AS diet_image
        FROM 
            user u
        LEFT JOIN 
            diet d ON u.user_id = d.user_id";

    if ($nutritionistId !== null) {
        $sql .= " WHERE u.user_id = ? AND u.role = 'Nutritionist'";
    } else {
        $sql .= " WHERE u.role = 'Nutritionist'";
    }

    $sql .= " ORDER BY u.username ASC";

    $stmt = $connect->prepare($sql);

    if ($nutritionistId !== null) {
        $stmt->bind_param("i", $nutritionistId);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $nutritionists = array();
        while ($row = $result->fetch_assoc()) {
            $user_id = $row["user_id"];
            if (!isset($nutritionists[$user_id])) {
                $nutritionists[$user_id] = array(
                    "id" => $user_id,
                    "username" => $row["username"],
                    "phone" => $row["phone"],
                    "role" => $row["role"],
                    "diets" => array()
                );
            }

            if ($row["diet_id"]) {
                $diet = array(
                    "diet_id" => $row["diet_id"],
                    "from_age" => $row["from_age"],
                    "to_age" => $row["to_age"],
                    "from_weight" => $row["from_weight"],
                    "to_weight" => $row["to_weight"],
                    "name" => $row["diet_name"],
                    "description" => $row["diet_description"],
                      "image" => "http://192.168.120.183/dietDiary/APIS/Diet/uploads/" . $row["diet_image"] 
                
                );
                $nutritionists[$user_id]["diets"][] = $diet;
            }
        }

        // Filter out nutritionists without diets
        $nutritionists_with_diets = array_filter($nutritionists, function($nutritionist) {
            return !empty($nutritionist["diets"]);
        });

        if (count($nutritionists_with_diets) > 0) {
            echo json_encode(array("success" => true, "nutritionists" => array_values($nutritionists_with_diets)));
        } else {
            echo json_encode(array("success" => false, "message" => "No nutritionists with diets found."));
        }
    } else {
        echo json_encode(array("success" => false, "message" => "No nutritionists found."));
    }
} catch (Exception $e) {
    echo json_encode(array("success" => false, "message" => "An error occurred: " . $e->getMessage()));
} finally {
    if (isset($stmt)) {
        $stmt->close();
    }
    if (isset($connect)) {
        $connect->close();
    }
}
?>