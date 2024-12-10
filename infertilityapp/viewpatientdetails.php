<?php
require_once('dbconnect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['userId'])) {
        $userId = trim($_POST['userId']);

        $sql = "SELECT * FROM addpatient WHERE UserId = '$userId'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            $patientDetails = $result->fetch_assoc();
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'patientDetails' => $patientDetails));
        } else {
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'No patient found with the provided UserId.'));
        }
    } else {
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a userId.'));
    }
} else {
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

$conn->close();
?>
