<?php
// Simple PHP prototype

// Set timezone
date_default_timezone_set('UTC');

// Sample variables
$name = "Visitor";
$currentTime = date("Y-m-d H:i:s");

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = htmlspecialchars($_POST["name"]);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PHP {{inventory_hostname}} Page</title>
</head>
<body>
    <h1>Welcome, <?php echo $name; ?>!</h1>
    <p>The current server time is: <?php echo $currentTime; ?></p>

    <form method="POST" action="">
        <label for="name">Enter your name: </label><br>
        <input type="text" id="name" name="name" required><br><br>
        <button type="submit">Submit</button>
    </form>
</body>
</html>
