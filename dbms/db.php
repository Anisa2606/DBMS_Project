<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "freelancehub";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Optional success message (you can remove later)
echo "Connected successfully";

?>