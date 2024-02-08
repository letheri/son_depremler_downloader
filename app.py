from deprempy import Deprem
import pandas as pd
from sqlalchemy import create_engine, text
import json

deprem = Deprem()
df = pd.DataFrame(deprem.son_24saat())
df["buyukluk"] = df["buyukluk"].astype(float)
df = df[df["buyukluk"] > 3]

with open("config.json", "r") as file:
    # Load the JSON data
    config = json.load(file)
    engine = create_engine(
        f'postgresql://{config["username"]}:{config["password"]}@{config["host"]}/{config["database"]}'
    )
    df.to_sql("deprem_son1gun", engine, if_exists="replace", index=False)
    conn = engine.connect()
    conn.execute(text('select insert_into_deprem();'))
    conn.close()
