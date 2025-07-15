import functools
import time
import tracemalloc


class ExecutionContext:
  """Un objeto mutable para pasar y recopilar resultados de los decoradores."""

  def __init__(self):
    self.time_seconds = 0.0
    self.memory_peak_kb = 0.0
    self.ops_count = 0


# Decorador de tiempo
def time_it(func):

  @functools.wraps(func)
  def wrapper(graph, context, **kwargs):  # Acepta 'context'
    start_time = time.perf_counter()
    result = func(graph, context=context, **kwargs)
    end_time = time.perf_counter()
    context.time_seconds = end_time - start_time  # Modifica el objeto
    return result

  return wrapper


# Decoradores de conteo específicos
def count_ops(func):

  @functools.wraps(func)
  def wrapper(graph, context, **kwargs):  # Acepta 'context'
    counter = [0]
    kwargs['counter'] = counter  # La lógica interna del algo sigue usando esto
    result = func(graph, context=context, **kwargs)
    context.ops_count = counter[0]  # Modifica el objeto
    return result

  return wrapper


# Decorador de memoria RAM
def measure_memory(func):

  @functools.wraps(func)
  def wrapper(graph, context, **kwargs):  # Acepta 'context'
    tracemalloc.start()
    result = func(graph, context=context, **kwargs)
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    context.memory_peak_kb = peak / 1024  # Modifica el objeto
    return result

  return wrapper
