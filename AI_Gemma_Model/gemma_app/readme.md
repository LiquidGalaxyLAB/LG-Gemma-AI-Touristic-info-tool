1. Install dependencies and build image

```
docker build -t gemma-ai-touristic-tool .
```


2. Run Container

```
docker run --gpus=all -v ollama:/root/.ollama -p 8089:8089 gemma-ai-touristic-tool
```


