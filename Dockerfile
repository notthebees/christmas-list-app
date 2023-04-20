FROM python:3.11.3-alpine

ENV FLASK_APP hello.py

RUN adduser -D flask
USER flask

WORKDIR /home/flask

COPY requirements.txt ./
RUN python -m venv venv
RUN venv/bin/pip install -r requirements.txt

COPY hello.py boot.sh ./

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
