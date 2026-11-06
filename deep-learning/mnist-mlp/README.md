# Clasificación de dígitos MNIST con perceptrones multicapa

Estudio experimental del efecto de cada decisión de diseño en una red densa (MLP) para
clasificar los 70.000 dígitos manuscritos de **MNIST**. El modelo final alcanza un
**98,48 % de accuracy en test**.

**Stack:** TensorFlow / Keras · NumPy · pandas · matplotlib

## Experimentos

| Factor | Comparación | Mejor opción (val. accuracy) |
|---|---|---|
| Neuronas ocultas | 216 / 512 / 1024 | 1024 (0.979), con mejoras decrecientes |
| Épocas | 15 frente a 30 | Más épocas no mejoran la validación (sobreajuste) |
| Early stopping | Callback de Keras | Detiene el entrenamiento en el punto adecuado |
| Activación (red profunda) | Sigmoid frente a ReLU | **ReLU** (0.978 frente a 0.968) |
| Inicialización | Ceros / normal / Glorot | **Glorot** (0.978); con ceros no aprende (0.106) |
| Optimizador | SGD / RMSprop / Adam | **Adam** (0.979) |

**Modelo final:** arquitectura `512 → 256 → 128 → 10` con ReLU, inicialización He
(adecuada para ReLU), Adam, Batch Normalization, Dropout (0,2) y regularización L2.
Obtiene un 98,44 % en validación y un **98,48 % en test**.

También se demuestra empíricamente por qué la capa de salida debe tener 10 neuronas con
`softmax` y `categorical_crossentropy`: un modelo con 5 salidas falla por incompatibilidad
de dimensiones con las etiquetas *one-hot*.

## Ejecución

```bash
pip install tensorflow numpy pandas matplotlib jupyter
jupyter notebook mnist_mlp.ipynb
```

El dataset se descarga automáticamente con `tf.keras.datasets.mnist`.
