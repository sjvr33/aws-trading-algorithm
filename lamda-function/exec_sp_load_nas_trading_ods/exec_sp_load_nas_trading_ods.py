import mysql.connector

ENDPOINT = "xxxxxxx.amazonaws.com"
PORT = "3306"
USER = "xxxxxxx"
REGION = "us-east-1a"
DBNAME = "xxxxxxx"
PASSWORD  = "xxxxxxx" 
mysql_procedure_list = ["sp_load_trading_ods_nasdaq_signal_m30", "sp_load_trading_ods_nasdaq_signal_h1", "sp_load_trading_ods_nasdaq_signal_h4_daily", "sp_load_trading_ods_mt4_signal", "sp_load_nasdaq_signal_ai_model"]

def lamda_handler(event, context):
    try:
        conn =  mysql.connector.connect(host=ENDPOINT, user=USER, passwd=PASSWORD, port=PORT, database=DBNAME)
        cur = conn.cursor()
        for procedure in mysql_procedure_list:    
            cur.callproc(procedure)
            for result in cur.stored_results():
                query_results = result.fetchall()
                print(f"The execution results of mysql procedures: {query_results}")
    except mysql.connector.Error as error:
        print("Failed to execute stored procedure: {}".format(error))
    finally:
        print("all mysql produres executed successfully!")
        if (conn.is_connected()):
            cur.close()
            conn.close()
            print("MySQL connection is closed")
        
    message = "Stored procedures executed successfully!"
    return {
        'message' : message
    }
