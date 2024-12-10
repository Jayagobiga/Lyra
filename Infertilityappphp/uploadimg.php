<?php
require_once('dbconnect.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate and sanitize Userid
    $Userid = isset($_POST['Userid']) ? trim($_POST['Userid']) : '';

    if (empty($Userid)) {
        // Invalid or empty Userid, return an error response
        $response = array('status' => false, 'message' => 'Invalid or empty Userid.');
        echo json_encode($response);
        exit;
    }

    $targetDirectory = "videos/";

    function uploadImages($fieldName) {
        global $targetDirectory;
        $result = [];

        // Check if the field name exists and if it's an array
        if (isset($_FILES[$fieldName]) && is_array($_FILES[$fieldName]["name"])) {
            foreach ($_FILES[$fieldName]["name"] as $key => $value) {
                $extension = pathinfo($value, PATHINFO_EXTENSION);
                $uniqueFileName = uniqid("img_", true) . '.' . $extension;
                $targetFile = $targetDirectory . $uniqueFileName;
                if (move_uploaded_file($_FILES[$fieldName]["tmp_name"][$key], $targetFile)) {
                    $result[] = $targetFile;
                } else {
                    $result[] = null;
                }
            }
        } elseif (isset($_FILES[$fieldName])) {
            // If there's only one file, treat it as an array
            $extension = pathinfo($_FILES[$fieldName]["name"], PATHINFO_EXTENSION);
            $uniqueFileName = uniqid("img_", true) . '.' . $extension;
            $targetFile = $targetDirectory . $uniqueFileName;
            if (move_uploaded_file($_FILES[$fieldName]["tmp_name"], $targetFile)) {
                $result[] = $targetFile;
            } else {
                $result[] = null;
            }
        }
        return $result;
    }

    $imagePaths = isset($_FILES["image"]) ? uploadImages("image") : [];

    // Check if at least one image was uploaded
    if (empty($imagePaths)) {
        // No images uploaded, return an error response
        $response = array('status' => false, 'message' => 'No images uploaded. Please select at least one image.');
        echo json_encode($response);
        exit;
    }

    // Get the cycleupdate date
    $cycleupdateDateSql = "SELECT date FROM cycleupdate2 WHERE Userid = ?";
    $stmt = $conn->prepare($cycleupdateDateSql);
    $stmt->bind_param("s", $Userid);
    $stmt->execute();
    $cycleupdateDateResult = $stmt->get_result();

    if ($cycleupdateDateResult === false) {
        // Error in the query
        $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
        echo json_encode($response);
    } elseif ($cycleupdateDateResult->num_rows > 0) {
        $cycleupdateDateRow = $cycleupdateDateResult->fetch_assoc();
        $cycleupdateDate = $cycleupdateDateRow['date'];

        // Log the cycleupdateDate for debugging
        error_log("Cycleupdate Date: " . $cycleupdateDate);

        // Calculate the difference in days
        $uploadImageDate = date('Y-m-d'); // Format: 2024-02-19

        // Try different date formats for cycleupdate date
        $formats = ['Y-m-d', 'Y/m/d', 'd-m-Y', 'd/m/Y'];
        $cycleupdateDateTime = false;

        foreach ($formats as $format) {
            $cycleupdateDateTime = DateTime::createFromFormat($format, $cycleupdateDate);
            if ($cycleupdateDateTime !== false) {
                break;
            }
        }

        if ($cycleupdateDateTime === false) {
            $response = array('status' => false, 'message' => 'Error parsing cycleupdate date.');
            echo json_encode($response);
            exit;
        }

        // Convert both dates to DateTime objects to handle time zone issues
        $uploadImageDateTime = new DateTime($uploadImageDate);

        $interval = $uploadImageDateTime->diff($cycleupdateDateTime);
        $diffInDays = $interval->days + 2;

        // Construct a prepared statement to prevent SQL injection
        $sql = "INSERT INTO uploadimage (Userid, image, date) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE image=VALUES(image), date=VALUES(date)";

        // Prepare the statement
        $stmt = $conn->prepare($sql);

        if ($stmt) {
            // Iterate through image paths
            foreach ($imagePaths as $imagePath) {
                // Bind parameters
                $stmt->bind_param("sss", $Userid, $imagePath, $uploadImageDate);

                // Execute the statement for each image
                if ($stmt->execute()) {
                    // Successful insertion/update
                    $response = array('status' => true, 'message' => 'Image upload successful.');
                    echo json_encode($response);
                } else {
                    // Error in database insertion/update
                    $response = array('status' => false, 'message' => 'Error: ' . $stmt->error);
                    echo json_encode($response);
                    error_log('Error executing SQL: ' . $stmt->error);
                }
            }

            // Close the statement
            $stmt->close();
        } else {
            // Error in preparing the statement
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }
    } else {
        // User doesn't exist in cycleupdate, return an error response
        $response = array('status' => false, 'message' => 'User does not exist in cycleupdate. You can only upload images for existing users.');
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
