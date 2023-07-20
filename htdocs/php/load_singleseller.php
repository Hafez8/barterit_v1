<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['sellerid'])){
	$sellerid = $_POST['sellerid'];	
	$sqlloaditem = "SELECT * FROM `tbl_item` WHERE user_id = '$sellerid'";
}

$result = $conn->query($sqlloaditem);

if ($result->num_rows > 0) {
    $item["item"] = array();
	while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_desc'] = $row['item_desc'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_qty'] = $row['item_qty'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
		$itemlist['item_date'] = $row['item_date'];
        array_push($item["item"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $item);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}