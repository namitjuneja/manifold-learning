
import pickle
import numpy as np
from tqdm.notebook import tqdm
from sklearn.metrics import pairwise_distances
from pathlib import Path
import networkx as nx
from matplotlib import pyplot as plt
import copy

# get graph from file
def get_graph_from_file(phi, chi, replica, source_dir=None):
	if source_dir:
		graphs = pickle.load(open(source_dir, 'rb'))[:80]
	else:
		trajectory_filename = f"BR{phi}-CHI{chi}-R{replica}.file"
		source_dir = Path("/home/namit/codes/Entropy-Isomap/outputs/graphs/")/trajectory_filename
		graphs = pickle.load(open(source_dir, 'rb'))[:80]

	print(f"> {len(graphs)} points loaded from file {trajectory_filename}.")
	return graphs


# get max degree node 
def get_max_degree_node_color(graph):
    
    # Step 1: Filter all the black nodes and choose one as default.
    #black_nodes = list(filter(lambda x: x[1]['color'] == 0, graph.nodes(data=True)))
    black_nodes = list(graph.nodes(data=True))
    max_degree_node = black_nodes[0][0]
    
    # Step 2: Iterate over the rest of the nodes and find the most connected black node. 
    for node in black_nodes:
        if graph.degree[node[0]] > graph.degree[max_degree_node]:
            max_degree_node = node[0]
        elif graph.degree[node[0]] == graph.degree[max_degree_node]:
            if node[1]['area'] > graph.nodes(data=True)[max_degree_node]['area']:
                max_degree_node = node[0]

    return max_degree_node


# priority bfs
def priority_bfs(graph, root):
    vector  = []
    visited = []
    queue   = []
    
    visited.append(root)
    queue.append((root,graph.nodes[root]['area']/root,graph.nodes[root]['perimeter']))
    
    while queue:
        
        # Step A: Dequeue it to the vector
        current_node = queue.pop(0)
        
        
        # Step B: Append it to the vector
        vector.append(((-1)**(graph.nodes[current_node[0]]['color']+1)) * (current_node[1]))
        #vector.append(current_node[1])
        #vector.append(graph.nodes[current_node[0]]['area'])
        
        #set_trace()
        
        # Step C: Get all of elements children 
        # Storage format : [ (<node>, <node_area>) , (<node>, <node_area>), ... ]
        current_node_neighbors = []
        for neighbor in graph.neighbors(current_node[0]):
            volume_to_surface_ratio = graph.nodes()[neighbor]['area'] / graph[current_node[0]][neighbor]['weight']
            current_node_neighbors.append((neighbor, volume_to_surface_ratio))
        
        #current_node_neighbors = [(neighbor, graph.nodes()[neighbor]['area']) for neighbor in graph.neighbors(current_node[0])]
        
            
        # Step D: Sort them by their area and enqueue them
        # sorting
        current_node_neighbors.sort(key = lambda x: x[1])
        # enqueueing
        # make sure that node has not been visited first
        # althugh that should not happen since the graph is
        # always acyclic
        for neighbor in current_node_neighbors:
            if neighbor[0] not in visited:
                visited.append(neighbor[0])
                queue.append(neighbor)
    #set_trace()           
    return vector      


# generate vectors
def generate_vectors(graphs):
    vectors = []

    for graph in graphs:
        # set the node with the highest edges as root
        root = get_max_degree_node_color(graph)
    
        # get BFS vector
        vector = priority_bfs(graph, root)
        vectors.append(vector)
    
    return vectors


# generate padded vectors
def generate_padded_vectors(vectors, max_dimension=None):
    # get the dimension of the most dimensional vector
    max_dimension = max_dimension or max((map(len, vectors))) 
    print(f"> Padding to max dimension - {max_dimension}")
    
    # pad with zeros in the end
    padded_vectors = []
    for i in range(len(vectors)):
        padded_vectors.append(vectors[i] + [0]*(max_dimension-len(vectors[i])))

    padded_vectors = np.array(padded_vectors)

    return padded_vectors


# plot distance matrix
def plot_distance_matrix(D):
	fig = plt.figure()
	plt.imshow(D)
	cbar = plt.colorbar(fraction=0.046, pad=0.04)
	plt.xlabel("Points in trajectory")
	plt.ylabel("Points in trajectory")


# plot distance graph
def plot_distance_graph(D, compare_with, start_slice):
	assert compare_with>=start_slice, "compare_with must be >= start_slice"
	fig, ax = plt.subplots()

	major_ticks = np.arange(start_slice, D.shape[0]+1+start_slice, 10)
	minor_ticks = np.arange(start_slice, D.shape[0]+1+start_slice, 1)
	ax.set_xticks(major_ticks)
	ax.set_xticks(minor_ticks, minor=True)
	plt.grid(True, which="minor", linestyle=':')
	plt.grid(True, which="major", linestyle='-')

	plt.plot(range(start_slice,D.shape[0]+start_slice),D[compare_with-start_slice, :], color="blue", label="Root node of any color")

	plt.title(f"Comparing #{compare_with} point with the rest of the points")
	plt.xlabel("Points in trajectory")
	plt.ylabel("Points in trajectory")
	plt.legend()