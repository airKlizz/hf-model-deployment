#!/bin/sh
echo "Download model from the HuggingFace Hub"
git lfs install
git clone https://huggingface.co/facebook/bart-large-mnli
rm -Rf bart-large-mnli/.git bart-large-mnli/README.md bart-large-mnli/flax_model.msgpack bart-large-mnli/model.safetensors bart-large-mnli/rust_model.ot