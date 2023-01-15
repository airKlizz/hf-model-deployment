FROM ubuntu:latest
WORKDIR /code
RUN apt update && apt-get install -y curl python3.10 sudo git pip python-is-python3
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
RUN sudo apt-get install git-lfs
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./setup.sh /code/setup.sh
COPY ./optim.py /code/optim.py
RUN chmod +x setup.sh
RUN ./setup.sh

FROM python:3.10
WORKDIR /code
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY --from=0 /code/onnx /code/onnx
COPY ./app.py /code/main.py
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]