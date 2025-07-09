local h_bt = require('src.lua.backtrack.backtrack')
local h_dp = require('src.lua.dynamic.dynamic')
local h_nn = require('src.lua.heuristic.heuristic')

local INF = math.huge

local function run_experiment_on_graph(adj_matrix, title)
  print('')
  print(string.rep('=', 70))
  print(title)
  print(string.rep('=', 70))

  local function process_and_print(algorithm_func)
    local path, cost = algorithm_func(adj_matrix)
    if path then
      print('  -> Ruta encontrada:', table.concat(path, ' -> '))
      print(string.format('  -> Costo del circuito: %d', cost))
    else
      print('  -> No se encontró un circuito hamiltoniano en el grafo.')
    end
    print(string.rep('-', 40))
  end

  process_and_print(h_bt)
  if #adj_matrix <= 20 then
    process_and_print(h_dp)
  else
    print('--- Programación Dinámica omitida por tamaño de grafo > 20 ---\n')
  end
  process_and_print(h_nn)
end

-- Definición de grafos (matrices de adyacencia)
local G1 = {
    {INF, 10, 15, 20},
    {10, INF, 35, 25},
    {15, 35, INF, 30},
    {20, 25, 30, INF},
}

local G2 = {
    {INF, 1, 1, INF},
    {1, INF, INF, 1},
    {1, INF, INF, 1},
    {INF, 1, 1, INF},
}

-- Dodecaedro de 20 nodos, no es generado automáticamente en Lua.
-- Aquí usamos un grafo regular de grado 3 como ejemplo alternativo:
local function generate_regular_graph(n, d)
  local graph = {}
  for i = 1, n do
    graph[i] = {}
    for j = 1, n do
      graph[i][j] = INF
    end
  end
  for i = 1, n do
    for j = 1, d do
      local neighbor = ((i + j - 1) % n) + 1
      graph[i][neighbor] = 1
      graph[neighbor][i] = 1
    end
  end
  return graph
end

local G3 = generate_regular_graph(20, 3)

-- Ejecutar experimentos
run_experiment_on_graph(G1, 'Prueba 1: Grafo completo con pesos (K4)')
run_experiment_on_graph(G2, 'Prueba 2: Grafo sin circuito Hamiltoniano')
run_experiment_on_graph(G3, 'Prueba 3: Grafo regular de grado 3 (N = 20)')
