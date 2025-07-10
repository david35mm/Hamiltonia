from src.python.utils.decorators import count_dp_ops
from src.python.utils.decorators import measure_memory
from src.python.utils.decorators import time_it

INF = float('inf')


@time_it
@count_dp_ops
@measure_memory
def hamiltonian_dp(graph, counter=None):
  n = len(graph)
  if n == 0:
    return (None, INF)
  dp = [[INF] * n for _ in range(1 << n)]
  dp[1][0] = 0
  for mask in range(1, 1 << n):
    for i in range(n):
      if (mask >> i) & 1:
        for j in range(n):
          if i != j and (mask >> j) & 1:
            if counter:
              counter[0] += 1
            prev_mask = mask ^ (1 << i)
            if dp[prev_mask][j] != INF and graph[j][i] != INF:
              dp[mask][i] = min(dp[mask][i], dp[prev_mask][j] + graph[j][i])
  final_mask = (1 << n) - 1
  min_cost = INF
  last_vertex = -1
  for i in range(1, n):
    if dp[final_mask][i] != INF and graph[i][0] != INF:
      cost = dp[final_mask][i] + graph[i][0]
      if cost < min_cost:
        min_cost = cost
        last_vertex = i
  if last_vertex == -1:
    return (None, INF)
  path = [0] * (n + 1)
  current_mask = final_mask
  current_vertex = last_vertex
  for i in range(n - 1, 0, -1):
    path[i] = current_vertex
    prev_mask = current_mask ^ (1 << current_vertex)
    for j in range(n):
      if (prev_mask >> j
         ) & 1 and dp[prev_mask][j] != INF and graph[j][current_vertex] != INF:
        if abs(dp[current_mask][current_vertex] -
               (dp[prev_mask][j] + graph[j][current_vertex])) < 1e-9:
          current_vertex = j
          current_mask = prev_mask
          break
  path[0] = 0
  path[n] = 0
  return (path, min_cost)
