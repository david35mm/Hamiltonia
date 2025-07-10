def load_graph_txt(filepath, inf_value=float('inf')):
  with open(filepath, 'r') as file:
    matrix = []
    for line in file:
      row = []
      for val in line.strip().split():
        if val.lower() in {'inf', 'infinity'}:
          row.append(inf_value)
        else:
          row.append(float(val))
      matrix.append(row)
  return matrix


# Para ejecutar el archivo directamente desde la terminal (OPCIONAL)
if __name__ == '__main__':
  from pprint import pprint
  import sys

  if len(sys.argv) < 2:
    print('Uso: python load_graph.py <ruta_al_archivo.txt>')
    sys.exit(1)

  path = sys.argv[1]
  graph = load_graph_txt(path)
  pprint(graph)
