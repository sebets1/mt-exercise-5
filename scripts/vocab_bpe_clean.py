#!/usr/bin/env python3
# -- coding: utf-8 --
# Author:  Seraina Betschart
# date: 01.06.2023
# Machine Translation Exercise 5

import sys

def clean_data(input1, input2, output, voc_size):
    """clean up the bpe vocab files for target and source language, get rid of vocab counts and save 2000 first tokens
    to new file"""
    final_vocab_list=[]
    count_vocab_list=[]
    with open(input1, "r", encoding="utf-8") as text:
        for line in text:
            temp_list=line.split()
            if len(temp_list)==2:
                count=int(temp_list[1])
                count_vocab_list.append([count, temp_list[0]])

    with open(input2, "r", encoding="utf-8") as text:
        for line in text:
            temp_list=line.split()
            if len(temp_list) == 2:
                count = int(temp_list[1])
                count_vocab_list.append([count, temp_list[0]])

    count_vocab_list.sort(reverse=True)

    for i in range(voc_size):
        final_vocab_list.append(count_vocab_list[i][1])




    with open(output, "w", encoding="utf-8") as text:
        for ele in final_vocab_list:
            if final_vocab_list.index(ele)==(voc_size-1):
                text.write(ele)
            else:
                text.write(ele)
                text.write("\n")

if __name__ == '__main__':
    input1 = sys.argv[1]
    input2 = sys.argv[2]
    output = sys.argv[3]
    vocabulary_size=int(sys.argv[4])

    clean_data(input1, input2, output, vocabulary_size)


