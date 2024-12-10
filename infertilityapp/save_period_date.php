<?php
require("dbconnect.php");

// Get the raw POST data
$postData = file_get_contents("php://input");

// Decode the JSON data
$data = json_decode($postData, true);

// Check if JSON decoding was successful
if (json_last_error() === JSON_ERROR_NONE) {
    // Extract userid and date from the decoded data
    $userId = $data['userId'] ?? null;
    $selectedDate = $data['selectedDate'] ?? null;

    // Ensure that userid and date are not null
    if ($userId && $selectedDate) {
        // Insert new record
        $sql = "INSERT INTO datep (userid, datep) VALUES ('$userId', '$selectedDate')";
        
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["message" => "Record inserted successfully"]);
        } else {
            echo json_encode(["message" => "Error: " . $sql . "<br>" . $conn->error]);
        }
    } else {
        echo json_encode(["message" => "Invalid input"]);
    }
} else {
    echo json_encode(["message" => "Invalid JSON input"]);
}

$conn->close();
?>
