<?php
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get input data from the application
    $name = isset($_POST['name']) ? $_POST['name'] : 'name'; // Set default if not provided
    $contactno = isset($_POST['contactno']) ? $_POST['contactno'] : 'contactnumber'; // Set default if not provided
    $age = isset($_POST['age']) ? $_POST['age'] : 'age'; // Set default if not provided
    $gender = isset($_POST['gender']) ? $_POST['gender'] : 'gender'; // Set default if not provided
    $height = isset($_POST['height']) ? $_POST['height'] : 'height'; // Set default if not provided
    $weight = isset($_POST['weight']) ? $_POST['weight'] : 'weight'; // Set default if not provided
    $marriageyear = isset($_POST['marriageyear']) ? $_POST['marriageyear'] : 'yom'; // Set default if not provided
    $bloodgroup = isset($_POST['bloodgroup']) ? $_POST['bloodgroup'] : 'bloodgroup'; // Set default if not provided
    $medicalhistory = isset($_POST['medicalhistory']) ? $_POST['medicalhistory'] : 'medicalhistory'; // Set default if not provided
    $password = isset($_POST['password']) ? $_POST['password'] : 'WELCOME'; // Set default if not provided
    $repassword = isset($_POST['repassword']) ? $_POST['repassword'] : 'WELCOME'; // Set default if not provided
    $occupation = isset($_POST['occupation']) ? $_POST['occupation'] : 'occupation'; // Set default if not provided
    $BMI = isset($_POST['BMI']) ? $_POST['BMI'] : 'BMI'; // Set default if not provided
    $contraceptive_history = isset($_POST['contraceptive_history']) ? $_POST['contraceptive_history'] : 'contraceptive_history'; // Set default if not provided
    $last_menstrual_period = isset($_POST['last_menstrual_period']) ? $_POST['last_menstrual_period'] : 'last_menstrual_period'; // Set default if not provided
    $menstrual_history = isset($_POST['menstrual_history']) ? $_POST['menstrual_history'] : 'menstrual_history'; // Set default if not provided
    $flow = isset($_POST['flow']) ? $_POST['flow'] : 'flow'; // Set default if not provided
    $consanguineous = isset($_POST['consanguineous']) ? $_POST['consanguineous'] : 'consanguineous'; // Set default if not provided
    $coital_history = isset($_POST['coital_history']) ? $_POST['coital_history'] : 'coital_history'; // Set default if not provided
    $obstetric_history = isset($_POST['obstetric_history']) ? $_POST['obstetric_history'] : 'obstetric_history'; // Set default if not provided
    $surgical_history = isset($_POST['surgical_history']) ? $_POST['surgical_history'] : 'surgical_history'; // Set default if not provided
    $smoking = isset($_POST['smoking']) ? $_POST['smoking'] : 'smoking'; // Set default if not provided
    $alcohol = isset($_POST['alcohol']) ? $_POST['alcohol'] : 'alcohol'; // Set default if not provided

    // Insert data into the addpatient table
    $sql = "INSERT INTO addpatient (Name, ContactNo, Age, Gender, Height, Weight, Marriageyear, Bloodgroup, Medicalhistory, 
            Occupation, BMI, Contraceptive_History, Last_Menstrual_Period, Menstrual_History, Flow, Consanguineous, 
            Coital_History, Obstetric_History, Surgical_History, Smoking, Alcohol, Specifications, password, repassword) 
            VALUES ('$name', '$contactno', '$age', '$gender', '$height', '$weight', '$marriageyear', '$bloodgroup', 
            '$medicalhistory', '$occupation', '$BMI', '$contraceptive_history', '$last_menstrual_period', '$menstrual_history', 
            '$flow', '$consanguineous', '$coital_history', '$obstetric_history', '$surgical_history', '$smoking', '$alcohol', 
            'NO SPECIFICATIONS SPECIFIED', '$password', '$repassword')";

    if ($conn->query($sql) === TRUE) {
        // Successful insertion
        $last_id = $conn->insert_id; // Get the auto-generated Userid
        $response = array('status' => true, 'message' => 'Patient registration successful.', 'Userid' => $last_id);
        echo json_encode($response);
    } else {
        // Error in database insertion
        $response = array('status' => false, 'message' => 'Error: ' . $conn->error);
        echo json_encode($response);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    $response = array('status' => false, 'message' => 'Invalid request method.');
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
