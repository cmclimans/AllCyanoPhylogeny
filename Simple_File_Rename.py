#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  8 11:05:12 2024

@author: chris
"""

import os
import pandas as pd
import argparse
import shutil
parser = argparse.ArgumentParser()


# Local
#os.chdir('/Users/chris/Desktop/test_genomes')

parser.add_argument("-i", "--input", help="Input rename file key", default="rename.csv")
parser.add_argument("-s", "--sourcename", help="Column name with existing file names", default="Assembly.file.name")
parser.add_argument("-r", "--rename", help="Column with names to become the new name", default="Organism.Name")

args = parser.parse_args()

if not os.path.isdir("renamed"):
    os.mkdir("renamed")


key = pd.read_csv(args.input)

    
# OSCER
if __name__ == '__main__':

    indicies = len(key)

    for index in range(0,indicies):
        current_name = key.iloc[index][args.sourcename]+'.fna'
        new_name = key.iloc[index][args.rename]+'.fna'
        
        if not os.path('genomes/'+current_name) and os.path('renamed/'+new_name):
            #print(f"{current_name} already moved.")
            continue
        elif not os.path('genomes/'+current_name) and not os.path('renamed/'+new_name):
            print(f"{current_name} needs checked.")
        else:
            shutil.copy('genomes/'+current_name, 'renamed/'+new_name)

