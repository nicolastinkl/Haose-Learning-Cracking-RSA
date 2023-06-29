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

# 上传JSON数据到MongoDB的函数，并修改文件名为.success
def upload_to_mongodb(filepath):
    try:
        with open(filepath, "r") as f:
            data = json.load(f)
            collection_name = os.path.splitext(os.path.basename(filepath))[0]
            db[collection_name].insert_one(data)
        print(f"Uploaded {filepath} to MongoDB")
        # 上传成功后重命名文件
        os.rename(filepath, f"{os.path.splitext(filepath)[0]}.success")
    except Exception as e:
        print(f"Upload failed for {filepath}: {e}")
        return filepath


# 上传JSON数据到MongoDB的函数
def upload_to_mongodb_old(filepath):
    with open(filepath, "r") as f:
        data = json.load(f)
        collection_name = os.path.splitext(os.path.basename(filepath))[0]
        db[collection_name].insert_one(data)
    
    print(f"Uploaded {filepath}  filesize:{len(data)} to MongoDB")
    # 上传成功后重命名文件
    os.rename(filepath, f"{os.path.splitext(filepath)[0]}.success")


# 使用线程池并发地上传多个JSON文件到MongoDB
directory = "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/dbjson"
executor = ThreadPoolExecutor(max_workers=20)

futures = []
for filename in os.listdir(directory):
    if filename.endswith(".json"):
        
        filepath = os.path.join(directory, filename)
        print(f"正在处理文件：{filepath}")

        #executor.submit(upload_to_mongodb, filepath)
        future = executor.submit(upload_to_mongodb, filepath)
        futures.append(future)


for future in futures:
    result = future.result()
    if result is not None:
        print(result)        
        
executor.shutdown()
print("task end !!!")