FROM ubuntu:latest
WORKDIR /code
RUN apt update && apt-get install -y curl sudo git
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
RUN sudo apt-get install git-lfs
COPY ./methods/fastapi-trivial/setup.sh /code/setup.sh
RUN chmod +x setup.sh
RUN ./setup.sh

FROM python:3.10
WORKDIR /code
COPY ./methods/fastapi-trivial/requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY --from=0 /code/bart-large-mnli /code/bart-large-mnli
COPY ./methods/fastapi-trivial/app.py /code/main.py
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]