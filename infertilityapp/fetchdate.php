<?php
// Ensure that CORS headers allow requests from your Flutter app domain
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Log all request details for debugging
error_log("Request method: " . $_SERVER["REQUEST_METHOD"]);
error_log("Content type: " . $_SERVER["CONTENT_TYPE"]);
error_log("Request headers: " . print_r(getallheaders(), true));
error_log("Raw POST data: " . file_get_contents("php://input"));

// Check if it's a POST request with JSON data
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_SERVER["CONTENT_TYPE"]) && strpos($_SERVER["CONTENT_TYPE"], "application/json") !== false) {
    // Get the raw POST data
    $postData = file_get_contents("php://input");

    // Decode the JSON data
    $data = json_decode($postData, true);

    // Check if JSON decoding was successful
    if (json_last_error() === JSON_ERROR_NONE) {
        // Extract userId from the decoded data
        $userId = $data['userId'] ?? null;

        // Ensure that userId is not null
        if ($userId) {
            // Include your database connection file
            require("dbconnect.php"); // Adjust the path as necessary

            // Query to fetch the date for the given userId
            $sql = "SELECT date FROM cycleupdate2 WHERE userid='$userId'";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                // Fetch the date
                $row = $result->fetch_assoc();
                $selectedDate = $row['date'];
                echo json_encode(["selectedDate" => $selectedDate]);
            } else {
                echo json_encode(["message" => "No record found for userId: $userId"]);
            }

            $conn->close();
        } else {
            echo json_encode(["message" => "Invalid input"]);
        }
    } else {
        echo json_encode(["message" => "Invalid JSON input"]);
    }
} else {
    echo json_encode(["message" => "Invalid request"]);
}
?>
