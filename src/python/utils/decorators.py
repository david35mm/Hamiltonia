import functools
import time

INF = float('inf')


# Decorador de tiempo
def time_it(func):

  @functools.wraps(func)
  def wrapper(*args, **kwargs):
    print(f"--- Ejecutando {func.__name__} ---")
    start_time = time.time()
    result = func(*args, **kwargs)
    end_time = time.time()
    duration = end_time - start_time
    print(f"  -> Tiempo de ejecución: {duration:.6f} segundos.")
    return result

  return wrapper


# Decoradores de conteo específicos
def count_backtracking_ops(func):

  @functools.wraps(func)
  def wrapper(*args, **kwargs):
    counter = [0]
    kwargs['counter'] = counter
    result = func(*args, **kwargs)
    print(f"  -> Intentos de extensión de camino: {counter[0]:,}")
    return result

  return wrapper


def count_dp_ops(func):

  @functools.wraps(func)
  def wrapper(*args, **kwargs):
    counter = [0]
    kwargs['counter'] = counter
    result = func(*args, **kwargs)
    print(f"  -> Actualizaciones de la tabla DP: {counter[0]:,}")
    return result

  return wrapper


def count_nn_ops(func):

  @functools.wraps(func)
  def wrapper(*args, **kwargs):
    counter = [0]
    kwargs['counter'] = counter
    result = func(*args, **kwargs)
    print(f"  -> Comparaciones de distancia: {counter[0]:,}")
    return result

  return wrapper
