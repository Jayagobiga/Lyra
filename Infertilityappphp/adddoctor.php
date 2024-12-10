<?php
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate if all fields are provided
    $required_fields = ['dr_userid', 'dr_name', 'contact_no', 'email', 'designation'];

    foreach ($required_fields as $field) {
        if (empty($_POST[$field])) {
            $response = array('status' => false, 'message' => 'All fields are required.');
            echo json_encode($response);
            exit; // Stop execution if any field is empty
        }
    }

    // Get input data from the application
    $dr_userid = $_POST['dr_userid'];
    $dr_name = $_POST['dr_name'];
    $contact_no = $_POST['contact_no'];
    $email = $_POST['email'];
    $designation = $_POST['designation'];
    $doctorimage = ""; // Initialize image path variable

    // Check if an image file is uploaded
    if (isset($_FILES['doctorimage'])) {
        $file_name = $_FILES['doctorimage']['name'];
        $file_tmp = $_FILES['doctorimage']['tmp_name'];
        $file_ext_arr = explode('.', $_FILES['doctorimage']['name']);
        $file_ext = strtolower(end($file_ext_arr));

        $extensions = array("jpeg", "jpg", "png");

        if (in_array($file_ext, $extensions) === false) {
            $response = array('status' => false, 'message' => 'Image extension not allowed, please choose a JPEG or PNG file.');
            echo json_encode($response);
            exit;
        }

        // Generate a unique name for the image
        $image_name = uniqid() . '.' . $file_ext;

        // Move uploaded file to the specified folder
        $upload_path = "doctor_image/" . $image_name;
        if (move_uploaded_file($file_tmp, $upload_path)) {
            $doctorimage = $upload_path; // Update image path variable
        } else {
            $response = array('status' => false, 'message' => 'Error uploading image.');
            echo json_encode($response);
            exit;
        }
    }

    // Check if the dr_userid already exists in doctor_profile
    $check_sql = "SELECT dr_userid FROM doctor_profile WHERE dr_userid = '$dr_userid'";
    $check_result = $conn->query($check_sql);

    if ($check_result->num_rows > 0) {
        // Update data in the doctor_profile table
        $update_sql = "UPDATE doctor_profile SET dr_name = '$dr_name', contact_no = '$contact_no', email = '$email', designation = '$designation'";
        if (!empty($doctorimage)) {
            $update_sql .= ", doctorimage = '$doctorimage'";
        }
        $update_sql .= " WHERE dr_userid = '$dr_userid'";

        if ($conn->query($update_sql) === TRUE) {
            // Successful update
            $response = array('status' => true, 'message' => 'Doctor details updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // Insert new data into the doctor_profile table
        $insert_sql = "INSERT INTO doctor_profile (dr_userid, dr_name, contact_no, email, designation, doctorimage) VALUES ('$dr_userid', '$dr_name', '$contact_no', '$email', '$designation', '$doctorimage')";

        if ($conn->query($insert_sql) === TRUE) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Doctor details added successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
