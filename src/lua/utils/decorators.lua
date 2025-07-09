local decorators = {}

-- Decorador de tiempo
function decorators.time_it(func)
  return function(...)
    print(string.format('--- Ejecutando %s ---', tostring(func)))
    local start_time = os.clock()
    local result = {func(...)}
    local end_time = os.clock()
    local duration = end_time - start_time
    print(string.format('  -> Tiempo de ejecución: %.6f segundos.', duration))
    return table.unpack(result)
  end
end


-- Decoradores de conteo específicos
function decorators.count_backtracking_ops(func)
  return function(matrix, counter)
    counter = counter or {0}
    local result = {func(matrix, counter)}
    print(string.format('  -> Intentos de extensión de camino: %d', counter[1]))
    return table.unpack(result)
  end
end


function decorators.count_dp_ops(func)
  return function(matrix, counter)
    counter = counter or {0}
    local result = {func(matrix, counter)}
    print(string.format('  -> Actualizaciones de la tabla DP: %d', counter[1]))
    return table.unpack(result)
  end
end


function decorators.count_nn_ops(func)
  return function(matrix, counter)
    counter = counter or {0}
    local result = {func(matrix, counter)}
    print(string.format('  -> Comparaciones de distancia: %d', counter[1]))
    return table.unpack(result)
  end
end


return decorators
