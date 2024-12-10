<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $userid = $_POST['userid'] ?? null;
    $name = $_POST['name'] ?? null;
    $contactno = $_POST['contactno'] ?? null;
    $age = $_POST['age'] ?? null;
    $occupation = $_POST['occupation'] ?? null;
    $significanthistory = $_POST['significanthistory'] ?? null;
    $smoking = $_POST['smoking'] ?? null;
    $alcohol = $_POST['alcohol'] ?? null;
    $sexualdisfunction = $_POST['sexualdisfunction'] ?? null;
    $volume = $_POST['Volume'] ?? null;
    $concentration = $_POST['Concentration'] ?? null;
    $totalSpermNumber = $_POST['Total_sperm_number'] ?? null;
    $motility = $_POST['Motility'] ?? null;
    $progressiveMotility = $_POST['Progressive_Motility'] ?? null;
    $morphology = $_POST['Morphology'] ?? null;
    $viability = $_POST['Viability'] ?? null;

    // Prepare an array to store the fields to be updated/inserted
    $fields = [
        'Name' => $name,
        'Contactnumber' => $contactno,
        'Age' => $age,
        'occupation' => $occupation,
        'significanthistory' => $significanthistory,
        'smoking' => $smoking,
        'alcohol' => $alcohol,
        'sexualdisfunction' => $sexualdisfunction,
        'Volume' => $volume,
        'Concentration' => $concentration,
        'Total_sperm_number' => $totalSpermNumber,
        'Motility' => $motility,
        'Progressive_Motility' => $progressiveMotility,
        'Morphology' => $morphology,
        'Viability' => $viability
    ];

    // Remove fields with null values
    $fields = array_filter($fields, function($value) {
        return !is_null($value);
    });

    // Check if the user_id already exists in addspouse
    $check_sql = "SELECT Userid FROM addspouse WHERE Userid = ?";
    $stmt = $conn->prepare($check_sql);
    $stmt->bind_param('s', $userid);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // User already exists, update the data
        $set_clauses = [];
        foreach ($fields as $field => $value) {
            $set_clauses[] = "$field = ?";
        }
        $set_sql = implode(', ', $set_clauses);

        $update_sql = "UPDATE addspouse SET $set_sql WHERE Userid = ?";
        $stmt_update = $conn->prepare($update_sql);

        // Bind parameters dynamically
        $types = str_repeat('s', count($fields)) . 's'; // add an extra 's' for the userid at the end
        $values = array_values($fields);
        $values[] = $userid;
        $stmt_update->bind_param($types, ...$values);

        if ($stmt_update->execute()) {
            // Successful update
            $response = array('status' => true, 'message' => 'Spouse details were updated successfully.');
            echo json_encode($response);
        } else {
            // Error in database update
            $response = array('status' => false, 'message' => 'Error updating record: ' . $conn->error);
            echo json_encode($response);
        }

        $stmt_update->close();
    } else {
        // User does not exist, insert data into addspouse table
        $columns = implode(', ', array_keys($fields));
        $placeholders = implode(', ', array_fill(0, count($fields), '?'));

        $insert_sql = "INSERT INTO addspouse (Userid, $columns) VALUES (?, $placeholders)";
        $stmt_insert = $conn->prepare($insert_sql);

        // Bind parameters dynamically
        $types = 's' . str_repeat('s', count($fields)); // add an extra 's' for the userid at the beginning
        $values = array_merge([$userid], array_values($fields));
        $stmt_insert->bind_param($types, ...$values);

        if ($stmt_insert->execute()) {
            // Successful insertion
            $response = array('status' => true, 'message' => 'Spouse details were added successfully.');
            echo json_encode($response);
        } else {
            // Error in database insertion
            $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
            echo json_encode($response);
        }

        $stmt_insert->close();
    }

    $stmt->close();
} else {
    // Handle non-POST requests
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
