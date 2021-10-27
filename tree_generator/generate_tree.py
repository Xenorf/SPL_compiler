import json
import random

leafs,random_numbers = [],[0]


def generate_new_random():
    new_random = 0
    while new_random in random_numbers:
        new_random = random.randrange(1,10000)
    random_numbers.append(new_random)
    return new_random

# Read data from the file to make a string and then interpret it as JSON
def read_parser_output() :
    with open("tree_generator/output",'r') as f:
        s = f.read().strip("\n")
    data = json.loads(s)
    return data

# Parse the JSON to make an matrix with rows being a reference between a parent and a child and the value of the child
def get_leafs(treedict, parent=None,parent_nb=0,parent_value=0) :
    if treedict == "NULL" :
        return
    name = next(iter(treedict.keys()))
    parent_value = treedict[name]
    child_nb=generate_new_random()
    if parent is not None:
        leafs.append((parent+str(parent_nb), name+str(child_nb),parent_value))
    if "children" in treedict.keys() :
        for j in range(1,len(treedict["children"])) :
            get_leafs(treedict["children"][j-1],parent = name,parent_nb=child_nb,parent_value=parent_value)

# Printing the matrix in an understandable way for Graphviz
def print_graphviz_tree(leafs):
    print('strict digraph tree {')
    for row in leafs:
        row_nodigit = ''.join([i for i in row[1] if not i.isdigit()])
        print('{0} [label="{1} {2}"];'.format(row[1],row_nodigit,row[2].replace("'","")))
        print('    {0} -> {1};'.format(row[0],row[1]))
    print('}')

data = read_parser_output()
get_leafs(data,"ROOT")
print_graphviz_tree(leafs)