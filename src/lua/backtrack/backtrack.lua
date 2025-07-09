local decorators = require('src.lua.utils.decorators')

local INF = math.huge

local function hamiltonian_backtracking(graph, counter)
  local n = #graph
  local path = {}
  local visited = {}
  for i = 1, n do
    path[i] = -1
    visited[i] = false
  end
  path[1] = 1 -- índices Lua empiezan en 1
  visited[1] = true

  local function solve(pos)
    if pos > n then
      if counter then counter[1] = counter[1] + 1 end
      return graph[path[n]][path[1]] ~= INF
    end
    for v = 1, n do
      if counter then counter[1] = counter[1] + 1 end
      local last_vertex = path[pos - 1]
      if graph[last_vertex][v] ~= INF and not visited[v] then
        path[pos] = v
        visited[v] = true
        if solve(pos + 1) then return true end
        visited[v] = false
        path[pos] = -1
      end
    end
    return false
  end

  if solve(2) then
    local final_path = {}
    for i = 1, n do final_path[i] = path[i] end
    final_path[n + 1] = path[1]

    local cost = 0
    for i = 1, n do
      cost = cost + graph[final_path[i]][final_path[i + 1]]
    end
    return final_path, cost
  end

  return nil, INF
end

-- Aplicar decoradores
hamiltonian_backtracking = decorators.time_it(
    decorators.count_backtracking_ops(hamiltonian_backtracking))

return hamiltonian_backtracking
