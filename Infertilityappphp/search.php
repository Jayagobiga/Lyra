<?php
require_once('dbconnect.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['userid']) || isset($_POST['name'])) {
        // Prepare patterns for userid and name
        $userid = isset($_POST['userid']) ? '%' . trim($_POST['userid']) . '%' : null;
        $name = isset($_POST['name']) ? '%' . trim($_POST['name']) . '%' : null;

        $query = "SELECT Userid, Name, ContactNo FROM addpatient WHERE (Userid LIKE ? OR ? IS NULL) AND (Name LIKE ? OR ? IS NULL)";
        $stmt = $conn->prepare($query);

        if ($stmt) {
            // Bind parameters and execute the query
            $stmt->bind_param('ssss', $userid, $userid, $name, $name); // 's' for string type
            $stmt->execute();

            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $search = array();
                while ($row = $result->fetch_assoc()) {
                    $search[] = $row;
                }

                header('Content-Type: application/json');
                echo json_encode(array('status' => true, 'search' => $search));
            } else {
                header('Content-Type: application/json');
                echo json_encode(array('status' => false, 'message' => 'No patient found.'));
            }
        } else {
            header('Content-Type: application/json');
            echo json_encode(array('status' => false, 'message' => 'Error preparing the SQL statement.'));
        }

        $stmt->close();
    } else {
        header('Content-Type: application/json');
        echo json_encode(array('status' => false, 'message' => 'Please provide a userid or name.'));
    }
} else {
    header('Content-Type: application/json');
    echo json_encode(array('status' => false, 'message' => 'Invalid request method.'));
}

$conn->close();
?>
