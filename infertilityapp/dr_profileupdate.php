<?php
require_once('dbconnect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate if the required fields are present in the form data
    if (isset($_POST['userId'])) {
        $userId = trim($_POST['userId']);

        // Check if the doctor with the provided ID exists
        $sql = "SELECT * FROM doctor_profile WHERE dr_userid = '$userId'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // Get the existing doctor details
            $doctorDetails = $result->fetch_assoc();

            // Update the doctor's profile only for the fields provided
            $updateFields = array();
            if (isset($_POST['dr_name'])) {
                $updateFields[] = "dr_name = '" . $_POST['dr_name'] . "'";
            }
            if (isset($_POST['email'])) {
                $updateFields[] = "email = '" . $_POST['email'] . "'";
            }
            if (isset($_POST['password'])) {
                $updateFields[] = "password = '" . $_POST['password'] . "'";
            }
            if (isset($_POST['designation'])) {
                $updateFields[] = "designation = '" . $_POST['designation'] . "'";
            }
            if (isset($_POST['contact_no'])) {
                $updateFields[] = "contact_no = '" . $_POST['contact_no'] . "'";
            }
            if (isset($_FILES['doctorimage'])) {
                $file_name = $_FILES['doctorimage']['name'];
                $file_temp = $_FILES['doctorimage']['tmp_name'];
                $file_path = 'doctor_image/' . $file_name;

                // Move uploaded image to doctor_image directory
                if(move_uploaded_file($file_temp, $file_path)) {
                    $updateFields[] = "doctorimage = '" . $file_path . "'";
                } else {
                    header('Content-Type: application/json');
                    echo json_encode(array('status' => false, 'message' => 'Failed to move uploaded image.'));
                    exit;
                }
            }

            // Construct the update query
            if (!empty($updateFields)) {
                $updateSql = "UPDATE doctor_profile SET " . implode(", ", $updateFields) . " WHERE dr_userid = '$userId'";
                if ($conn->query($updateSql) === TRUE) {
                    header('Content-Type: application/json');
                    echo json_encode(array('status' => true, 'message' => 'Doctor profile updated successfully'));
                    exit;
                } else {
                    header('Content-Type: application/json');
                    echo json_encode(array('status' => false, 'message' => 'Error updating doctor profile: ' . $conn->error));
                    exit;
                }
            } else {
                header('Content-Type: application/json');
                echo json_encode(array('status' => true, 'message' => 'No fields provided for update'));
                exit;
            }
        } else {
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'No doctor found with the provided dr_userid.'));
            exit;
        }
    } else {
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a userId.'));
        exit;
    }
} else {
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
    exit;
}

$conn->close();
?>
