local decorators = {}

-- Contexto de ejecución similar al de Python
function decorators.new_execution_context()
  return {
    time_seconds = 0.0,
    memory_peak_kb = 0.0,
    ops_count = 0,
  }
end


-- Decorador de tiempo
function decorators.time_it(func)
  return function(matrix, context)
    local start_time = os.clock()
    local result = {func(matrix, context)}
    local end_time = os.clock()
    local duration = end_time - start_time

    if context then
      context.time_seconds = duration
    end

    return table.unpack(result)
  end
end


-- Decorador genérico de conteo de operaciones
function decorators.count_ops(func)
  return function(matrix, context)
    context = context or {}
    context._internal_counter = {0}
    local result = {func(matrix, context)}
    context.ops_count = context._internal_counter[1]
    return table.unpack(result)
  end
end


-- Decorador de memoria RAM
function decorators.measure_memory(func)
  return function(matrix, context)
    collectgarbage('collect')
    local before = collectgarbage('count') -- KB
    collectgarbage('stop')                 -- opcional

    local result = {func(matrix, context)}

    collectgarbage('restart') -- solo si se usó el "stop" del GC
    collectgarbage('collect')
    local after = collectgarbage('count')
    local peak = math.max(before, after)

    if context then
      context.memory_peak_kb = peak
    end

    return table.unpack(result)
  end
end


return {
  time_it = decorators.time_it,
  count_ops = decorators.count_ops,
  measure_memory = decorators.measure_memory,
  new_execution_context = decorators.new_execution_context,
}
