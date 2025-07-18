local loader = require('src.lua.utils.load_graph')
local h_bt = require('src.lua.backtrack.backtrack')
local h_dp = require('src.lua.dynamic.dynamic')
local h_nn = require('src.lua.heuristic.heuristic')
local decorators = require('src.lua.utils.decorators')

local function run_algorithms_on_file(filepath)
  print('\n' .. string.rep('=', 70))
  print('Archivo:', filepath)
  print(string.rep('=', 70))

  local ok, graph = pcall(loader.load_graph_txt, filepath)
  if not ok then
    print('  -> Error al cargar el grafo:', graph)
    return
  end

  local function run_and_print(algorithm_func, label)
    print('\n[' .. label .. ']')

    local context = decorators.new_execution_context()
    local path, cost = algorithm_func(graph, context)

    print(string.format('--- Ejecutando función: %s ---', label))

    if path then
      print('  -> Ruta encontrada:', table.concat(path, ' -> '))
      if cost == math.huge then
        print('  -> Costo del circuito: N/A')
      else
        print(string.format('  -> Costo del circuito: %.2f', cost))
      end
    else
      print('  -> No se encontró un circuito hamiltoniano.')
    end

    print(string.format('  -> Tiempo: %.4fs', context.time_seconds or 0))
    print(string.format('  -> Memoria estimada usada: %.2f KB',
                        context.memory_peak_kb or 0))
    print(string.format('  -> Operaciones: %s', context.ops_count or 0))
    print(string.rep('-', 40))
  end

  run_and_print(h_bt, 'Backtracking')
  if #graph <= 20 then
    run_and_print(h_dp, 'Programación Dinámica')
  else
    print('  -> Programación Dinámica omitida por tamaño del grafo > 20')
  end
  run_and_print(h_nn, 'Heurística - Vecino Más Cercano')
end

local function get_txt_files_from_dir(path)
  local handle = io.popen('find "' .. path .. '" -type f -name "*.txt"')
  local result = {}
  if handle then
    for line in handle:lines() do
      table.insert(result, line)
    end
    handle:close()
  end
  return result
end

local files = get_txt_files_from_dir('data')
for _, filepath in ipairs(files) do
  run_algorithms_on_file(filepath)
end
