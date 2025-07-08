# Hamiltonia

**Hamiltonia** es un entorno experimental para comparar y analizar la eficiencia computacional y la escalabilidad de distintos algoritmos de búsqueda de circuitos Hamiltonianos en grafos.

El proyecto implementa y estudia tres enfoques computacionalmente distintos:
- **Algoritmo Exacto (Backtracking)**
- **Algoritmo Heurístico (Vecino Más Cercano)**
- **Algoritmo de Programación Dinámica**

---

## Objetivo

Evaluar de manera empírica el rendimiento de los algoritmos mencionados al enfrentar instancias crecientes del problema del circuito Hamiltoniano, midiendo:
- Tiempo de ejecución
- Consumo de memoria (RAM)
- Escalabilidad con respecto al tamaño del grafo (número de vértices y aristas)

---

## Metodología

Se generaron grafos de prueba de diferentes tamaños, incluyendo el **Juego Icósico** como caso base (grafo dodecádico con 20 vértices). Para cada instancia se aplicaron los tres algoritmos y se recolectaron métricas de rendimiento.

---

## Resultados esperados

- Comparación de tiempos y memoria según el tamaño del grafo
- Análisis de fortalezas y debilidades de cada enfoque
- Identificación de puntos de cruce (cuando un enfoque supera a otro)
- Recomendaciones de uso según el tamaño y tipo de grafo

---

## Créditos

Desarrollado por David Andrés Ramírez Salomón y Andrés Marcelo López Chaves como parte de un estudio sobre algoritmos de grafos y optimización combinatoria.
Inspirado en el problema del **Juego Icósico** de Sir William Hamilton (1805–1865).

---

## Licencia

Este proyecto está bajo la licencia ISC. Ver [LICENSE](LICENSE) para más información.