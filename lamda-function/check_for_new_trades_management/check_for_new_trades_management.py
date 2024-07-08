import paramiko
import re

hostname = "xxxxxxx.com"
username = "xxxxxxx"
password = "xxxxxxx"

cmd_list =  ['python C:\\Users\\Administrator\\PythonScripts\\check_for_new_trades_management.py']

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
        print(final_output)
        
    # Close the client itself
    client.close()

    #check for errors received from client server
    if re.search(r'error', final_output, re.IGNORECASE):
        raise Exception(final_output)

    #check for valid or invalid trade taken
    if "message: Invalid Trade" in (final_output):
        message = "Invalid Trade"
    elif "message: Valid Trade" in (final_output):
        message = "Valid Trade"
    else: raise "unkown error"
    
    return {
        'message' : message
    }
