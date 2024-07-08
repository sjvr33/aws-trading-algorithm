import mysql.connector
import paramiko
import re

# ssh variables 
hostname = "xxxxxxx.amazonaws.com"
username = "xxxxxxx"
password = "xxxxxxx"
cmd_list =  ['python C:\\Users\\Administrator\\PythonScripts\\check_ready_to_run_nas.py']

#rds connection variables 
ENDPOINT = "xxxxxxx"
USER = "xxxxxxx"
REGION = "us-east-1a"
DBNAME = "xxxxxxx"
PASSWORD  = "xxxxxxx" 
mysql_signal_table = "trading_ods.vw_mt4_signal_ai"


def lamda_handler(event, context):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname,username=username,password=password)
        print("Connected to %s" % hostname)
    except paramiko.AuthenticationException:
        print("Failed to connect to %s due to wrong username/password" %hostname)
        exit(1)
    except Exception as e:
        print(e.message)    
        exit(2)

    for cmd in cmd_list:
        err = ''  # Initialize the err variable before the loop
        try:
            stdin, stdout, stderr = client.exec_command(cmd)
        except Exception as e:
            print(e.message)
            err = ''.join(stderr.readlines())
        out = ''.join(stdout.readlines())
        final_output = str(out) + str(err)
        #print(final_output)
        latest_time_mt5_time_epoc = final_output 

    if re.search(r'error', final_output, re.IGNORECASE):
        raise Exception(final_output)

    # Close the client itself
    client.close()

    #get the latest datetime from the mysql database   
    try:
        connection = mysql.connector.connect(host = ENDPOINT,
                                             database = DBNAME,
                                             user = USER,
                                             password = PASSWORD,
                                             port = 3306)
        sql_select_Query = f"select time, begin_date_time, end_date_time, time_frame, buy_sell_signal_ind from {mysql_signal_table} order by begin_date_time desc limit 1"
        cursor = connection.cursor()
        cursor.execute(sql_select_Query)
        # get all records
        records = cursor.fetchall()
        print("Total number of rows in table: ", cursor.rowcount)
        mysql_select_dict = {"time": [], "begin_date_time": [], "end_date_time": [], "time_frame": [], "buy_sell_signal_ind": []}
        print("\nAppending each row to dict")
        for col in records:
            mysql_select_dict["time"].append(col[0])
            mysql_select_dict["begin_date_time"].append(col[1])
            mysql_select_dict["end_date_time"].append(col[2])
            mysql_select_dict["time_frame"].append(col[3])
            mysql_select_dict["buy_sell_signal_ind"].append(col[4])
        #print(mysql_select_dict)
    except mysql.connector.Error as e:
        print("Error reading data from MySQL table", e)
    finally:
        if connection.is_connected():
            connection.close()
            cursor.close()
            print("MySQL connection is closed")
    
    mysql_latest_time_epoc = mysql_select_dict['time']
    print(f"mt5 epoc time = {latest_time_mt5_time_epoc} & mysql epoc time = {mysql_latest_time_epoc[0]}")
    if int(latest_time_mt5_time_epoc) > int(mysql_latest_time_epoc[0]): 
        return {
            'message' : "true", #"ready to run imports"
            'mt5_time': int(latest_time_mt5_time_epoc)
        }
    elif int(latest_time_mt5_time_epoc) == int(mysql_latest_time_epoc[0]):
        return {
            'message' : "false", #"time is up to date"
            'mt5_time': int(latest_time_mt5_time_epoc)
        }
    else: raise "error reading correct time from mt5 platform"


