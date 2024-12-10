<?php
    // Include the database connection configuration
    require_once('dbconnect.php');

    // Create an associative array to hold the API response
    $response = array();

    try {
        // Check if the request method is POST
        if ($_SERVER["REQUEST_METHOD"] === "POST") {
            // SQL query to fetch patient information
            $sql = "SELECT Userid, Name, ContactNo FROM addpatient";

            // Prepare the SQL query
            $stmt = $conn->prepare($sql);

            // Execute the query
            $stmt->execute();

            // Get the result set from the prepared statement
            $result = $stmt->get_result();

            // Fetch all rows as an associative array
            $data = $result->fetch_all(MYSQLI_ASSOC);

            if (count($data) > 0) {
                $response['status'] = true;
                $response['data'] = $data;
            } else {
                $response['status'] = false;
                $response['message'] = "0 results";
            }
        } else {
            $response['status'] = false;
            $response['message'] = "Invalid request method. Only POST requests are allowed.";
        }
    } catch (Exception $e) {
        // Handle any exceptions
        $response['status'] = false;
        $response['message'] = "Error: " . $e->getMessage();
    }

    // Convert the response array to JSON and echo it
    header('Content-Type: application/json');
    echo json_encode($response);

    // Close the statement and database connection
    $stmt->close();
    $conn->close();
    ?>
