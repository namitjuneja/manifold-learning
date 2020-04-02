def get_max_degree_node_weight(graph):
    
    # Step 1: Filter all the black nodes and choose one as default.
    black_nodes = list(filter(lambda x: x[1]['color'] == 1, graph.nodes(data=True)))
    #black_nodes = graph.nodes(data=True)
    if len(black_nodes) > 0:
        max_degree_node = black_nodes[0][0]
    else:
        # when 0 black nodes exist
        # that means only 1 white node exists
        return 1
    
    # Step 2: Iterate over the rest of the nodes and find the most connected black node. 
    for node in black_nodes:
        if graph.degree[node[0]] > graph.degree[max_degree_node]:
            max_degree_node = node[0]
        elif graph.degree[node[0]] == graph.degree[max_degree_node]:
            if node[1]['area'] > graph.nodes(data=True)[max_degree_node]['area']:
                max_degree_node = node[0]

    return max_degree_nod




def get_max_degree_node_original(graph):
    
    # Step 1: Filter all the black nodes and choose one as default.
    black_nodes = list(filter(lambda x: x[1]['color'] == 1, graph.nodes(data=True)))
    #black_nodes = graph.nodes(data=True)
    if len(black_nodes) > 0:
        max_degree_node = black_nodes[0][0]
    else:
        # when 0 black nodes exist
        # that means only 1 white node exists
        return 1
    
    # Step 2: Iterate over the rest of the nodes and find the most connected black node. 
    for node in black_nodes:
        if graph.degree[node[0]] > graph.degree[max_degree_node]:
            max_degree_node = node[0]
        #elif graph.degree[node[0]] == graph.degree[max_degree_node]:
        #    if node[1]['area'] > graph.nodes(data=True)[max_degree_node]['area']:
        #        max_degree_node = node[0]

    return max_degree_node