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
        // Extract userId and selectedDate from the decoded data
        $userId = $data['userId'] ?? null;
        $selectedDate = $data['date'] ?? null;

        // Ensure that userId and selectedDate are not null
        if ($userId && $selectedDate) {
            // Calculate fertile period
            $fertileStartDate = date('Y-m-d', strtotime($selectedDate . ' + 14 days'));
            $fertileEndDate = date('Y-m-d', strtotime($selectedDate . ' + 18 days'));

            // Include your database connection file
            require("con.php"); // Adjust the path as necessary

            // Insert or update the fertile period in the database
            // Assuming you have a table `cycleupdate2` with columns `userId`, `date`, `fertileStartDate`, and `fertileEndDate`
            $sql = "INSERT INTO cycleupdate2 (userId, date, fertileStartDate, fertileEndDate) VALUES ('$userId', '$selectedDate', '$fertileStartDate', '$fertileEndDate') ON DUPLICATE KEY UPDATE date='$selectedDate', fertileStartDate='$fertileStartDate', fertileEndDate='$fertileEndDate'";
            if ($conn->query($sql) === TRUE) {
                echo json_encode([
                    "userId" => $userId,
                    "date" => $selectedDate,
                    "fertileStartDate" => $fertileStartDate,
                    "fertileEndDate" => $fertileEndDate,
                    "message" => "Fertile period saved successfully"
                ]);
            } else {
                echo json_encode(["message" => "Error saving fertile period: " . $conn->error]);
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
