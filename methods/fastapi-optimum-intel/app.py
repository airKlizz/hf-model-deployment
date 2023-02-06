from fastapi import FastAPI
from transformers import AutoTokenizer, pipeline
from pydantic import BaseModel
from typing import List
from optimum.intel.openvino import OVModelForSequenceClassification

class Request(BaseModel):
    sequence: str
    labels: List[str]
    multi_class: bool = False

app = FastAPI()

model = OVModelForSequenceClassification.from_pretrained("./bart-large-mnli", from_transformers=True)
tokenizer = AutoTokenizer.from_pretrained("./bart-large-mnli")
classifier = pipeline("zero-shot-classification", model=model, tokenizer=tokenizer)

@app.get("/")
async def health():
    return

@app.post("/")
async def root(request: Request):
    return classifier(request.sequence, request.labels, multi_label=request.multi_class)