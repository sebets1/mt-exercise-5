#!/usr/bin/env python3
# -- coding: utf-8 --
# Author:  Seraina Betschart
# date: 27.05.2023
# Machine Translation Exercise 5


def split_data(input, output, num_lines):
    """get first x lines of input doc and save in output doc"""
    with open(input, "r", encoding="utf-8") as text:
        ind=1
        short_text=[]

        for line in text:
            if ind < num_lines:
                short_text.append(line)
                ind+=1


    with open(output, "w", encoding="utf-8") as text:
        for line in short_text:
            text.write(line)


split_data("train.ro-de.de", "train_100k.de", 100000)
split_data("train.ro-de.ro", "train_100k.ro", 100000)
split_data("train.ro-de.de", "sample_train_5000.de", 5000)
split_data("train.ro-de.ro", "sample_train_5000.ro", 5000)

split_data("train.ro-de.de", "train_20k.de", 20000)
split_data("train.ro-de.ro", "train_20k.ro", 20000)
