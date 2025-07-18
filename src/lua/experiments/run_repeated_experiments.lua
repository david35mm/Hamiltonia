local bt = require('src.lua.backtrack.backtrack')
local dp = require('src.lua.dynamic.dynamic')
local nn = require('src.lua.heuristic.heuristic')
local loader = require('src.lua.utils.load_graph')
local decorators = require('src.lua.utils.decorators')

local results_filename = 'results/lua/repeated_experiment_results.csv'
local base_dir = 'data'
local repetitions = 5

-- Función para obtener todos los archivos .txt en subdirectorios de base_dir (solo para sistemas UNIX-like)
local function get_files_in_dir(base_path)
  local handle = io.popen('find ' .. base_path .. ' -type f -name "*.txt"')
  if not handle then
    error('No se pudo abrir el proceso para listar archivos en: ' .. base_path)
  end

  local files = {}
  for file in handle:lines() do
    table.insert(files, file)
  end
  handle:close()
  return files
end

-- Crear directorio si no existe
local function ensure_dir_exists(path)
  os.execute('mkdir -p ' .. path)
end

ensure_dir_exists('results/lua')

-- Cabecera CSV
local headers = {
  'instance_name',
  'graph_type',
  'size_n',
  'algorithm',
  'run_id',
  'time_seconds',
  'cost',
  'path_found',
  'ops_count',
  'memory_peak_kb',
}

-- Escribir resultados al CSV
local function write_csv(path, headers, data)
  local file = io.open(path, 'w')
  if not file then
    error('No se pudo escribir el archivo de resultados: ' .. path)
  end
  file:write(table.concat(headers, ',') .. '\n')
  for _, row in ipairs(data) do
    local line = {}
    for _, val in ipairs(row) do
      table.insert(line, tostring(val))
    end
    file:write(table.concat(line, ',') .. '\n')
  end
  file:close()
end

-- Ejecutar experimento
local function run_experiments()
  local results = {}
  print('Iniciando experimento repetido...')

  local algorithms = {
    Backtracking = bt,
    DP = dp,
    NearestNeighbor = nn,
  }

  for _, filepath in ipairs(get_files_in_dir(base_dir)) do
    print('\n--- Probando instancia: ' .. filepath .. ' ---')

    local graph = loader.load_graph_txt(filepath)
    local n = #graph
    local filename = filepath:match('([^/]+)%.txt$') or 'unknown'
    local graph_type = filepath:match(base_dir .. '/([^/]+)/') or 'unknown'

    for algo_name, algo_func in pairs(algorithms) do
      if algo_name == 'DP' and n > 21 then
        print('  -> DP omitido por tamaño > 21')
      else
        for run_id = 1, repetitions do
          local context = decorators.new_execution_context()
          local path, cost = algo_func(graph, context)

          local time = context.time_seconds or 0
          local mem = context.memory_peak_kb or 0
          local ops = context.ops_count or 0
          local found = path and 1 or 0
          local real_cost = path and cost or -1

          table.insert(results, {
            filename,
            graph_type,
            n,
            algo_name,
            run_id,
            string.format('%.6f', time),
            real_cost,
            found,
            ops,
            string.format('%.2f', mem),
          })

          print(string.format(
            '  -> %s [Repetición %d]: %s | Costo: %s | Tiempo: %.4fs | Memoria: %.2f KB | Ops: %d',
            algo_name, run_id, found == 1 and 'Éxito' or 'Fallo', real_cost, time,
            mem, ops
          ))
        end
      end
    end
  end

  write_csv(results_filename, headers, results)
  print('\n¡Experimento completado! Resultados guardados en ' .. results_filename)
end

run_experiments()
