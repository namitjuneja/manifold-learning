
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
    
    vector = np.array(vector)          
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

	plt.plot(range(start_slice,D.shape[0]+start_slice),D[compare_with-start_slice, :], label="Root node of any color")

	plt.title(f"Comparing #{compare_with} point with the rest of the points")
	plt.xlabel("Points in trajectory")
	plt.ylabel("Points in trajectory")
	plt.legend()




## PADDING FUNCTIONS

# front pad vector
def front_pad(vector, max_dimension):
    # make no array if not
    if not isinstance(vector, np.ndarray): vector=np.array(vector)

    return np.pad(vector, (0,max_dimension-len(vector)))


# # generate padded vectors
def generate_padded_vectors(vectors):
    split_vectors = []

    for vector in vectors:
        # split the nodes based on sign
        split_indices = []

        for index,d in enumerate(vector):
            if d >= 0:
                split_indices.extend([index, index+1])

        split_vector = np.split(vector, split_indices)
        split_vectors.append(split_vector)



    # get the maximum length of split at each 
    # position for all the vectors
    max_split_length = {}

    for split_vector in split_vectors:
        for index, split in enumerate(split_vector):
            max_split_length[index] = max([len(split), max_split_length.get(index, 0)])



    # pad all the splits to their 
    # respective max lengths
    padded_split_vectors = []
    for split_vector in split_vectors:

        padded_split_vector = []
        for index,split in enumerate(split_vector):

            padded_split = front_pad(split, max_split_length[index])
            padded_split_vector.append(padded_split)

        padded_split_vectors.append(padded_split_vector)



    # Merge all splits into single vector
    merged_vectors = []
    for padded_split_vector in padded_split_vectors:
        merged_vector = np.concatenate(padded_split_vector)
        merged_vectors.append(merged_vector)


    # over all frontpad to compensate for
    # different number of layers in each graph
    max_dimension = max(map(len, merged_vectors))

    padded_vectors = []
    for merged_vector in merged_vectors:

        padded_vector = front_pad(merged_vector, max_dimension)
        padded_vectors.append(padded_vector)


    # make all vector dimension magnitudes 
    # positive irrespective of color
    positive_vectors = []
    for padded_vector in padded_vectors:

        positive_vector = np.abs(padded_vector)
        positive_vectors.append(positive_vector)

    # write some tests maybe
    return positive_vectors