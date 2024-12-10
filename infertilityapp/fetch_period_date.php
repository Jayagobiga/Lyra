<?php
// Ensure that CORS headers allow requests from your Flutter app domain
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Enable error reporting for debugging (only for development, disable in production)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log all request details for debugging
error_log("Request method: " . $_SERVER["REQUEST_METHOD"]);
error_log("Content type: " . $_SERVER["CONTENT_TYPE"] ?? 'undefined');
error_log("Request headers: " . print_r(getallheaders(), true));
error_log("Raw POST data: " . file_get_contents("php://input"));

// Check if it's a POST request with JSON data
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_SERVER["CONTENT_TYPE"]) && strpos($_SERVER["CONTENT_TYPE"], "application/json") !== false) {
    
    // Get the raw POST data
    $postData = file_get_contents("php://input");

    // Decode the JSON data
    $data = json_decode($postData, true);

    // Log decoded JSON data for debugging
    error_log("Decoded JSON: " . print_r($data, true));

    // Check if JSON decoding was successful
    if (json_last_error() === JSON_ERROR_NONE) {
        
        // Extract userId from the decoded data
        $userId = $data['userid'] ?? null;

        // Ensure that userId is not null
        if ($userId) {
            // Include your database connection file
            require("dbconnect.php"); // Adjust the path as necessary

            // Log the userId being used for query
            error_log("User ID: " . $userId);

            // Query to fetch all dates for the given userId
            $sql = "SELECT datep FROM datep WHERE userid='$userId'";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                // Fetch all dates
                $dates = [];
                while ($row = $result->fetch_assoc()) {
                    $dates[] = $row['datep'];
                }
                // Return the dates as a JSON response
                echo json_encode(["dates" => $dates]);
            } else {
                // No records found for this userId
                echo json_encode(["message" => "No records found for userId: $userId"]);
            }

            // Close the database connection
            $conn->close();
        } else {
            // If userId is null or not provided
            echo json_encode(["message" => "Invalid input: userId missing"]);
        }
    } else {
        // If JSON decoding failed
        echo json_encode(["message" => "Invalid JSON input"]);
    }
} else {
    // If the request is not POST or not JSON
    echo json_encode(["message" => "Invalid request. Expected POST with JSON data"]);
}
?>
