# HF Model deployment comparison

This repo aims to compare different deployment methods for a ML from the HuggingFace Hub.
We are using [bart-large-mnli](https://huggingface.co/facebook/bart-large-mnli) for our experiments but we expect our results valid for most of the ML models (at least Transformers ones).

## Setup

Each compared method is in the `methods` folder.
For each of the methods, follow those steps:

> You only need to have [conda](https://formulae.brew.sh/cask/miniconda#default) and [git lfs](https://formulae.brew.sh/formula/git-lfs#default) installed

**Go in the method folder**

```bash
export METHOD_NAME=<name-of-the-method>
cd methods/$METHOD_NAME
```

**Create Conda env**

```bash
conda create --name ml-deploy-$METHOD_NAME python=3.10
conda activate ml-deploy-$METHOD_NAME
```

**Install dependencies**

```bash
pip install -r requirements.txt
```

**Download the model**

```bash
chmod +x setup.sh
./setup.sh
```

## Run locally

Again from each method folder, you can run:

```bash
chmod +x run.sh
./run.sh
```

This will start the server and you can test the API.

## Create Docker image

Again from each method folder, you can run:

```bash
docker build -t $METHOD_NAME .
```

This will create the docker image.

To run it, simply use:

```bash
export PORT_TO_USE=8000
docker run -p $PORT_TO_USE:80 --name $METHOD_NAME $METHOD_NAME
```

Access it on http://localhost:$PORT_TO_USE/docs.
