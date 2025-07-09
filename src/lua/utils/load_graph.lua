local M = {}

local INF = math.huge

function M.load_graph_txt(filepath)
  local matrix = {}
  local file = io.open(filepath, 'r')
  if not file then
    error('No se pudo abrir el archivo: ' .. filepath)
  end

  for line in file:lines() do
    local row = {}
    for val in string.gmatch(line, '[^%s]+') do
      if val == 'inf' or val == 'INF' or val == 'Infinity' then
        table.insert(row, INF)
      else
        table.insert(row, tonumber(val))
      end
    end
    table.insert(matrix, row)
  end

  file:close()
  return matrix
end


return M
