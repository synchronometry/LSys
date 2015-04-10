import sys

#  title: Context-Free Lindenmayer System
# author: Bruce Dawson
#   date: January 31, 2015
#
# L-SYSTEM LEGEND:
# ---------------
# A -> BA
# B -> A
# ---------------
#

try:
    numOfIterations = int(sys.argv[1])
    axiom = str(sys.argv[2])
    # parse input as 1-char list
    print("Axiom: ", axiom)
except IndexError:
    axiom = 'A'

axiom_list = list(axiom)

for n in range(numOfIterations):

    updated_axiom_length = len(axiom_list)
    print("Iteration #", n, "\nbeginning axiom list: ", axiom_list)

    for i in range(updated_axiom_length):
        # for i in range(len(axiom_list)):
        # turn B -> A
        if(axiom_list[i] == 'B'):
            axiom_list[i] = axiom_list[i].replace('B', 'A')
        # turn A -> BA
        elif((axiom_list[i] == 'A') & (axiom_list[i-1] != 'B')):
            axiom_list = axiom_list[:i] + ['B'] + axiom_list[i:]
