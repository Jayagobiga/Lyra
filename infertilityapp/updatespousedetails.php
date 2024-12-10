<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $contactno = $_POST['contactno'];
    $age = $_POST['age'];
    $height = $_POST['height'];
    $weight = $_POST['weight'];
    $bloodgroup = $_POST['bloodgroup'];
    $medicalhistory = $_POST['medicalhistory'];

    // Check if the user_id already exists in addspouse
    $check_sql = "SELECT Userid FROM addspouse WHERE Userid = '$userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // User exists, perform the update
        $update_sql = "UPDATE addspouse SET 
                        Name = '$name',
                        Contactnumber = '$contactno',
                        Age = '$age',
                        Height = '$height',
                        Weight = '$weight',
                        Bloodgroup = '$bloodgroup',
                        Medicalhistory = '$medicalhistory'
                      WHERE Userid = '$userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => 'success', 'message' => 'spouse details updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User doesn't exist, return an error response
        $response = array('status' => 'error', 'message' => 'User does not exist. You can only update existing users.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => 'error', 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
