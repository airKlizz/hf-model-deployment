from optimum.onnxruntime import ORTModelForSequenceClassification
from transformers import AutoTokenizer

model_checkpoint = "./bart-large-mnli"
save_directory = "./onnx/"
tokenizer = AutoTokenizer.from_pretrained(model_checkpoint)
ort_model = ORTModelForSequenceClassification.from_pretrained(model_checkpoint, from_transformers=True)
# Save the ONNX model and tokenizer
ort_model.save_pretrained(save_directory)
tokenizer.save_pretrained(save_directory)