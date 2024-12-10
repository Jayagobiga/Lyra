<?php
require_once('dbconnect.php'); // Include your database connection

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the POST data
$userid = $_POST['Userid'] ?? ''; // Ensure 'Userid' is set
$date = $_POST['date'] ?? '';
$endometrium_thickness = $_POST['endometrium_thickness'] ?? '';
$follicular_diameter = $_POST['follicular_diameter'] ?? '';
$RI = $_POST['RI'] ?? '';
$PSV = $_POST['PSV'] ?? '';
$perifollicular_rate = $_POST['perifollicular_rate'] ?? '';
$FSH = $_POST['FSH'] ?? '';
$LH = $_POST['LH'] ?? '';
$TSH = $_POST['TSH'] ?? '';
$Prolactin = $_POST['Prolactin'] ?? '';
$AMH = $_POST['AMH'] ?? '';
$HSG_report = $_POST['HSG_report'] ?? '';

// Debugging: Log received data
error_log("Received data: Userid=$userid, date=$date");

// Check if 'Userid' is provided
if (empty($userid)) {
    echo json_encode(array("status" => false, "message" => "Userid is required"));
    exit;
}

// Check if report already exists for this user and date
$stmt_check = $conn->prepare("SELECT * FROM addreport WHERE Userid = ? AND date = ?");
$stmt_check->bind_param("ss", $userid, $date);
$stmt_check->execute();
$result = $stmt_check->get_result();

if ($result->num_rows > 0) {
    // Update the existing record
    $stmt_update = $conn->prepare("UPDATE addreport SET endometrium_thickness = ?, follicular_diameter = ?, RI = ?, PSV = ?, perifollicular_rate = ?, FSH = ?, LH = ?, TSH = ?, Prolactin = ?, AMH = ?, HSG_report = ? WHERE Userid = ? AND date = ?");
    $stmt_update->bind_param("sssssssssssss", $endometrium_thickness, $follicular_diameter, $RI, $PSV, $perifollicular_rate, $FSH, $LH, $TSH, $Prolactin, $AMH, $HSG_report, $userid, $date);

    if ($stmt_update->execute()) {
        echo json_encode(array("status" => true, "message" => "Report updated successfully"));
    } else {
        echo json_encode(array("status" => false, "message" => "Failed to update report: " . $stmt_update->error));
    }
} else {
    // Insert a new record
    $stmt_insert = $conn->prepare("INSERT INTO addreport (Userid, date, endometrium_thickness, follicular_diameter, RI, PSV, perifollicular_rate, FSH, LH, TSH, Prolactin, AMH, HSG_report) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt_insert->bind_param("sssssssssssss", $userid, $date, $endometrium_thickness, $follicular_diameter, $RI, $PSV, $perifollicular_rate, $FSH, $LH, $TSH, $Prolactin, $AMH, $HSG_report);

    if ($stmt_insert->execute()) {
        echo json_encode(array("status" => true, "message" => "Report saved successfully"));
    } else {
        echo json_encode(array("status" => false, "message" => "Failed to save report: " . $stmt_insert->error));
    }
}

$stmt_check->close();
$conn->close();
?>
