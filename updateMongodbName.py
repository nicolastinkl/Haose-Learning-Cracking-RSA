import os
import json
from concurrent.futures import ThreadPoolExecutor
from pymongo import MongoClient

# 47.xxx.100.xx:27017

# haosexiansheng
# 7t7bPbWC5FJ2ZhHG

# root
# UdMKkCbmzLMr3D5k

# 连接到MongoDB数据库
client = MongoClient("mongodb://root:UdMKkCbmzLMr3D5k@47.xxx.100.xx:27017")

if client is not None:
    print("Connected to MongoDB")
else:
    print("Failed to connect to MongoDB")

db = client["haosexiansheng"]

if db is not None:
    print("Database selected")
else:
    print("Failed to select database")



# 获取要重命名的数据库实例
# database = client['original_database_name']
# 获取要重命名的数据库实例


# 重命名数据库


# 获取要复制的数据库名称
db_name = 'haosexiansheng'
old_db = client[db_name]

# 复制数据库所有集合到新数据库
new_db_name = 'haose'
new_db = client[new_db_name]

for col_name in old_db.list_collection_names():

    print(col_name)
    old_col = old_db[col_name]
    new_col = new_db[col_name]
    new_col.insert_many(old_col.find())

# 关闭连接
client.close()

print("  end !!!")