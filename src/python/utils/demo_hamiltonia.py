from matplotlib import pyplot as plt
import networkx as nx
from src.python.backtrack.backtrack import hamiltonian_backtracking
from src.python.dynamic.dynamic import hamiltonian_dp
from src.python.heuristic.heuristic import hamiltonian_nearest_neighbor

INF = float('inf')


def run_experiment_on_graph(G, title='Experimento de Circuito Hamiltoniano'):
  print(f'\n{'='*70}\n{title}\n{'='*70}')

  plt.figure(figsize=(8, 8))
  pos = nx.spring_layout(G, seed=42)
  if G.order() == 20 and G.size() == 30:
    pos = nx.shell_layout(G, [list(range(10)), list(range(10, 20))])
  nx.draw(G,
          pos,
          with_labels=True,
          node_color='skyblue',
          node_size=700,
          edge_color='gray',
          font_size=12,
          font_weight='bold')
  edge_labels = nx.get_edge_attributes(G, 'weight')
  if edge_labels:
    nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)
  plt.title(title, size=15)
  plt.show()

  adj_matrix = nx.to_numpy_array(G, weight='weight', nonedge=INF).tolist()

  def process_and_print(algorithm_func):
    path, cost = algorithm_func(adj_matrix)
    if path:
      print(f'  -> Ruta encontrada: {' -> '.join(map(str, path))}')
      print(f'  -> Costo del circuito: {cost if cost != INF else 'N/A'}')
    else:
      print('  -> No se encontró un circuito hamiltoniano en el grafo.')
    print('-' * 40)

  # --- Ejecutar cada algoritmo ---
  process_and_print(hamiltonian_backtracking)
  if G.order() <= 20:
    process_and_print(hamiltonian_dp)
  else:
    print('--- Programación Dinámica omitida por tamaño de grafo > 20 ---\n')
  process_and_print(hamiltonian_nearest_neighbor)


if __name__ == '__main__':

  G1 = nx.Graph()
  G1.add_edge(0, 1, weight=10)
  G1.add_edge(0, 2, weight=15)
  G1.add_edge(0, 3, weight=20)
  G1.add_edge(1, 2, weight=35)
  G1.add_edge(1, 3, weight=25)
  G1.add_edge(2, 3, weight=30)
  run_experiment_on_graph(G1, 'Prueba 1: Grafo completo con pesos (K4)')

  G2 = nx.Graph()
  G2.add_edges_from([(0, 1), (0, 2), (1, 3), (2, 3)])
  for u, v in G2.edges():
    G2.add_edge(u, v, weight=1)
  run_experiment_on_graph(G2, 'Prueba 2: Grafo sin circuito Hamiltoniano')

  G3 = nx.dodecahedral_graph()
  for u, v in G3.edges():
    G3.add_edge(u, v, weight=1)
  run_experiment_on_graph(
      G3, 'Prueba 3: Juego Icosiano (Grafo del Dodecaedro, N=20)')
