local decorators = require('src.lua.utils.decorators')

local INF = math.huge

local function hamiltonian_backtracking(graph, context)
  local n = #graph
  if n == 0 then
    return nil, INF
  end

  local best_path = {}
  local best_cost = INF

  local visited = {}
  for i = 1, n do
    visited[i] = false
  end
  visited[1] = true

  local current_path = {1}
  local current_cost = 0

  local function backtrack(path, cost, visited_nodes)
    if #path == n then
      local last_node = path[#path]
      if graph[last_node][1] ~= INF then
        local total_cost = cost + graph[last_node][1]
        if context and context._internal_counter then
          context._internal_counter[1] = context._internal_counter[1] +
              1 -- Contar suma
        end
        if total_cost < best_cost then
          if context and context._internal_counter then
            context._internal_counter[1] = context._internal_counter[1] +
                1 -- Contar comparación
          end
          best_cost = total_cost
          best_path = {}
          for i = 1, #path do
            best_path[i] = path[i]
          end
          table.insert(best_path, 1) -- Cerrar el ciclo
        end
      end
      return
    end

    local current_node = path[#path]
    for next_node = 1, n do
      if not visited_nodes[next_node] and graph[current_node][next_node] ~= INF then
        local new_cost = cost + graph[current_node][next_node]
        if context and context._internal_counter then
          context._internal_counter[1] = context._internal_counter[1] +
              1 -- Contar suma
        end
        visited_nodes[next_node] = true
        table.insert(path, next_node)
        backtrack(path, new_cost, visited_nodes)
        table.remove(path)
        visited_nodes[next_node] = false
      end
    end
  end

  backtrack(current_path, current_cost, visited)

  if best_cost == INF then
    return nil, INF
  end

  return best_path, best_cost
end

-- Aplicar decoradores en orden: count → memory → time
hamiltonian_backtracking = decorators.time_it(
  decorators.measure_memory(
    decorators.count_ops(hamiltonian_backtracking)
  )
)

return hamiltonian_backtracking
