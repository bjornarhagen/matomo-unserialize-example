<?php

require_once __DIR__ . "/config.php";

$db = mysqli_connect(
    $DB_CONFIG["host"],
    $DB_CONFIG["username"],
    $DB_CONFIG["password"],
    $DB_CONFIG["database"],
    $DB_CONFIG["port"]
);

$query = "SELECT * FROM matomo_archive_blob_2022_07 LIMIT 2";

$matomo_archive_blob_2022_07 = mysqli_query($db, $query);
$matomo_archive_blob_2022_07 = mysqli_fetch_all($matomo_archive_blob_2022_07, MYSQLI_ASSOC);

if (file_exists(__DIR__ . "/data/output.txt")) {
    unlink(__DIR__ . "/data/output.txt");
}

foreach ($matomo_archive_blob_2022_07 as $row) {
    $output = "idarchive: " . $row["idarchive"] . ", name: " . $row["name"] . "\n";
    $blob = $row["value"];
    $blob = gzuncompress($blob);
    $blob = unserialize($blob);
    $json = json_encode($blob, JSON_PRETTY_PRINT);
    $output .= $json;
    $output .= "-----------------\n\n";
    file_put_contents(__DIR__ . "/data/output.txt", $output, FILE_APPEND);
}


$db->close();
