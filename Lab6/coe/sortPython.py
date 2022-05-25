'''
Author: MomoTori
Date: 2022-05-23 23:13:09
LastEditors: MomoTori
LastEditTime: 2022-05-23 23:50:23
FilePath: \CODExperiment\Lab6\coe\sortPython.py
Description: 
Copyright (c) 2022 by MomoTori, All Rights Reserved. 
'''

import random

array=[]

with open("sortPythonOut.coe",mode="w+") as out:
    out.write("memory_initialization_radix  = 16;\nmemory_initialization_vector =\n")
    num=128
    out.write("%08x\n"%num)
    for i in range(0,num):
        x=random.randint(0,num)
        array.append(x)
        out.write("%08x\n"%x)

array.sort()

with open("sortPythonOutFin",mode="w+") as out:
    for i in range(0,num):
        out.write("%08x\n"%array[i])