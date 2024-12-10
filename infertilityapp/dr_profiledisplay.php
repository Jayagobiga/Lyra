<?php
require_once('dbconnect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['dr_userid'])) {
        $dr_userid = trim($_POST['dr_userid']);

        $sql = "SELECT * FROM doctor_profile WHERE dr_userid = '$dr_userid'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            $doctorDetails = $result->fetch_assoc();
            header('Content-Type: application/json');
            echo json_encode(array('status' => true, 'doctorDetails' => $doctorDetails));
        } else {
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'No doctor found with the provided dr_userid.'));
        }
    } else {
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a dr_userid.'));
    }
} else {
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

$conn->close();
?>
