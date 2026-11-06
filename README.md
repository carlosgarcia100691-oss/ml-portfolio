# Machine Learning Portfolio

Colección de proyectos de **machine learning, deep learning, visión por computador,
ingeniería de datos y planificación automática**. Cada carpeta es un proyecto autónomo con
su propio README: objetivo, metodología, resultados y conclusiones.

Proyectos más extensos en repositorios propios:
[Clasificación CIFAR-10 con CNN](https://github.com/carlosgarcia100691-oss/cifar10-cnn-classification) ·
[Intensidad del discurso de odio con BiGRU](https://github.com/carlosgarcia100691-oss/hate-speech-intensity-bigru) ·
[Detección de fraude con anomalías](https://github.com/carlosgarcia100691-oss/ecommerce-fraud-anomaly-detection) ·
[Segmentación de clientes RFM](https://github.com/carlosgarcia100691-oss/customer-segmentation-rfm)

## Proyectos

### Deep learning

| Proyecto | Descripción | Resultado |
|---|---|---|
| [MNIST con perceptrones multicapa](deep-learning/mnist-mlp) | Estudio del efecto de neuronas, épocas, activaciones, inicialización, optimizadores y regularización | **98,5 %** de accuracy en test |

### Procesamiento del lenguaje natural

| Proyecto | Descripción | Resultado |
|---|---|---|
| [Clasificación de mensajes de odio](nlp/hate-speech-classification) | Pipeline supervisado con control de duplicados, *baseline* y comparación de modelos | F1 macro **0,977** (Random Forest) |

### Aprendizaje no supervisado

| Proyecto | Descripción | Resultado |
|---|---|---|
| [PCA, t-SNE y LDA](unsupervised/dimensionality-reduction-pca-tsne-lda) | Proyección 2D de rasgos de texto y modelado de temas | 2 componentes PCA conservan el **71,9 %** de la varianza |

### Visión por computador

| Proyecto | Descripción | Técnicas |
|---|---|---|
| [Realce de imágenes con baja iluminación](computer-vision/low-light-enhancement) | Recuperación de detalle en escenas nocturnas reales | CLAHE, gamma, high-boost, NLM, Gray-World |
| [Filtros espaciales y morfología](computer-vision/spatial-morphological-filters) | 10 escenarios: PCB, satélite, biomedicina, planetología | Canny, LoG, top-hat, apertura/cierre |
| [Deforestación en la Amazonia](computer-vision/deforestation-segmentation) | Segmentación de imágenes Landsat 2000–2019 y cálculo del área en km² | ExR/ExG, HSV/Lab, Otsu, morfología |

### Ingeniería de datos

| Proyecto | Descripción | Tecnologías |
|---|---|---|
| [Análisis de ventas con BigQuery](data-engineering/bigquery-retail-analytics) | 421.570 registros: calidad de datos, vistas y consultas de negocio | GCS, BigQuery, SQL |

### Planificación automática

| Proyecto | Descripción | Tecnologías |
|---|---|---|
| [Rover marciano en PDDL](ai-planning/mars-rover-pddl) | Misiones con batería, varios rovers y un dominio ampliado con tracción y remolque | PDDL, LAMA / Fast Downward |

## Ejecución

Los notebooks se publican con todas sus salidas, así que pueden consultarse directamente en
GitHub. Para ejecutarlos:

```bash
pip install -r requirements.txt
jupyter notebook
```
