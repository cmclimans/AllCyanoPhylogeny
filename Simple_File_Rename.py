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
parser.add_argument("-k", "--keeporiginal", help="Boolean keep original files", default="F")
parser.add_argument("-u", "--undo", help="Copy renamed files back to genome accession", default="F")


args = parser.parse_args()
key = pd.read_csv(args.input)


if args.keeporiginal != "T" and args.keeporiginal != "F":
    exit("-k/--keeporiginal must be T or F")
    
    
def undo():
    indicies = len(key)

    for index in range(0,indicies):
        current_name = key.iloc[index][args.sourcename]+'.fna'
        new_name = key.iloc[index][args.rename]+'.fna'
        
        if os.path.isfile('renamed/' + new_name) and not os.path.isfile('genomes/' + current_name):
            shutil.copy('renamed/' + new_name, 'genomes/' + current_name)


if __name__ == "__main__":
    
    if args.undo == "T":
        undo()
    
    else:
        if not os.path.isdir("renamed"):
            print("Creating directory \'renamed\' for renamed files.")
            os.mkdir("renamed")
        
        
        if __name__ == '__main__':
            
            problemfiles = []
        
            indicies = len(key)
        
            for index in range(0,indicies):
                current_name = key.iloc[index][args.sourcename]+'.fna'
                new_name = key.iloc[index][args.rename]+'.fna'
                
                if os.path.isfile('renamed/' + new_name):
                    # print(f"{current_name} already moved.")
                    continue
                elif not os.path.isfile('genomes/' + current_name) and not os.path.isfile('renamed/' + new_name):
                    print(f"{current_name} needs checked.")
                    problemfiles.append(current_name)
                else:
                    if args.keeporiginal == "F":
                        shutil.copy('genomes/' + current_name, 'renamed/' + new_name)
                    else:
                        os.rename('genomes/' + current_name, 'renamed/' + new_name)
                        
                        
            if len(problemfiles) > 0:
                with open("rename_check.txt", 'w') as f:
                    for item in problemfiles:
                        f.writelines(item+'\n')
                        
                    

                    
