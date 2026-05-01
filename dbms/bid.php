<?php

include 'db.php';

// Get values from form
$project_id = $_POST['project_id'];
$amount = $_POST['amount'];

// Insert into BID table
$sql = "INSERT INTO BID (Project_ID, Freelancer_ID, Bid_Amount)
        VALUES ('$project_id', 2, '$amount')";

// Execute query
if (mysqli_query($conn, $sql)) {
    echo "Bid Placed Successfully!";
} else {
    echo "Error: " . mysqli_error($conn);
}

?>