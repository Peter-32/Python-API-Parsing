import json
import mysql.connector
from run_sql_utility.run_sql_utility import *

################################################################################

def saveJsonToDB(local_cnx):
    json_data = open('../output.json').read()
    data = json.loads(json_data)

    # All the loops!
    for item in data:
        role = item['role']
        if (role == "JUNGLE" or role == "TOP" or role == "MIDDLE"):
            arr = item['matchups'][role]
            champion_id = item['championId']
            for x in arr:
                if (x['count'] < 21):
                    continue
                if (x['champ1_id'] == champion_id):
                    winrate = x['champ1']['winrate']
                else:
                    winrate = x['champ2']['winrate']
                enemy_champion_id = x['champ2_id']
                ## SAVE: champion,enemy_champion,winrate,role
                try :
                    cur = local_cnx.cursor()
                    # Truncate the table each script run.
                    cur.execute("""DELETE FROM win_rates""")
                    for index, row in final_df.iterrows():
                        cur.execute("""INSERT INTO win_rates (champion_id, enemy_champion_id, win_rate, role) VALUES
                        ({},{},{},"{}")""".format(champion_id, enemy_champion_id, winrate, role))
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
    saveJsonToDB(local_cnx)
    print( "Script Success!" )
except mysql.connector.Error as err:
    print("Something went wrong: {}".format(err))
finally:
    local_cnx.close()
