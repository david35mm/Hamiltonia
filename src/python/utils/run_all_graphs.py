import os

from src.python.backtrack.backtrack import hamiltonian_backtracking
from src.python.dynamic.dynamic import hamiltonian_dp
from src.python.heuristic.heuristic import hamiltonian_nearest_neighbor
from src.python.utils.decorators import ExecutionContext
from src.python.utils.load_graph import load_graph_txt

INF = float('inf')


def run_algorithms_on_file(filepath):
  print('\n' + '=' * 70)
  print(f'Archivo: {filepath}')
  print('=' * 70)

  try:
    graph = load_graph_txt(filepath)
  except Exception as e:
    print(f'  -> Error al cargar el grafo: {e}')
    return

  def run_and_print(algorithm_func, label):
    print(f'\n[{label}]')
    context = ExecutionContext()
    path, cost = algorithm_func(graph, context=context)
    print(f'--- Ejecutando función: {algorithm_func.__name__} ---')
    if path:
      print(f'  -> Ruta encontrada: {' -> '.join(map(str, path))}')
      if cost == INF:
        print('  -> Costo del circuito: N/A')
      else:
        print(f'  -> Costo del circuito: {cost:.2f}')
    else:
      print('  -> No se encontró un circuito hamiltoniano.')

    # Mostrar métricas del contexto
    print(f'  -> Tiempo: {context.time_seconds:.4f}s')
    print(f'  -> Memoria máxima: {context.memory_peak_kb:.2f} KB')
    print(f'  -> Operaciones: {context.ops_count:,}')
    print('-' * 40)

  run_and_print(hamiltonian_backtracking, 'Backtracking')
  if len(graph) <= 20:
    run_and_print(hamiltonian_dp, 'Programación Dinámica')
  else:
    print('  -> Programación Dinámica omitida por tamaño del grafo > 20')
  run_and_print(hamiltonian_nearest_neighbor, 'Heurística - Vecino Más Cercano')


def run_on_all_txt_files(root_folder='data'):
  for subdir, _, files in os.walk(root_folder):
    for file in files:
      if file.endswith('.txt'):
        filepath = os.path.join(subdir, file)
        run_algorithms_on_file(filepath)


if __name__ == '__main__':
  run_on_all_txt_files('data')
