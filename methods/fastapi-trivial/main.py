from fastapi import FastAPI
from transformers import pipeline
from pydantic import BaseModel
from typing import List


class Request(BaseModel):
    sequence: str
    labels: List[str]
    multi_class: bool = False

app = FastAPI()

classifier = pipeline("zero-shot-classification", model="./bart-large-mnli")

@app.post("/")
async def root(request: Request):
    return classifier(request.sequence, request.labels, multi_label=request.multi_class)