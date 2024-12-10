<?php
require_once('dbconnect.php');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Initialize an array to collect errors
    $errors = [];

    // Check if any of the required fields are empty
    $required_fields = [
        'userid', 'name', 'contactno', 'age', 
        'height', 'weight', 'marriageyear', 'bloodgroup', 
        'medicalhistory', 'occupation', 'BMI', 
        'contraceptive_history', 'last_menstrual_period', 
        'menstrual_history', 'flow', 'consanguineous', 
        'coital_history', 'obstetric_history', 
        'surgical_history', 'smoking', 'alcohol'
    ];

    foreach ($required_fields as $field) {
        if (empty($_POST[$field])) {
            $errors[] = "Field '$field' is required.";
        }
    }

    // Check if there are any errors
    if (!empty($errors)) {
        echo json_encode(['status' => false, 'message' => implode(" ", $errors)]);
        exit; // Stop execution if there are errors
    }

    // Handle file upload
    $upload_path = "";
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        $file_name = $_FILES['image']['name'];
        $file_tmp = $_FILES['image']['tmp_name'];
        $file_ext_arr = explode('.', $file_name);
        $file_ext = strtolower(end($file_ext_arr));

        $allowed_extensions = ['jpeg', 'jpg', 'png'];

        if (!in_array($file_ext, $allowed_extensions)) {
            echo json_encode(['status' => false, 'message' => 'Image extension not allowed, please choose a JPEG or PNG file.']);
            exit;
        }

        // Generate a unique name for the image
        $image_name = uniqid() . '.' . $file_ext;
        $upload_path = "patient_image/" . $image_name;

        // Move uploaded file to the specified folder
        if (!move_uploaded_file($file_tmp, $upload_path)) {
            echo json_encode(['status' => false, 'message' => 'Failed to upload image.']);
            exit;
        }
    }

    // Get input data
    $data = [
        'userid' => $_POST['userid'],
        'name' => $_POST['name'],
        'contactno' => $_POST['contactno'],
        'age' => $_POST['age'],
        'height' => $_POST['height'],
        'weight' => $_POST['weight'],
        'marriageyear' => $_POST['marriageyear'],
        'bloodgroup' => $_POST['bloodgroup'],
        'medicalhistory' => $_POST['medicalhistory'],
        'occupation' => $_POST['occupation'],
        'BMI' => $_POST['BMI'],
        'contraceptive_history' => $_POST['contraceptive_history'],
        'last_menstrual_period' => $_POST['last_menstrual_period'],
        'menstrual_history' => $_POST['menstrual_history'],
        'flow' => $_POST['flow'],
        'consanguineous' => $_POST['consanguineous'],
        'coital_history' => $_POST['coital_history'],
        'obstetric_history' => $_POST['obstetric_history'],
        'surgical_history' => $_POST['surgical_history'],
        'smoking' => $_POST['smoking'],
        'alcohol' => $_POST['alcohol'],
        'image' => $upload_path
    ];

    // Prepare SQL statement to prevent SQL injection
    $check_sql = "SELECT Userid FROM addpatient WHERE Userid = ?";
    $stmt = $conn->prepare($check_sql);
    $stmt->bind_param("s", $data['userid']);
    $stmt->execute();
    $check_result = $stmt->get_result();

    if ($check_result->num_rows > 0) {
        // Update data in the addpatient table
        $update_sql = "UPDATE addpatient SET 
            Name = ?, 
            ContactNo = ?, 
            Age = ?, 
            Height = ?, 
            Weight = ?, 
            Marriageyear = ?, 
            Bloodgroup = ?, 
            Medicalhistory = ?, 
            image = ?, 
            occupation = ?, 
            BMI = ?, 
            contraceptive_history = ?, 
            last_menstrual_period = ?, 
            menstrual_history = ?, 
            flow = ?, 
            consanguineous = ?, 
            coital_history = ?, 
            obstetric_history = ?, 
            surgical_history = ?, 
            smoking = ?, 
            alcohol = ?
            WHERE Userid = ?";

        $stmt = $conn->prepare($update_sql);
        $stmt->bind_param("ssssssssssssssssssssss", 
            $data['name'], $data['contactno'], $data['age'], 
            $data['height'], $data['weight'], $data['marriageyear'], 
            $data['bloodgroup'], $data['medicalhistory'], $data['image'], 
            $data['occupation'], $data['BMI'], $data['contraceptive_history'], 
            $data['last_menstrual_period'], $data['menstrual_history'], 
            $data['flow'], $data['consanguineous'], 
            $data['coital_history'], $data['obstetric_history'], 
            $data['surgical_history'], $data['smoking'], $data['alcohol'], 
            $data['userid']
        );

        if ($stmt->execute()) {
            echo json_encode(['status' => true, 'message' => 'Patient details updated successfully.']);
        } else {
            echo json_encode(['status' => false, 'message' => 'Error: ' . $stmt->error]);
        }
    } else {
        echo json_encode(['status' => false, 'message' => 'User does not exist.']);
    }

    // Close the statement
    $stmt->close();
} else {
    echo json_encode(['status' => false, 'message' => 'Invalid request method.']);
}

// Close the database connection
$conn->close();
?>
