import json
import mysql.connector
from run_sql_utility.run_sql_utility import *

################################################################################

def readInChampions(local_cnx):
    json_data = open('champ_ids.json').read()
    data = json.loads(json_data)['data']
    for key in data:
        try :
            cur.execute("""INSERT INTO champions (champion_id, champion) VALUES
            ({},"{}")""".format(data[key]['id'], data[key]['name']))
            local_cnx.commit()
        except Exception as e:
            print("Something went wrong saving to DB: {}".format(e))
            local_cnx.rollback()

################################################################################

config_local = {
    'user': "root",
    'password': "",
    'host': '127.0.0.1',
    'database': 'gg',
    'port': 3306
}

################################################################################

print("connecting.")
local_cnx = mysql.connector.connect(**config_local)
print("connection done.")
try:
    cur = local_cnx.cursor()
    # Truncate the table each script run.
    cur.execute("""DELETE FROM champions""")

    readInChampions(local_cnx)
    print( "Script Success!" )
except mysql.connector.Error as err:
    print("Something went wrong: {}".format(err))
finally:
    local_cnx.close()
