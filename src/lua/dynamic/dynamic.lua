local decorators = require('src.lua.utils.decorators')

local INF = math.huge

local function hamiltonian_dp(graph, counter)
  local n = #graph
  if n == 0 then return nil, INF end

  local dp = {}
  for mask = 1, (1 << n) do
    dp[mask] = {}
    for i = 1, n do
      dp[mask][i] = INF
    end
  end
  dp[1][1] = 0 -- iniciar desde el nodo 1 (índice 1 en Lua)

  for mask = 1, (1 << n) - 1 do
    for i = 1, n do
      if (mask & (1 << (i - 1))) ~= 0 then
        for j = 1, n do
          if i ~= j and (mask & (1 << (j - 1))) ~= 0 then
            if counter then counter[1] = counter[1] + 1 end
            local prev_mask = mask ~ (1 << (i - 1))
            if dp[prev_mask][j] ~= INF and graph[j][i] ~= INF then
              local cost = dp[prev_mask][j] + graph[j][i]
              if cost < dp[mask][i] then
                dp[mask][i] = cost
              end
            end
          end
        end
      end
    end
  end

  local final_mask = (1 << n) - 1
  local min_cost = INF
  local last_vertex = -1
  for i = 2, n do -- terminamos en cualquier nodo distinto de 1
    if dp[final_mask][i] ~= INF and graph[i][1] ~= INF then
      local cost = dp[final_mask][i] + graph[i][1]
      if cost < min_cost then
        min_cost = cost
        last_vertex = i
      end
    end
  end

  if last_vertex == -1 then return nil, INF end

  -- reconstruir camino
  local path = {}
  local current_mask = final_mask
  local current_vertex = last_vertex
  for i = n, 2, -1 do
    path[i] = current_vertex
    local prev_mask = current_mask ~ (1 << (current_vertex - 1))
    for j = 1, n do
      if (prev_mask & (1 << (j - 1))) ~= 0 and dp[prev_mask][j] ~= INF and graph[j][current_vertex] ~= INF then
        local expected = dp[prev_mask][j] + graph[j][current_vertex]
        if math.abs(dp[current_mask][current_vertex] - expected) < 1e-9 then
          current_vertex = j
          current_mask = prev_mask
          break
        end
      end
    end
  end
  path[1] = 1
  path[n + 1] = 1

  return path, min_cost
end

-- Aplicar decoradores
hamiltonian_dp = decorators.time_it(
    decorators.count_dp_ops(hamiltonian_dp))

return hamiltonian_dp
