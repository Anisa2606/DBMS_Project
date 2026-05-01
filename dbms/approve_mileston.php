<?php

include 'db.php';

// Get milestone ID from form
$milestone_id = $_POST['milestone_id'];

// Update milestone status
$sql = "UPDATE MILESTONE 
        SET Status = 'Approved' 
        WHERE Milestone_ID = '$milestone_id'";

// Execute query
if (mysqli_query($conn, $sql)) {
    echo "Milestone Approved Successfully!";
} else {
    echo "Error: " . mysqli_error($conn);
}

?>