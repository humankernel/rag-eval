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

This paper presents the development of a Graphical User Interface (GUI) tool for generating synthetic datasets, along with the creation of CRIQAD-CU, an open dataset designed to evaluate Retrieval-Augmented Generation (RAG) chatbots in the Cuban research context. The tool enables the simulation of real investigative query scenarios, facilitating the construction of representative datasets that include Cuban academic documents, contextualized research questions, and generated responses.

Additionally, this work examines commonly used evaluation metrics for RAG-based systems, with a focus on RAGAS and complementary metrics on information retrieval precision. The combination of the GUI tool and dataset provides a structured framework for the automated evaluation of these systems, supporting performance validation and early error detection. This study contributes to the development of robust methodologies for chatbot assessment in research environments, ensuring these models are effective and aligned with the needs of the scientific Cuban community.

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

1. The creation of CRIQAD-CU, an open dataset comprising academic documents and Wikipedia articles, research-oriented questions, and generated responses, curated to reflect real-world information needs in Cuban academia.
2. The development of a Graphical User Interface (GUI) tool for generating synthetic #footnote[Synthetic datasets are artificially created datasets designed to mimic real-world data, allowing researchers to test and evaluate systems faster] datasets that simulate research queries, enabling an automated and scalable evaluation process.

By establishing a structured benchmarking approach, this study aims to ensure that the chatbot not only retrieves relevant and high-quality academic content but also generates responses that align with factual correctness and contextual adequacy
 
The evaluation of RAG-based systems presents unique challenges, as traditional NLP assessment metrics such as BLEU and ROUGE, which focus primarily on surface-level text similarity, fail to account for the retrieval component @BLEU @lin-2004-rouge. To address these gaps, recent benchmarks like RAGBench @RAGBench have introduced large-scale datasets and evaluation methodologies that assess both retrieval and generation quality. Additionally, RAGAS @RAGAS provides a set of tailored metrics that offer a more comprehensive evaluation framework, including:

1. *Faithfulness*: Measures the consistency between retrieved documents and the generated response.
2. *Answer Relevancy*: Evaluates whether the response directly addresses the posed question.
3. *Context Relevance*: Assess how accurately the retrieved information contributes to the final response.

These contributions provide valuable foundations for this work, as they highlight the importance of evaluation methodologies specifically designed for RAG-based chatbots.

A well-calibrated evaluation framework ensures that these systems fulfill their intended role in enhancing researcher productivity and fostering new opportunities for scientific exploration within the country.

By ensuring early error detection and validation of chatbot performance, this benchmark contributes not only to the optimization of AI-driven research tools but also to the broader landscape of AI evaluation methodologies in resource-constrained settings


== Computational Methodology

// - [ ] se explica cómo se hizo la investigación. 
// - [ ] Se describe el diseño de la misma 
// - [ ] se explica cómo se llevó a la práctica, 
// - [ ] justificando la elección de métodos y técnicas de forma tal que un lector pueda repetir el estudio.

This study employed a systematic approach to develop both the synthetic dataset generator and the CRIQAD-CU dataset, along with and overview of the most common evaluation metrics for RAG-based systems. The methodology is designed to be replicable by future researchers interested in testing and benchmarking these systems.

The process began with the collection of academic documents from multiple sources—primarily Wikipedia (in both English and Spanish) and SciELO for Cuban articles. Collected texts were preprocessed to ensure consistency; this involved normalizing the text by removing unnecessary whitespace and non-UTF-8 characters, as well as tokenization and cleaning.

An interactive web interface was developed to automate the process, #link("https://gradio.com")[Gradio] was chosen for its rapid prototyping capabilities @Gradio. This interface allows users to:
- Select the source (e.g. Wikipedia)
- specify the number of question-answer (QA) pairs
- Configure generation parameters (e.g., temperature, maximum tokens)
- Choose the specific passages that provide the context for QA generation. 
- Once the synthetic QA pairs are generated, they can be downloaded in _json_ format (see @dataset-structure).

QA pair generation is driven by the locally integrated #link("https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct")[_Qwen2.5-1.5B-Instruct-Q8_0_] model. A notable aspect of this system is its multilingual and domain-comparative capability, as it processes documents from Wikipedia and SciELO — allowing a later evaluation of language nuances on both retrieval and generation performance.

#figure(
  table(
    columns: (1fr, 5fr),
    stroke: 0.2pt,
    [*File*], [*Structure Example*],
    ["doc.json"], 
[```json 
[{
  "title": "Linear algebra",
  "source": "https://en.wikipedia.org/wiki/Linear_algebra",
  "language": "en",
  "chunks": [
    {
      "heading": "History",
      "level": 1,
      "content": "The procedure (using counting rods) for ..."
    }, 
    {...}
  ]
}] 
```],
    ["qa.json"], 
[```json 
[{
  "id": 3,
  "type": "factual",
  "language": "en",
  "article_title": "Quantum mechanics",
  "chunks": [7],
  "question": "What is the derivative of velocity with respect to time?",
  "answer": "The derivative of velocity with respect to time is acceleration. Acceleration represents the change in velocity over time."
}, ...]
```]
  ),
  caption: [Dataset Structure]
)<dataset-structure>

=== Evaluation Metrics

To holistically assess the performance of RAG-based systems, the following metrics are used.

*Retrieval Metrics*:

The goal of the Retrieval Metrics is to evaluate how effectively the system identifies and ranks relevant documents from a large corpus. it is crucial that the underlying retrieval component fetches high-quality, pertinent documents that serve as a basis for generating accurate responses @Yu_2025.

- *Precision\@k*: Used to measure the quality of the top k retrieved documents by calculating the fraction that are relevant. It helps evaluate the system's ability to prioritize relevant documents in the initial ranks @Yu_2025. 

$ "Precision@k" = "# of relevant documents in top k" / k $

// ---------

- *Recall\@k*: Quantifies how well the system retrieves the full set of relevant documents by calculating the proportion of relevant documents found among the top k results. This metric ensures that the system is comprehensive in its retrieval @Yu_2025.

$ "Recall@k" = "# of relevant documents in top k" / "# of all relevant documents" $

// ---------

- *Mean Reciprocal Rank (MRR)*: Used to evaluate how quickly a system can present a relevant document to the user. It calculates the average reciprocal rank of the first relevant document across all queries, emphasizing systems that show relevant results earlier in the ranking @Yu_2025.

$ "MRR" = 1 / N sum_(i=1)^N 1 / "rank"_i $

where $"rank"_i$ is the rank position of the first relevant document for query _i_, and _N_ is the total number of queries.

// ---------

- *Normalized Discounted Cumulative Gain (NDCG)*: Evaluates ranking quality by considering the position of relevant documents. It assigns higher importance to documents ranked higher by applying a discount factor. This metric is particularly useful when relevance is graded (i.e., different degrees of relevance) @Yu_2025.

First, compute the Discounted Cumulative Gain (DCG\@k):

$ "DCG@k" = sum_(i=1)^k (2^("rel"_i) - 1) / (log_2(i+1)) $

Then, normalize with the Ideal DCG (IDCG\@k):

$ "NDCG@k" = "DCG@k" / "IDCG@k" $

Here, $"rel"_i$ is the graded relevance of the document at rank _i_, and IDCG\@k is the maximum possible DCG for an ideal ranking of the documents.

// ---------

- *Mean Average Precision (MAP)*: Provides a single summary measure that combines precision across all relevant documents for each query. It calculates the average precision for each query and then averages these scores over all queries, reflecting both the accuracy and completeness of the retrieval @Yu_2025.

For a single query _q_, the Average Precision (AP) is computed as:

$ "AP"(q) = (sum_(i=1)^n P(i) * "rel"(i) ) / "number of relevant documents for q" $

where $P(i)$ is the precision at rank _i_, and $"rel"(i)$ is an indicator function that equals 1 if the document at rank _i_ is relevant (0 otherwise).

Then, Mean Average Precision over _N_ queries is given by:

$ "MAP" = 1 / N sum_(q=1)^N "AP"(q) $


*Generation Metrics*:

The Generation Metrics are designed to assess the quality of the responses produced by the system after integrating the retrieved documents. These metrics ensure that the generated answers are not only factually correct and coherent but also directly address the user's query @Yu_2025. Each metric is defined as follows:

- *Faithfulness*: Evaluates the consistency between the retrieved documents and the generated answers. A response is considered faithful if it accurately reflects the information present in the supporting documents @RAGAS. In other words, the generated answer should not introduce external or erroneous details that are not substantiated by the retrieved content.

- *Answer Relevancy*: Measures how directly the generated answer addresses the posed question. Beyond mere factual correctness, the answer must be contextually appropriate—ensuring that the response focuses on the key aspects of the query and provides a concise yet comprehensive answer @RAGAS.

- *Context Relevance*: Assesses the degree to which the retrieved passages contribute to forming a coherent and contextually accurate response @RAGAS. It verifies that the supporting information from the documents is effectively incorporated into the generated answer, lending both depth and reliability to the final output.

To apply these generation metrics, an approach often referred to as the "LLM as a Judge" is used  @LLM-as-Judge. In this approach, a large language model (LLM) is employed to evaluate the generated responses based on the above criteria.

=== Practical Implementation and Reproducibility

The practical implementation was conducted using the following technologies and environment

*Software*: 
Python v3.12.1, Gradio v5.23.0, vLLM v0.8.1, Pydantic v2.10.6.

*Model Parameters*:
Context Window 8196 tokens,
Temperature 0.25,
Max Tokens 100,
Top P 0.95,
Frequency Penalty 0.5,
Presence Penalty 1.2

*Hardware*:
The relevant constraint to run the system is the LLM model, To calculate the VRAM required for running `Qwen2.5-1.5B-Instruct_Q8` (an 8-bit quantized model), the following formula is used:
 
$ "M" = (P * 4B) / (32 \/ Q) * 1.2 = (1.5 * 4B) / (32 \/ 8) * 1.2 = 1.80 $ 

#figure(
table(
  columns: (1fr, 4fr),
  stroke: 0.2pt,
  [*Symbol*], [*Description*],
  [$M$], [GPU memory expressed in Gigabyte],
  [$P$], [The amount of parameters in the model],
  [$4B$], [4 bytes, expressing the bytes used for each parameter],
  [$32$], [There are 32 bits in 4 bytes],
  [$Q$], [The amount of bits that should be used for loading the model. 16, 8, 4 bits.],
  [$1.2$], [Represents a 20% overhead of loading additional things in GPU memory.],
),
caption: [GPU memory requirement]
)

All scripts, configurations, and datasets are documented and publicly hosted on #link("https://github.com/humankernel/rag-eval")[Github (rag-eval)] and the Chatbot evaluated on #link("https://github.com/humankernel/rag")[Github (rag)], ensuring full reproducibility and facilitating further research or extension of this work to other languages or domains.

== Results and Discussion

// - [ ] Los resultados obtenidos se exponen después de explicar las técnicas seleccionadas y descritas en la sección anterior. 

// - [ ] Se incluyen las tablas y figuras que expresan de forma clara los resultados del estudio realizado por el investigador sin que repitan lo indicado en el texto. 

// - [ ] Más que la solución técnica expuesta se espera encontrar aquellos elementos que hacen que lo realizado constituya una novedad o una mejora en su campo de acción y su superioridad con respecto a soluciones similares. 

// - [ ] En la discusión se presenta el análisis de los resultados obtenidos que deben corresponder a los objetivos planteados en el artículo.

The primary outcome of this work is the successful creation of an application and a corresponding synthetic dataset, specifically designed for evaluating RAG-based chatbots. A screenshot of the application's user interface (see @ui) demonstrates its intuitive design and ease of use. Concurrently, the CRIQAD-CU dataset has been assembled and curated by aggregating content from multilingual sources, providing a robust foundation for subsequent chatbot evaluation.

// When the dataset and evaluation metrics were applied to a #link("https://github.com/humankernel/rag")[RAG chatbot] (see @results), the tests revealed several potential areas for improvement. // TODO!

// The evaluation indicated that while the chatbot generates contextually relevant and coherent responses to research-oriented queries, there remain opportunities to enhance its performance. For example, discrepancies in retrieval effectiveness—as measured by Precision\@k, Recall\@k, MRR, NDCG, and MAP—suggest that fine-tuning the retrieval mechanism could lead to better selection and ranking of supporting documents. Similarly, the generation quality, assessed through metrics such as faithfulness, answer relevancy, and context relevance (using the “LLM as a Judge” approach), highlighted aspects where the responses could more accurately reflect the supporting evidence.


#figure(
  image("ui.png"),
  caption: [Syntethic Dataset Generator]
)<ui>

// Discusion

The application of the dataset and evaluation metrics has revealed several potential directions for further investigation and development. Although the current setup provides a solid foundation, preliminary tests have highlighted opportunities to enhance the system's overall performance and efficiency. In light of these findings, we propose several future research directions:

// *Refinement of Synthetic Data Generation*:
Future work could explore methods to further automate and refine the synthetic dataset generation process. Techniques such as enhanced context-aware prompt engineering and dynamic adjustment of generation parameters may improve the contextual fidelity and diversity of the QA pairs.

// *Expansion of Query Types*:  
Currently, the system primarily supports factual QA generation. Future iterations could broaden its capabilities to include a variety of query types, such as:

- *Multihop Questions*: Queries that require reasoning over multiple pieces of information.

- *Logical Reasoning and Problem-Solving*: Questions designed to assess the chatbot's ability to perform complex logical operations and solve problems.

- *Creative Thinking and Ethical Dilemmas*: Queries that push the boundaries of generative responses into more subjective and ethical domains.

- *Simulated Chat Histories and Noisy Inputs*: Testing scenarios that include conversation histories or deliberately noisy queries to assess system resilience and robustness.

Future research should also expand the domain scope of the dataset, incorporate other standardized or domain dependend benchmarks, and conduct comparative studies to further validate and refine this framework.

== Conclusions

This study introduces a comprehensive framework for the evaluation of Retrieval-Augmented Generation (RAG) systems tailored to the Cuban research context. Through the development of a user-friendly Gradio-based GUI and the construction of the CRIQAD-CU dataset, we provide both practical tools and a robust foundation for benchmarking RAG-based chatbots. These contributions not only facilitate automated synthetic data generation and structured evaluation, but also address the pressing need for context-sensitive and linguistically aligned assessment methodologies in resource-constrained academic environments.

By integrating relevant retrieval and generation metrics—such as Precision\@k, MRR, MAP, and RAGAS-based scores—we enable a granular analysis of system performance across both information retrieval and response generation.

The work presented lays the groundwork for future advancements in AI-powered research support systems in Cuba, paving the way for more responsive, accurate, and contextually aware chatbots.

Future directions will focus on expanding the diversity of query types, refining synthetic data generation techniques, and extending this framework to other research domains and linguistic regions. Ultimately, this benchmark aims to empower Cuban researchers by enhancing access to reliable AI-driven tools that align with their unique informational needs and linguistic characteristics.



#bibliography("refs.bib", title: [References], style: "american-psychological-association")