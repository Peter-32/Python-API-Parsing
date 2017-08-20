import pandas as pd

def readFromFile(sql_file_path):
    '''Returns the SQL file as a string.

    Keyword arguments:
    sql_file_path -- the relative file path to the SQL file (required).'''

    file = open(sql_file_path)
    sqlFile = file.read()
    file.close()
    return sqlFile

def getDFFromQuery(sql_file_path, connection):
    '''Returns the SQL result in a dataframe.

    Keyword arguments:
    sql_file_path -- the relative file path to the SQL file (required).
    connection -- the database connection.'''

    query = readFromFile(sql_file_path)
    df = pd.read_sql(query, connection)
    printDFCreatedMessage(sql_file_path, df)
    return df

def printDFCreatedMessage(name, df):
    '''Prints the dataframe created and the row count of the dataframe.

    Keyword arguments:
    name -- the name to be displayed.
    df -- the dataframe, used to get the row count of this dataframe.
    '''
    print("Finished Executing: " + name)
    print("The dataframe has a row count of: " + str(len(df)))

# Examples
## print(readFromFile('/Users/peterjmyers/Documents/Projects/Overage Alerts/SQL/getMMBillingDF.sql'))


def getMockDFFromQuery(sql_file_path, connection):
    '''Returns a blank DF.

    Keyword arguments:
    sql_file_path -- the relative file path to the SQL file (required).
    connection -- the database connection.'''

    query = readFromFile(sql_file_path).replace("where","where FALSE AND")
    df = pd.read_sql(query, connection)
    printDFCreatedMessage(sql_file_path, df)
    return df
