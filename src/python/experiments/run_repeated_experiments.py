import csv
import os

from src.python.backtrack.backtrack import hamiltonian_backtracking
from src.python.dynamic.dynamic import hamiltonian_dp
from src.python.heuristic.heuristic import hamiltonian_nearest_neighbor
from src.python.utils.decorators import ExecutionContext
from src.python.utils.load_graph import load_graph_txt


def run_repeated_experiments(base_dir='data',
                             results_filename='results/python/repeated_experiment_results.csv',
                             repetitions=5):
  results_data = []
  headers = [
      'instance_name', 'graph_type', 'size_n', 'algorithm', 'run_id',
      'time_seconds', 'cost', 'path_found', 'ops_count', 'memory_peak_kb'
  ]

  print(
      f'Iniciando experimento con {repetitions} repeticiones por instancia. Resultados en \'{results_filename}\''
  )

  if not os.path.exists(base_dir):
    print(f'Error: Directorio de instancias \'{base_dir}\' no encontrado.')
    return

  for graph_type in os.listdir(base_dir):
    type_path = os.path.join(base_dir, graph_type)
    if os.path.isdir(type_path):
      for filename in os.listdir(type_path):
        if filename.endswith('.txt'):
          filepath = os.path.join(type_path, filename)
          print(f'\n--- Probando instancia: {filepath} ---')

          try:
            graph_matrix = load_graph_txt(filepath)
          except Exception as e:
            print(f'  -> Error al cargar el grafo: {e}')
            continue

          n_size = len(graph_matrix)

          algorithms = {
              'Backtracking': hamiltonian_backtracking,
              'DP': hamiltonian_dp,
              'NearestNeighbor': hamiltonian_nearest_neighbor
          }

          for algo_name, algo_func in algorithms.items():
            if algo_name == 'DP' and n_size > 21:
              continue
            for run_id in range(1, repetitions + 1):
              context = ExecutionContext()
              path, cost = algo_func(graph_matrix, context=context)
              duration = context.time_seconds
              ops_count = context.ops_count
              mem_peak = context.memory_peak_kb
              path_found = 1 if path else 0
              cost_for_csv = cost if path else -1

              results_data.append([
                  filename, graph_type, n_size, algo_name, run_id, duration,
                  cost_for_csv, path_found, ops_count, mem_peak
              ])

              print(
                  f'  -> {algo_name} [Repetición {run_id}]: {'Éxito' if path_found else 'Fallo'}, '
                  f'Costo: {cost_for_csv:.1f}, '
                  f'Tiempo: {duration:.4f}s, '
                  f'Memoria: {mem_peak:.2f} KB, '
                  f'Ops: {ops_count:,}')

  try:
    with open(results_filename, 'w', newline='') as f:
      writer = csv.writer(f)
      writer.writerow(headers)
      writer.writerows(results_data)
    print(
        f'\n¡Experimento repetido completado! Resultados guardados en \'{results_filename}\''
    )
  except IOError:
    print(f'\nError: No se pudo escribir en el archivo \'{results_filename}\'.')


if __name__ == '__main__':
  run_repeated_experiments(base_dir='data',
                           results_filename='results/python/repeated_results.csv',
                           repetitions=5)
