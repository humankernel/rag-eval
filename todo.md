DONE:
refactor: try using structural output instead of manualy parssing

TODO: 
feat: allow configure model params (e.g. Temperature, Max Output Tokens)
feat: QA also save metadata (generation timestamp, model used, model params)
refactor: split each section more
feat: generate a batch using randomly selected chunks 

BUGS:
- dont generate ids
- [x] its always generating in english
- [x] clean up summary and content
- bad generation is keept in the "dataset" state
- wrong ids in wiki_qa.json
- when a QA pair is bad (empty q/a or "Information not Found") and you regenerate the pair this is always keeps in the dataset and thats obviously wrong
- sometimes sections / chunks are empty 
- if the page isn't reloaded it keep the previous data, i need a way to clean
- when saving it uses the spanish (lang & name) instead of the english
- the llm seems to be using a seed or maybe is one of the fecuency/rep penalty 