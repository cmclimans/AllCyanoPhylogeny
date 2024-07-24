#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  8 11:05:12 2024

@author: chris
"""

import os
import pandas as pd
import argparse
parser = argparse.ArgumentParser()


# Local
#os.chdir('/Users/chris/Desktop/test_genomes')

parser.add_argument("-i", "--input", help="Input rename file key", default="rename.csv")
parser.add_argument("-s", "--sourcename", help="Column name with existing file names", default="Assembly.file.name")
parser.add_argument("-r", "--rename", help="Column with names to become the new name", default="Organism.Name")

args = parser.parse_args()


key = pd.read_csv(args.input)

    
# OSCER
if __name__ == '__main__':

    indicies = len(key)

    for index in range(0,indicies):
        current_name = key.iloc[index][args.sourcename]+'.fna'
        new_name = key.iloc[index][args.rename]+'.fna'
        
        os.rename('genomes/'+current_name, 'renamed/'+new_name)

