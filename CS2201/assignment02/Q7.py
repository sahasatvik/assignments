#!/usr/bin/env python3

# Take the total number of edges beforehand
n = int(input("Enter the total number of edges : "))
# Populate a list of graph edges
graph = []
for i in range(n):
    a, b = input("Enter the two nodes forming an edge, space separated : ").split()
    # Each edge is of the form (a, b), where 'a' and 'b' are nodes
    graph.append([a, b])

adjlst = dict()
# Create a dictionary of adjacency lists by iterating through
# all the edges, then adding each node to the others' adjacency list
for a, b in graph:
    # Make sure that the dictionary entry for the node is present, and not empty
    if not a in adjlst:
        adjlst[a] = []
    if not b in adjlst:
        adjlst[b] = []
    
    # Disallow multiple connections.
    if not a in adjlst[b]:
        adjlst[b].append(a)
    if not b in adjlst[a]:
        adjlst[a].append(b)


print("Graph edges : ", graph)
print("Adjacency lists : ", adjlst)

