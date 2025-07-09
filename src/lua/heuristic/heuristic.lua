local decorators = require("src.lua.utils.decorators")

local INF = math.huge

local function hamiltonian_nearest_neighbor(graph, counter)
  local n = #graph
  if n == 0 then return nil, INF end

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
      if not visited[neighbor] then
        if counter then counter[1] = counter[1] + 1 end
        if graph[current_node][neighbor] < min_dist then
          min_dist = graph[current_node][neighbor]
          nearest_neighbor = neighbor
        end
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

  local final_edge_cost = graph[path[#path]][start_node]
  if final_edge_cost == INF then
    return nil, INF
  end

  table.insert(path, start_node)
  cost = cost + final_edge_cost

  return path, cost
end

-- Aplicar decoradores
hamiltonian_nearest_neighbor = decorators.time_it(
    decorators.count_nn_ops(hamiltonian_nearest_neighbor))

return hamiltonian_nearest_neighbor
