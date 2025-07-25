local decorators = require('src.lua.utils.decorators')

local INF = math.huge

local function hamiltonian_backtracking(graph, context)
  local n = #graph
  local path = {}
  local visited = {}
  local best_cost = INF
  local best_path = {}

  for i = 1, n do
    path[i] = -1
    visited[i] = false
  end

  path[1] = 1
  visited[1] = true

  local function solve(pos, current_cost)
    if pos > n then
      local last_leg = graph[path[n]][path[1]]
      if last_leg ~= INF then
        local total_cost = current_cost + last_leg
        if total_cost < best_cost then
          best_cost = total_cost
          for i = 1, n do
            best_path[i] = path[i]
          end
        end
      end
      return
    end

    for v = 1, n do
      if context and context._internal_counter then
        context._internal_counter[1] = context._internal_counter[1] + 1
      end

      local last_vertex = path[pos - 1]
      if graph[last_vertex][v] ~= INF and not visited[v] then
        path[pos] = v
        visited[v] = true
        solve(pos + 1, current_cost + graph[last_vertex][v])
        visited[v] = false
        path[pos] = -1
      end
    end
  end

  solve(2, 0)

  if best_cost < INF then
    local final_path = {}
    for i = 1, n do
      final_path[i] = best_path[i]
    end
    final_path[n + 1] = best_path[1]

    return final_path, best_cost
  else
    return nil, INF
  end
end

-- Aplicar decoradores en orden: count → memory → time
hamiltonian_backtracking = decorators.time_it(
  decorators.measure_memory(
    decorators.count_ops(hamiltonian_backtracking)
  )
)

return hamiltonian_backtracking
