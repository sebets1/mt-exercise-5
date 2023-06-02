#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author:  Seraina Betschart
# date: 01.06.2023
# Machine Translation Ex 5 - plot bleu score/time in a line graph

import matplotlib.pyplot as plt


f = plt.figure()
f.set_figwidth(15)
f.set_figheight(15)


def prep_for_plot(file):
    """Takes the text file plot_bleu-scores_time.txt as input, which is a tab-separated table with the columns
    beam size, bleu scores and time used. Returns two lists with the BLEU and time values respectively."""
    text_list=[]
    bleu_scores=[]
    time=[]
    with open(file, 'r', encoding='utf-8') as file:
        first_line=True
        for line in file:
            if not first_line:
                eles=line.split("\t")
                bleu_scores.append(float(eles[1]))
                time_ele=eles[2].rstrip("\n")
                time.append(int(eles[2]))

            first_line=False

    return bleu_scores, time


def plot_line(score_list, col="grey", xlabel="beam size", ylabel="score", show_x_values=False):
    """Takes a list and plots the items as one continuous line in a line graph."""
    x = []
    y = []
    x_num=1
    for ele in score_list:
        y.append(ele)
        x.append(x_num)
        x_num+=1

    f = plt.figure()
    f.set_figwidth(15)
    f.set_figheight(5)

    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    if show_x_values:
        plt.xticks(x)

    plt.plot(x, y, marker='o', color=col)


def line_graph(title="test"):
    """Creates the line graph."""
    if title != "test":
        plt.title(title)
    plt.show()
    plt.savefig(title)
    plt.clf()


if __name__ == '__main__':

    bleu_scores, time_scores=prep_for_plot("plot_bleu-scores_time.txt")

    plot_line(bleu_scores, col="blue",  ylabel="bleu score", show_x_values=True)
    line_graph("Bleu score of translations")

    plot_line(time_scores, ylabel="time (in seconds)", show_x_values=True)

    line_graph("Duration of translations")