from src.python.utils.decorators import count_nn_ops
from src.python.utils.decorators import time_it

INF = float('inf')


@time_it
@count_nn_ops
def hamiltonian_nearest_neighbor(graph, counter=None):
  n = len(graph)
  if n == 0:
    return (None, INF)
  start_node = 0
  path = [start_node]
  visited = {start_node}
  cost = 0
  current_node = start_node
  while len(path) < n:
    nearest_neighbor = -1
    min_dist = INF
    for neighbor in range(n):
      if neighbor not in visited:
        if counter:
          counter[0] += 1
        if graph[current_node][neighbor] < min_dist:
          min_dist = graph[current_node][neighbor]
          nearest_neighbor = neighbor
    if nearest_neighbor == -1:
      return (None, INF)
    path.append(nearest_neighbor)
    visited.add(nearest_neighbor)
    cost += min_dist
    current_node = nearest_neighbor
  final_edge_cost = graph[path[-1]][start_node]
  if final_edge_cost == INF:
    return (None, INF)
  path.append(start_node)
  cost += final_edge_cost
  return (path, cost)
