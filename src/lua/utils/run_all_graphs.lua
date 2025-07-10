local loader = require('src.lua.utils.load_graph')
local h_bt = require('src.lua.backtrack.backtrack')
local h_dp = require('src.lua.dynamic.dynamic')
local h_nn = require('src.lua.heuristic.heuristic')


-- Funcion para correr los algoritmos desde archivos txt
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
    collectgarbage('collect')
    local mem_before = collectgarbage('count')

    local path, cost = algorithm_func(graph)

    collectgarbage('collect')
    local mem_after = collectgarbage('count')
    local mem_used = mem_after - mem_before
    -- No es memoria estrictamente usada solo por el algoritmo. Incluye todo
    -- lo que el recolector de basura mantiene vivo.
    -- Puede haber ruido si se ejecutan otras tareas de fondo en Lua.
    -- No distingue entre código del algoritmo y estructuras de datos previas.

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
    print(string.format('  -> Memoria estimada usada: %.2f KB', mem_used))
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


-- Lista todos los archivos .txt usando `find` (Solo aplica UNIX-like)
local function get_txt_files_from_dir(path)
  local handle = io.popen('find \"' .. path .. "\" -type f -name '*.txt'")
  local result = {}
  if handle then
    for line in handle:lines() do
      table.insert(result, line)
    end
    handle:close()
  end
  return result
end


-- Main
local files = get_txt_files_from_dir('data')
for _, filepath in ipairs(files) do
  run_algorithms_on_file(filepath)
end
