<?php

include 'db.php';

// Get form data
$title = $_POST['title'];
$budget = $_POST['budget'];
$deadline = $_POST['deadline'];

// Insert into PROJECT table
$sql = "INSERT INTO PROJECT (Client_ID, Title, Budget, Deadline)
        VALUES (1, '$title', '$budget', '$deadline')";

// Execute query
if (mysqli_query($conn, $sql)) {
    echo "Project Added Successfully!";
} else {
    echo "Error: " . mysqli_error($conn);
}

?>