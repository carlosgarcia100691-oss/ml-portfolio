# Clasificación de mensajes de odio con aprendizaje supervisado

Flujo completo de clasificación binaria (**odio / no odio**) sobre 10.000 comentarios
representados mediante 20 rasgos numéricos extraídos del texto: EDA, control de
duplicados y *data leakage*, comparación de modelos frente a un *baseline* y selección
razonada del modelo final.

**Stack:** pandas · scikit-learn (Pipeline, LogisticRegression, LinearSVC, RandomForest)

## Puntos clave

- **Calidad de datos:** se eliminan 539 filas duplicadas antes de particionar, para que no
  aparezcan copias de un mismo mensaje en entrenamiento y test (evaluación demasiado
  optimista).
- **Partición estratificada** 80/20 y escalado dentro de un `Pipeline` (sin fuga de
  información del conjunto de test).
- **Baseline** (`DummyClassifier`) como referencia mínima.

## Resultados (test, 1.893 mensajes)

| Modelo | Accuracy | F1 macro | Recall odio | F1 odio |
|---|---:|---:|---:|---:|
| Dummy (clase mayoritaria) | 0.525 | 0.344 | 0.000 | 0.000 |
| Regresión logística | 0.970 | 0.970 | 0.993 | 0.970 |
| SVM lineal | 0.971 | 0.971 | 0.994 | 0.970 |
| **Random Forest** | **0.977** | **0.977** | 0.982 | **0.976** |

Se selecciona **Random Forest** por su mejor F1 macro. Los modelos lineales obtienen un
recall algo mayor en la clase odio, lo que podría ser preferible si el coste de no detectar
un mensaje de odio fuese mayor que el de una falsa alarma. Las variables más influyentes
según la importancia del Random Forest son `B_t`, `B`, `Valor_6` y `Valor_5`.

## Datos

El notebook espera `data/out.csv`: comentarios preprocesados con su etiqueta y rasgos
numéricos ya calculados. El dataset no se incluye en el repositorio; el notebook se publica
con todas las salidas.
