<?php
// Include your database connection code here
require_once('dbconnect.php');

// Enable error reporting for debugging purposes
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Define the function to create a directory if it does not exist
function createDirectory($path) {
    if (!is_dir($path)) {
        if (!mkdir($path, 0777, true)) {
            throw new Exception('Failed to create directory: ' . $path);
        }
    }
}

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve form data from $_POST
    $username = $_POST['dr_userid'] ?? '';
    $name = $_POST['dr_name'] ?? '';
    $mobilenumber = $_POST['contact_no'] ?? '';
    $password = $_POST['password'] ?? '';
    $repassword = $_POST['repassword'] ?? '';
    $email = $_POST['email'] ?? '';
    $designation = $_POST['designation'] ?? '';

    // Initialize image path as null (no image uploaded)
    $imagePath = null;

    // Handle file upload
    if (isset($_FILES['doctorimage']) && $_FILES['doctorimage']['error'] === UPLOAD_ERR_OK) {
        // Define the image file path
        $imagePath = 'doctor_image/' . $username . '.jpg';

        // Create the 'doc' directory if it doesn't exist
        try {
            createDirectory(dirname($imagePath));
        } catch (Exception $e) {
            error_log($e->getMessage());
            echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
            exit();
        }

        // Read the binary data of the uploaded image
        $imageFile = $_FILES['doctorimage']['tmp_name'];
        $imageData = file_get_contents($imageFile);

        // Check if file_get_contents was successful
        if ($imageData === false) {
            echo json_encode(['status' => 'error', 'message' => 'Failed to read image data.']);
            exit();
        }

        // Attempt to write the image data to the file
        if (file_put_contents($imagePath, $imageData) === false) {
            echo json_encode(['status' => 'error', 'message' => 'Failed to write image data to file.']);
            exit();
        }

        error_log("Image data successfully written to file: $imagePath");
    }

    // Insert the data into the database
    $sql = "INSERT INTO doctor_profile (dr_userid, dr_name,email,contact_no, password,repassword,doctorimage,designation) 
    VALUES ('$username', '$name','$email', '$mobilenumber', '$password','$repassword','$imagePath','$designation')";


    // Execute the query and check for success
    if ($conn->query($sql) === TRUE) {
        // Output a success response
        echo json_encode(['status' => 'success', 'message' => 'User registration successful.']);
    } else {
        // Output an error response
        echo json_encode(['status' => 'error', 'message' => 'Error: ' . $conn->error]);
        error_log("Database insertion error: " . $conn->error);
    }
} else {
    // Return an error response for non-POST requests
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

// Close the database connection
$conn->close();
error_log("Database connection closed.");
?>