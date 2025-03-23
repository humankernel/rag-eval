#set document(
  author: "Joaquin Rivas Sanchez",
  description: [],
  keywords: (),
  title: [Enhancing Cuban Research: RAG Benchmark],
)
#set par(justify: true)
#set page(
  margin: (top: 100pt),
  header: [
    #image("logo.png", width: 55%)
  ],
)
#show heading.where(level: 2): it => text(
  size: 14pt,
  it.body,
)



#set text(size: 12pt, font: "Times New Roman")
= Enhancing Cuban Research: RAG Benchmark

#set text(size: 11pt, font: "Times New Roman", style: "italic")
= Mejorando la Investigación Cubana: Benchmark RAG


#v(25pt)

#set text(size: 11pt,style: "normal")
*Joaquin Rivas Sanchez* #super[#text[1\*]], *Naylin Brizuela Capote* #super[1], *Angel Alberto Vazquez Sánchez* #super[1]

#super[1] Universidad de las Ciencias Informáticas. Km 2 ½ carretera a San Antonio de los Baños, Reparto Torrens,
La Lisa, La Habana.

#super[\*] Autor por correspondencia: #link("joaquiners@uci.estudiantes.cu")


#line(length: 100%)
#set text(size: 11pt)
#set par(leading: 1.0em)

*Abstract*

This paper presents the development of a GUI tool for generating synthetic datasets, along with the creation of CRIQAD-CU, an open dataset designed to evaluate Retrieval-Augmented Generation (RAG) chatbots in the Cuban research context. The tool enables the simulation of real investigative query scenarios, facilitating the construction of representative datasets that include Cuban academic documents, contextualized research questions, and generated responses.

Additionally, this work examines commonly used evaluation metrics for RAG-based systems, with a focus on RAGAS and complementary metrics such as citation analysis and information retrieval precision. The combination of the GUI tool and dataset provides a structured framework for the automated evaluation of these systems, supporting performance validation and early error detection. This study contributes to the development of robust methodologies for chatbot assessment in research environments, ensuring these models are effective and aligned with the needs of the scientific Cuban community.

*Keywords:* Information Retrieval Evaluation, Synthetic Dataset Generation, RAG, Research-oriented AI Systems, NLP

#line(length: 100%)


== Introduction

// - [x] introducción del tema 
// - [x] objetivos trazados 
// - [x] exponer brevemente los trabajos más relevantes
// - [x] destacar las contribuciones de otros autores al tema objeto de estudio
// - [x] justificar las razones por las que se realiza la investigación

In today's world, artificial intelligence is reshaping how information is accessed and tasks requiring precision and speed are performed @russell2021. Among AI-driven technologies, large language models (LLMs) have revolutionized natural language processing, enabling applications ranging from automated content generation to interactive assistants @NEURIPS2020_1457c0d6. However, despite their remarkable capabilities, LLMs exhibit inherent limitations, including hallucinations—generating plausible but incorrect information—and a reliance on static training data that may not reflect the latest knowledge @xu2025hallucinationinevitableinnatelimitation.

To mitigate these issues, Retrieval-Augmented Generation (RAG) has emerged as a promising approach, integrating information retrieval mechanisms with generative models to ground responses in external documents, enhancing factual accuracy and contextual relevance @lewis2021retrievalaugmentedgenerationknowledgeintensivenlp. This is particularly relevant in research-oriented settings, where access to high-quality academic material and reliable information is critical. By leveraging RAG-based systems, researchers can improve their workflow efficiency and broaden their exposure to national and international scholarly works, fostering greater academic exploration and collaboration @creswell2022research. However, for these systems to be effective, they must be optimized for their specific linguistic and domain contexts, ensuring that retrieved information is relevant, comprehensible, and useful for the target users

This study focuses on the *design of an evaluation framework* tailored to assess the performance of a RAG-based chatbot for the Cuban research community. The two main contributions of this work are:

1. The creation of CRIQAD-CU, an open dataset comprising academic documents, research-oriented questions, and generated responses, curated to reflect real-world information needs in Cuban academia.
2. The development of a Graphical User Interface (GUI) tool for generating synthetic #footnote[Synthetic datasets are artificially created datasets designed to mimic real-world data, allowing researchers to test and evaluate systems faster] datasets that simulate research queries, enabling an automated and scalable evaluation process.

By establishing a structured benchmarking approach, this study aims to ensure that the chatbot not only retrieves relevant and high-quality academic content but also generates responses that align with factual correctness and contextual adequacy
 
The evaluation of RAG-based systems presents unique challenges, as traditional NLP assessment metrics such as BLEU and ROUGE, which focus primarily on surface-level text similarity, fail to account for the retrieval component @BLEU @lin-2004-rouge. To address these gaps, recent benchmarks like RAGBench @RAGBench have introduced large-scale datasets and evaluation methodologies that assess both retrieval and generation quality. Additionally, RAGAS @RAGAS provides a set of tailored metrics that offer a more comprehensive evaluation framework, including:

1. *Faithfulness*: Measures the consistency between retrieved documents and the generated response.
2. *Answer Relevancy*: Evaluates whether the response directly addresses the posed question.
3. *Context Relevance*: Assess how accurately the retrieved information contributes to the final response.

These contributions provide valuable foundations for this work, as they highlight the importance of evaluation methodologies specifically designed for RAG-based chatbots.

A well-calibrated evaluation framework ensures that these systems fulfill their intended role in enhancing researcher productivity and fostering new opportunities for scientific exploration within the country.

This study advances the field of AI-driven academic assistance by introducing a context-specific benchmark and dataset tailored to Cuban researchers. By combining automated dataset generation with RAG-specialized evaluation metrics, this work provides a robust methodology for assessing and improving RAG-based chatbots in specialized domains. 

By ensuring early error detection and validation of chatbot performance, this benchmark contributes not only to the optimization of AI-driven research tools but also to the broader landscape of AI evaluation methodologies in resource-constrained settings


== Computational Methodology

// - [ ] se explica cómo se hizo la investigación. 
// - [ ] Se describe el diseño de la misma 
// - [ ] se explica cómo se llevó a la práctica, 
// - [ ] justificando la elección de métodos y técnicas de forma tal que un lector pueda repetir el estudio.


== Results and Discussion

// - [ ] Los resultados obtenidos se exponen después de explicar las técnicas seleccionadas y descritas en la sección anterior. 

// - [ ] Se incluyen las tablas y figuras que expresan de forma clara los resultados del estudio realizado por el investigador sin que repitan lo indicado en el texto. 

// - [ ] Más que la solución técnica expuesta se espera encontrar aquellos elementos que hacen que lo realizado constituya una novedad o una mejora en su campo de acción y su superioridad con respecto a soluciones similares. 


// - [ ] En la discusión se presenta el análisis de los resultados obtenidos que deben corresponder a los objetivos planteados en el artículo.


== Conclusions





#bibliography("refs.bib", title: [References], style: "american-psychological-association")