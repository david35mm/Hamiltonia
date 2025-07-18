#!/bin/sh

mkdir -p results/python
mkdir -p results/lua

# Timestamp ISO para identificar la ejecución
TIMESTAMP=$(date --iso-8601=seconds)

TIME_LOG_PY="results/python/time-$TIMESTAMP.log"
TIME_LOG_LUA="results/lua/time-$TIMESTAMP.log"
TIME_LOG_TOTAL="results/total_time-$TIMESTAMP.log"

# Ejecutar Python y Lua en paralelo, cada uno con medición de tiempo
# Redirección de stdout y stderr a /dev/null para silencio (opcional)

(
  /usr/bin/time -f "Tiempo real: %E\nTiempo usuario: %U\nTiempo sistema: %S" \
    -o "$TIME_LOG_PY" \
    python -m src.python.experiments.run_repeated_experiments > /dev/null 2>&1
) &

(
  /usr/bin/time -f "Tiempo real: %E\nTiempo usuario: %U\nTiempo sistema: %S" \
    -o "$TIME_LOG_LUA" \
    lua src/lua/experiments/run_repeated_experiments.lua > /dev/null 2>&1
) &

# Medir tiempo total conjunto (usando un sub-shell que espera)
(
  /usr/bin/time -f "Tiempo total combinado: %E\nUsuario: %U\nSistema: %S" \
    -o "$TIME_LOG_TOTAL" \
    sh -c "wait"
)
