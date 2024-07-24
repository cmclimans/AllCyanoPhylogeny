#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  8 11:05:12 2024

@author: chris
"""

import os
import pandas as pd


# Local
os.chdir('/Users/chris/Desktop/test_genomes')

key = pd.read_csv('allcyano_rename.csv')

indicies = len(key)

for index in range(0,indicies):
    current_name = key.iloc[index]['AssemblyAccession']+'.fna'
    new_name = key.iloc[index]['OrganismName']+'.fna'
    
    os.rename('/Users/chris/Desktop/test_genomes/'+current_name, '/Users/chris/Desktop/rename_test/'+new_name)
    
    
    
# OSCER
if __name__ == '__main__':
    key = pd.read_csv('allcyano_rename.csv')

    indicies = len(key)

    for index in range(0,indicies):
        current_name = key.iloc[index]['AssemblyAccession']+'.fna'
        new_name = key.iloc[index]['OrganismName']+'.fna'
        
        os.rename('genomes/'+current_name, 'renamed/'+new_name)

