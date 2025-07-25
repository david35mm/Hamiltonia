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
  best_cost = [INF]
  best_path = [None]

  path[0] = 0
  visited[0] = True

  def solve(pos, current_cost):
    if pos == n:
      last_leg = graph[path[pos - 1]][path[0]]
      if last_leg != INF:
        total_cost = current_cost + last_leg
        if total_cost < best_cost[0]:
          best_cost[0] = total_cost
          best_path[0] = path[:]
      return

    for v in range(n):
      if counter:
        counter[0] += 1
      last_vertex = path[pos - 1]
      if graph[last_vertex][v] != INF and not visited[v]:
        visited[v] = True
        path[pos] = v
        solve(pos + 1, current_cost + graph[last_vertex][v])
        visited[v] = False
        path[pos] = -1

  solve(1, 0)

  if best_path[0] is not None:
    final_path = best_path[0] + [best_path[0][0]]
    return (final_path, best_cost[0])
  return (None, INF)
