<?php
require_once('dbconnect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['dr_userid']) || isset($_POST['dr_name']) || isset($_POST['designation'])) {
        // Prepare patterns for doctor userid, name, and contact_no
        $dr_userid = isset($_POST['dr_userid']) ? '%' . trim($_POST['dr_userid']) . '%' : null;
        $dr_name = isset($_POST['dr_name']) ? '%' . trim($_POST['dr_name']) . '%' : null;
        $designation = isset($_POST['designation']) ? '%' . trim($_POST['designation']) . '%' : null;

        // Prepare and execute the SQL query
        $query = "SELECT dr_userid, dr_name, designation FROM doctor_profile WHERE (dr_userid LIKE ? OR ? IS NULL) AND (dr_name LIKE ? OR ? IS NULL) AND (designation LIKE ? OR ? IS NULL) ORDER BY designation";
        $stmt = $conn->prepare($query);

        if ($stmt) {
            // Bind parameters and execute the query
            $stmt->bind_param('ssssss', $dr_userid, $dr_userid, $dr_name, $dr_name, $designation, $designation); // 's' for string type
            $stmt->execute();

            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $search = array();
                while ($row = $result->fetch_assoc()) {
                    $search[] = $row;
                }

                // Return search results
                header('Content-Type: application/json');
                echo json_encode(array('status' => true, 'search' => $search));
            } else {
                // No matching doctor found
                header('Content-Type: application/json');
                echo json_encode(array('status' => false, 'message' => 'No doctor found.'));
            }
        } else {
            // Error preparing the SQL statement
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'Error preparing the SQL statement.'));
        }

        $stmt->close();
    } else {
        // Insufficient parameters provided
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a doctor userid, name, or designation.'));
    }
} else {
    // Invalid request method
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

$conn->close();
?>
