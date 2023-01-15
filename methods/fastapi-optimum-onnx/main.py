from fastapi import FastAPI
from transformers import pipeline, AutoTokenizer
from optimum.onnxruntime import ORTModelForSequenceClassification
from pydantic import BaseModel
from typing import List

class Request(BaseModel):
    sequence: str
    labels: List[str]
    multi_class: bool = False

app = FastAPI()

model = ORTModelForSequenceClassification.from_pretrained("./onnx", file_name="model.onnx")
tokenizer = AutoTokenizer.from_pretrained("./onnx")
classifier = pipeline("zero-shot-classification", model=model, tokenizer=tokenizer)

@app.post("/")
async def root(request: Request):
    return classifier(request.sequence, request.labels, multi_label=request.multi_class)