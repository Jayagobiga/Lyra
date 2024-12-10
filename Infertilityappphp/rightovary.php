<?php
// Include your database connection code here (e.g., db_conn.php)
require_once('con.php');

$response = array();

if (isset($_GET['userid'])) {
    $userid = $_GET['userid'];

    $sql = "SELECT date, Rightovery 
            FROM addreport 
            WHERE Userid = ? 
            ORDER BY date DESC";

    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, "s", $userid);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($result->num_rows > 0) {
        $response['status'] = true;
        $response['message'] = "Data found";
        $response['data'] = array();

        while ($row = $result->fetch_assoc()) {
            $dataEntry = array(
                'date' => $row['date'],
                'rovary' => (float)$row['Rightovery']
            );

            array_push($response['data'], $dataEntry);
        }
    } else {
        $response['status'] = false;
        $response['message'] = "No results found";
    }
} else {
    $response['status'] = false;
    $response['message'] = "'userid' parameter not found in the URL.";
}

$conn->close();

$jsonResponse = json_encode($response);

if ($jsonResponse === false) {
    $errorResponse = array(
        'status' => false,
        'message' => 'JSON encoding error: ' . json_last_error_msg()
    );
    echo json_encode($errorResponse);
} else {
    echo $jsonResponse;
}
?>
