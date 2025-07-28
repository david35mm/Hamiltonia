from src.python.utils.decorators import count_ops
from src.python.utils.decorators import measure_memory
from src.python.utils.decorators import time_it

INF = float('inf')


@time_it
@measure_memory
@count_ops
def hamiltonian_backtracking(graph, context, counter=None):
  n = len(graph)
  if n == 0:
    return (None, INF)

  best_path = []
  best_cost = INF

  visited = [False] * n
  visited[0] = True
  current_path = [0]
  current_cost = 0

  def backtrack(path, cost, visited_nodes):
    nonlocal best_path, best_cost
    if len(path) == n:
      last_node = path[-1]
      if graph[last_node][0] != INF:
        total_cost = cost + graph[last_node][0]
        if counter:
          counter[0] += 1  # Contar la operación de suma
        if total_cost < best_cost:
          if counter:
            counter[0] += 1  # Contar la comparación
          best_cost = total_cost
          best_path = path[:] + [0]
      return

    for next_node in range(n):
      if not visited_nodes[next_node] and graph[path[-1]][next_node] != INF:
        if counter:
          counter[0] += 1  # Contar la operación de suma
        new_cost = cost + graph[path[-1]][next_node]
        visited_nodes[next_node] = True
        path.append(next_node)
        backtrack(path, new_cost, visited_nodes)
        path.pop()
        visited_nodes[next_node] = False

  backtrack(current_path, current_cost, visited)

  if best_cost == INF:
    return (None, INF)
  return (best_path, best_cost)
