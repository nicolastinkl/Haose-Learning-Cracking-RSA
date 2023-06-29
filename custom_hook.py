#!/usr/bin/env python3.10
# -*- coding: utf-8 -*-

# Author : AloneMonkey
# blog: www.alonemonkey.com

from __future__ import print_function
from __future__ import unicode_literals
import sys
import codecs
import frida
import threading
import os
import shutil
import time
import argparse
import tempfile
import subprocess
import re
import paramiko

import json
from concurrent.futures import ThreadPoolExecutor
from pymongo import MongoClient
import sys
import os
from optparse import OptionParser

# how to use it ?
# python3.10 custom_hook.py -f iOS_Trace.js -A 好色先生TV > datalog/newestdatalog.txt


# 连接到MongoDB数据库
client = MongoClient("mongodb://root:UdMKkCbmzLMr3D5k@1.1.1.1:27017")

if client is not None:
    print("Connected to MongoDB")
else:
    print("Failed to connect to MongoDB")

db = client["haosexiansheng"]

if db is not None:
    print("Database selected")
else:
    print("Failed to select database")

executor = ThreadPoolExecutor(max_workers=20)

def on_message(message, data):
    try:
        if message:
            print("[on_message] {0}".format(message["payload"]))
            # for arg in message["payload"]:
            #     print(arg)
            # 将 JSON 字符串解析为字典对象
            json_str = format(message["payload"])
            data = json.loads(json_str)

            print("正在解析，准备传到Mongodb服务器")
           
            if "data" in data:
                zidata = data['data']
                if zidata and isinstance(zidata, dict):

                    if "signin_info" in zidata and "push_message_info" in zidata and "announcement_list" in zidata and  "activity_card_info" in zidata:
                        executor.submit(upload_to_mongodbone,"init_all_info", zidata)    

                    #初始化所有标签
                    if "video_tags" in zidata and "actor_tags" in zidata:
                        video_tags = zidata['video_tags']
                        actor_tags = zidata['actor_tags']
                        executor.submit(upload_to_mongodb,"video_tags", video_tags)    
                        executor.submit(upload_to_mongodb,"actor_tags", actor_tags)    

                    if "category_id" in zidata:
                        category_id = zidata['category_id']
                        category_name = zidata['category_name']
                        
                        print(category_id)
                        print(category_name)
                       

                         #  tab（最新）表
                        if "videos" in zidata and  category_id:
                            videos = zidata['videos']
                            if isinstance(videos, list):
                                executor.submit(upload_to_mongodb,category_id, videos)
                         #官方类型       
                        if "playlists" in zidata:
                            playlists = zidata['playlists']
                            if  isinstance(playlists, list):
                                executor.submit(upload_to_mongodb,"category_toplist", playlists)    


                    #发现页面
                    if "banners" in  zidata and "picsets" in  zidata and "actor_avs" in  zidata:
                        executor.submit(upload_to_mongodbone,"faxian_list", zidata)                  
                
                #女you列表
                if zidata and isinstance(zidata, list): 
                    if len(zidata) == 1 :                       
                        #判断是否是视频列表 
                        videoinfo = zidata[0]
                        print(videoinfo)
                        if "clarity_id" in videoinfo and "video_uri" in videoinfo:
                            executor.submit(upload_to_mongodbone,"videourl_list", videoinfo) 

                    if len(zidata) > 1 :                       
                        executor.submit(upload_to_mongodb,"author_list", zidata) 

                    
         

                        
            #page_data表
            if "page_data" in data:
                page_data = data['page_data']
                if page_data and isinstance(page_data, list):
                    executor.submit(upload_to_mongodb,"page_data", page_data)


            #播单详情
            if "res_detail" in data:
                res_detail = data['res_detail']
                if res_detail and isinstance(res_detail, dict):
                    executor.submit(upload_to_mongodbone,"bodan_res_detail", res_detail)

            #播单具体列表数据
            if "contents" in data:
                contents = data['contents']
                if contents and isinstance(contents, list):
                    executor.submit(upload_to_mongodb,"bodan_contents", contents)

    except Exception as e:
        print(f"[on_message error]: {e}")
        
# 上传JSON数据到MongoDB的函数 
def upload_to_mongodbone(category_id,videos):
    try:
        # collection_name = data['data']['category_id'] 
        # next_start_offset = data['data']['next_start_offset']
        
        #db[collection_name].insert_one(videos)
        db[category_id].insert_one(videos)

        print(f"========> 成功：Uploaded {category_id}  to MongoDB") 
    except Exception as e:
        print(f"========> 失败 : Upload failed for : {e}")
       
 

# 上传JSON数据到MongoDB的函数 
def upload_to_mongodb(category_id,videos):
    try:
        # collection_name = data['data']['category_id'] 
        # next_start_offset = data['data']['next_start_offset']
        
        #db[collection_name].insert_one(videos)
        db[category_id].insert_many(videos)

        print(f"========> 成功：Uploaded {category_id}  to MongoDB") 
    except Exception as e:
        print(f"========> 失败 : Upload failed for : {e}")
       
 

if __name__ == '__main__':


    try:
        print("当前设备信息：")
        print(frida.get_usb_device())
        parser = OptionParser(usage="usage: %prog [options] <process_to_hook>",version="%prog 1.0")
        parser.add_option("-A", "--attach", action="store_true", default=False,help="Attach to a running process")
        parser.add_option("-S", "--spawn", action="store_true", default=False,help="Spawn a new process and attach")
        parser.add_option("-P", "--pid", action="store_true", default=False,help="Attach to a pid process")
        parser.add_option("-R", "--resume", action="store_true", default=False,help="Resume Process")
        parser.add_option("-f", "--file", action="store", dest="filename", help="Filename of the hook")

        (options, args) = parser.parse_args()
        if (options.spawn):
            print ("[*] Spawning "+ str(args[0]))
            pid = frida.get_usb_device().spawn([args[0]])
            session = frida.get_usb_device().attach(pid)
        elif (options.attach):
            print ("[*] Attaching to process "+str(args[0]))
            session = frida.get_usb_device().attach(str(args[0]))
        elif (options.pid):
            print ("[*] Attaching to PID "+str(args[0]))
            session = frida.get_usb_device().attach(str(args[0]))
        elif (options.resume):
            session = frida.get_usb_device().resume()
            sys.exit(0)
        else:
            print ("Error")
            print ("[X] Option not selected. View --help option.")
            sys.exit(0)

        if (not (options.filename)):
            print ("[X] Hook not defined")
            sys.exit(0)

        params = {"filename":options.filename}

        print ("[*] Parsing hooks from %(filename)s" % params)



            
        hook = open(params["filename"], "r")
        script = session.create_script(hook.read())
        script.on('message', on_message)
        script.load()
        sys.stdin.read()
    except KeyboardInterrupt:
        sys.exit(0)
