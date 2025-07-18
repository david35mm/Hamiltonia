local decorators = require('src.lua.utils.decorators')

local INF = math.huge

local function hamiltonian_nearest_neighbor(graph, context)
  local n = #graph
  if n == 0 then
    return nil, INF
  end

  local start_node = 1
  local path = {start_node}
  local visited = {}
  visited[start_node] = true
  local cost = 0
  local current_node = start_node

  while #path < n do
    local nearest_neighbor = -1
    local min_dist = INF
    for neighbor = 1, n do
      if not visited[neighbor] and graph[current_node][neighbor] < min_dist then
        if context and context._internal_counter then
          context._internal_counter[1] = context._internal_counter[1] + 1
        end
        min_dist = graph[current_node][neighbor]
        nearest_neighbor = neighbor
      end
    end

    if nearest_neighbor == -1 then
      return nil, INF
    end

    table.insert(path, nearest_neighbor)
    visited[nearest_neighbor] = true
    cost = cost + min_dist
    current_node = nearest_neighbor
  end

  local final_edge_cost = graph[current_node][start_node]
  if final_edge_cost == INF then
    return nil, INF
  end

  table.insert(path, start_node)
  cost = cost + final_edge_cost

  return path, cost
end

-- Aplicar decoradores en orden: count → memory → time
hamiltonian_nearest_neighbor = decorators.time_it(
  decorators.measure_memory(
    decorators.count_ops(hamiltonian_nearest_neighbor)
  )
)

return hamiltonian_nearest_neighbor
