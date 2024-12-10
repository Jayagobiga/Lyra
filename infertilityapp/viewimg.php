<?php
require_once('dbconnect.php');
$response = array(); // Initialize the response array

if (isset($_GET['userid'])) {
    // Retrieve the 'userid' parameter value from the URL
    $userid = $_GET['userid'];

    // Prepare the SQL query
    $sql = "SELECT * FROM uploadimage WHERE Userid = ? ORDER BY date DESC";
    $stmt = mysqli_prepare($conn, $sql);

    // Bind the parameter to the prepared statement
    mysqli_stmt_bind_param($stmt, "s", $userid);

    // Execute the statement
    mysqli_stmt_execute($stmt);

    $result = mysqli_stmt_get_result($stmt);

    if ($result->num_rows > 0) {
        $response['status'] = true;
        $response['message'] = "Data found";
        $response['images'] = array();

        while ($row = $result->fetch_assoc()) {
            // Check if image path is not empty before including it in the response
            $imagePath = $row["image"];
            
            if (!empty($imagePath)) {
                // Assuming your images are stored in a directory named "videos"
                $baseUrl = 'http://14.139.187.229:8081/Infertilityapp/';
                $imageUrl = $baseUrl . $imagePath; // Corrected URL construction
                $date = $row["date"];
                
                $response['images'][] = array(
                    'url' => $imageUrl,
                    'date' => $date
                );
            }
        }
    } else {
        $response['status'] = false;
        $response['message'] = "No results found";
    }
} else {
    // If 'userid' parameter is not set, handle the error accordingly
    $response['status'] = false;
    $response['message'] = "'userid' parameter not found in the request.";
}

$conn->close();

// Convert PHP array to JSON and output the response without escaping slashes
echo json_encode($response, JSON_UNESCAPED_SLASHES);
?>
