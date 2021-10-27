from __future__ import print_function
import json
import sys


s = '{"PROGRAM":"ProgB","children":[{"BLOCK":"NOTHING","children":[{"DECLARATION_BLOCK":"NOTHING","children":[{"IDENTIFIER_LIST":"b","children":[{"IDENTIFIER_VALUE":"a"},"NULL","NULL"]},{"TYPE_VALUE":"263","children":["NULL","NULL","NULL"]},{"DECLARATION_BLOCK":"NOTHING","children":[{"IDENTIFIER_VALUE":"c"},{"TYPE_VALUE":"262","children":["NULL","NULL","NULL"]},{"DECLARATION_BLOCK":"NOTHING","children":[{"IDENTIFIER_LIST":"e","children":[{"IDENTIFIER_VALUE":"d"},"NULL","NULL"]},{"TYPE_VALUE":"264","children":["NULL","NULL","NULL"]},"NULL"]}]}]},{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT":"NOTHING","children":[{"READ_STATEMENT":"a","children":["NULL","NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},{"STATEMENT":"NOTHING","children":[{"READ_STATEMENT":"b","children":["NULL","NULL","NULL"]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"IF_STATEMENT":"NOTHING","children":[{"CONDITIONAL":"NOTHING","children":[{"EXPRESSION":"NOTHING","children":[{"TERM":"NOTHING","children":[{"IDENTIFIER_VALUE":"a"},"NULL","NULL"]},"NULL","NULL"]},{"COMPARATOR":"289","children":["NULL","NULL","NULL"]},{"EXPRESSION":"NOTHING","children":[{"TERM":"NOTHING","children":[{"IDENTIFIER_VALUE":"b"},"NULL","NULL"]},"NULL","NULL"]}]},{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NOTHING","children":[{"OUTPUT_LIST":"NOTHING","children":[{"VALUE":"NOTHING","children":[{"CONSTANT":"NOTHING","children":[{"CHARACTER_CONSTANT":"\'A\'"},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},{"STATEMENT_LIST":"NOTHING","children":[{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NOTHING","children":[{"OUTPUT_LIST":"NOTHING","children":[{"VALUE":"NOTHING","children":[{"CONSTANT":"NOTHING","children":[{"CHARACTER_CONSTANT":"\'B\'"},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]}]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NEWLINE"},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"READ_STATEMENT":"d","children":["NULL","NULL","NULL"]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"ASSIGNMENT_STATEMENT":"e","children":[{"EXPRESSION":"NOTHING","children":[{"TERM":"NOTHING","children":[{"TERM":"NOTHING","children":[{"IDENTIFIER_VALUE":"d"},"NULL","NULL"]},{"VALUE":"NOTHING","children":[{"CONSTANT":"NOTHING","children":[{"NUMBER_CONSTANT":"NOTHING","children":[{"NUMBER_VALUE":"2"},{"NUMBER_VALUE":"3"},"NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NOTHING","children":[{"OUTPUT_LIST":"NOTHING","children":[{"IDENTIFIER_VALUE":"e"},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NEWLINE"},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"READ_STATEMENT":"c","children":["NULL","NULL","NULL"]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NOTHING","children":[{"OUTPUT_LIST":"NOTHING","children":[{"IDENTIFIER_VALUE":"c"},"NULL","NULL"]},"NULL","NULL"]},"NULL","NULL"]},"NULL"]},{"STATEMENT":"NOTHING","children":[{"WRITE_STATEMENT":"NEWLINE"},"NULL","NULL"]},"NULL"]},"NULL"]},"NULL","NULL"]}'
data = json.loads(s)

leafs = []
def get_leafs(treedict, parent=None,child_nb=0,parent_value=0) :
    if treedict == "NULL" :
        return
    name = next(iter(treedict.keys()))
    parent_value = treedict[name]
    if parent is not None:
        leafs.append((parent+str(child_nb-1), name+str(child_nb),parent_value))
    
    if "children" in treedict.keys() :
        for item in treedict["children"] :
            get_leafs(item,parent = name,child_nb=child_nb+1,parent_value=parent_value)

get_leafs(data)

print('strict digraph tree {')
for row in leafs:
    row_nodigit = ''.join([i for i in row[1] if not i.isdigit()])
    print('{0} [label="{1} {2}"];'.format(row[1],row_nodigit,row[2].replace("'","")))
    print('    {0} -> {1};'.format(row[0],row[1]))
print('}')
