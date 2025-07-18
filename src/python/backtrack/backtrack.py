from src.python.utils.decorators import count_ops
from src.python.utils.decorators import measure_memory
from src.python.utils.decorators import time_it

INF = float('inf')


@time_it
@measure_memory
@count_ops
def hamiltonian_backtracking(graph, context, counter=None):
  n = len(graph)
  path = [-1] * n
  visited = [False] * n
  path[0] = 0
  visited[0] = True

  def solve(pos):
    if pos == n:
      if counter:
        counter[0] += 1
      return graph[path[pos - 1]][path[0]] != INF
    for v in range(n):
      if counter:
        counter[0] += 1
      last_vertex = path[pos - 1]
      if graph[last_vertex][v] != INF and not visited[v]:
        path[pos] = v
        visited[v] = True
        if solve(pos + 1):
          return True
        visited[v] = False
        path[pos] = -1
    return False

  if solve(1):
    final_path = path + [path[0]]
    cost = sum(graph[final_path[i]][final_path[i + 1]] for i in range(n))
    return (final_path, cost)
  return (None, INF)
