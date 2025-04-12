TODO: 
- Choose generation temperature and model parameters to control output diversity.

- All generated outputs are saved in JSONL format, including metadata (document source, generation timestamp, model used) to support traceability and reproducibility.

- use LLM to translate the QA pair to other languages based on English

- Further split each section of Wikipedia in order for the QA pair to have more chunks and allow a more detailed eval

BUGS:
- bad generation is keept in the "dataset" state
- 