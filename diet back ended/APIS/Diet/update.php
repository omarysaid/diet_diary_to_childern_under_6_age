<?php

include("./connection/connection.php");


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $diet_id = $_POST['diet_id'];
    $from_age = $_POST['from_age'];
    $to_age = $_POST['to_age'];
    $from_weight = $_POST['from_weight'];
    $to_weight = $_POST['to_weight'];
    $name = $_POST['name'];
    $description = $_POST['description'];


    $diet_id = mysqli_real_escape_string($connect, $diet_id);
    $query = "SELECT * FROM diet WHERE diet_id = '$diet_id'";
    $result = mysqli_query($connect, $query);

    if(mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);

       
        if(isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
            $image = $_FILES['image'];
            $uploadPath = "./uploads/"; 
            $imageName = basename($image["name"]);
            $targetFilePath = $uploadPath . $imageName;
            $fileType = pathinfo($targetFilePath, PATHINFO_EXTENSION);

          
            $check = getimagesize($image["tmp_name"]);
            if($check !== false) {
              
                $allowedTypes = array('jpg', 'jpeg', 'png', 'gif');
                if(in_array($fileType, $allowedTypes)){
                   
                    if(move_uploaded_file($image["tmp_name"], $targetFilePath)){
                       
                        $sql = "UPDATE diet SET 
                                    from_age = '$from_age',
                                    to_age = '$to_age',
                                    from_weight = '$from_weight',
                                    to_weight = '$to_weight',
                                    name = '$name',
                                    description = '$description',
                                    image = '$imageName'
                                WHERE diet_id = '$diet_id'";
                        
                        if (mysqli_query($connect, $sql)) {
                            echo json_encode(array("success" => true, "message" => "Record updated successfully"));
                        } else {
                            echo json_encode(array("success" => false, "message" => "Error updating record: " . mysqli_error($connect)));
                        }
                    } else {
                        echo json_encode(array("success" => false, "message" => "Error uploading image"));
                    }
                } else {
                    echo json_encode(array("success" => false, "message" => "File format not supported"));
                }
            } else {
                echo json_encode(array("success" => false, "message" => "File is not an image"));
            }
        } else {
           
            $sql = "UPDATE diet SET 
                        from_age = '$from_age',
                        to_age = '$to_age',
                        from_weight = '$from_weight',
                        to_weight = '$to_weight',
                        name = '$name',
                        description = '$description'
                    WHERE diet_id = '$diet_id'";
                    
            if (mysqli_query($connect, $sql)) {
                echo json_encode(array("success" => true, "message" => "Record updated successfully"));
            } else {
                echo json_encode(array("success" => false, "message" => "Error updating record: " . mysqli_error($connect)));
            }
        }
    } else {
        echo json_encode(array("success" => false, "message" => "Diet not found"));
    }
} else {
  
    http_response_code(405);
    echo json_encode(array("success" => false, "message" => "Method Not Allowed"));
}
?>