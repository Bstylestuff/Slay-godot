<?php
require_once "Conn.php";

if($_SERVER["REQUEST_METHOD"] == "GET"){
 
    if($_GET['function']=="Get_Servers"){
       echo get_servers();
    } elseif ($_GET['function']=="Get_Clients") 
    {
        if(is_numeric($_GET['Server_ID']))
        {
            $Host_ID=$_GET['Server_ID'];
            echo get_clients($Host_ID);
        }
    }
    else
    {
        echo "ew";
    }
   }

if($_SERVER["REQUEST_METHOD"] == "POST")
{
    if($_POST['function']=="Add_Server")
    {
        $conn=dbconnect();
        $Spectator=mysqli_escape_string($conn,$_POST['Spectator']);
        $Port=21050;
        $Max_Players=16;
        if (is_numeric($_POST['Port']))
            $Port=$_POST['Port'];
        if (is_numeric($_POST['Max_Player']))
            $Max_Players=$_POST['Max_Player'];
        if($Spectator==0)
        {
            $count=1;
        }
        else
        {
            $count=0;
        }
        $ip=getUserIP();
        #$ip='127.0.0.1';
        $insert_query="INSERT INTO slay_servers (id,  ip, player_count, available,  Port, Max_Players) VALUES 
                                                (NULL, '$ip', $count, 1, $Port, $Max_Players)";
        if ($conn->query($insert_query) === TRUE) 
        {
            $last_id = $conn->insert_id;
            $conn->close();
            $response=array('result'=>"Added server!", 'ID'=>$last_id);
            echo json_encode($response);
        }
    }
    else
    {
        if($_POST["function"]=="Join_Server")
        {
            if(is_numeric($_POST['ID']) and is_numeric($_POST['Port']))
            {
                $conn=dbconnect();
                $Port=$_POST['Port'];
                $Host_ID=$_POST['ID'];
                $Client_name=mysqli_escape_string($conn,$_POST['Name']);
                $ip=getUserIP();
                $update_query="UPDATE servers SET Player_Count = Player_Count + 1 WHERE Id=$Host_ID";
                $conn->query($update_query);
                
                $insert_query="INSERT INTO connections (Connection, Host_ID, Client_IP, Client_Port, Client_Name) VALUES 
                                                        (NULL,  $Host_ID, '$ip', $Port, '$Client_name')";
                $conn->query($insert_query);
                $conn->close();
            }
        }
        else
        {
            if($_POST["function"]=="Close_Server")
            {
                if(is_numeric($_POST['ID']))
                {
                    $conn=dbconnect();
                    $Host_ID=$_POST['ID'];
                    $update_query="UPDATE servers SET Available = 0 WHERE Id=$Host_ID";
                    $conn->query($update_query);
                    $conn->close();
                }
            }
        }
    } 
}


function get_servers()
{
    $conn=dbconnect();
    $return_arr=array();
    $strings = $conn->query("SELECT * from slay_servers where available=1");
    while ($srv = mysqli_fetch_assoc($strings))
    {
        if($srv['available'] == 1)
        {
        $row_array['ID'] = $srv['id'];
        $row_array['IP_Address']=$srv['ip'];
        $row_array['Player_Count'] = $srv['player_count'];
        $row_array['Port']=$srv['port'];
        $row_array['Max_Players']=$srv['max_players'];
        array_push($return_arr,$row_array);
        }
    }
    $conn->close();
    $response=array('result'=>"Perfect!", 'games'=>$return_arr);
    return json_encode($response);
}

function getUserIP()
{
    // Get real visitor IP behind CloudFlare network
    if (isset($_SERVER["HTTP_CF_CONNECTING_IP"])) {
              $_SERVER['REMOTE_ADDR'] = $_SERVER["HTTP_CF_CONNECTING_IP"];
              $_SERVER['HTTP_CLIENT_IP'] = $_SERVER["HTTP_CF_CONNECTING_IP"];
    }
    $client  = @$_SERVER['HTTP_CLIENT_IP'];
    $forward = @$_SERVER['HTTP_X_FORWARDED_FOR'];
    $remote  = $_SERVER['REMOTE_ADDR'];

    if(filter_var($client, FILTER_VALIDATE_IP))
    {
        $ip = $client;
    }
    elseif(filter_var($forward, FILTER_VALIDATE_IP))
    {
        $ip = $forward;
    }
    else
    {
        $ip = $remote;
    }

    return $ip;
}


function get_clients($Host_ID)
{
    $conn=dbconnect();
    $return_arr=array();
    $strings = $conn->query("SELECT * from slay_players WHERE Host_ID=$Host_ID");
    while ($srv = mysqli_fetch_assoc($strings))
    {
        $row_array['IP_Address']=$srv['Client_IP'];
        $row_array['Port']=$srv['Client_Port'];
        $row_array['Name']=$srv['Client_Name'];
        array_push($return_arr,$row_array);
    }
    $conn->close();
    $response=array('result'=>"Perfect!", 'clients'=>$return_arr);
    return json_encode($response);
}
?>