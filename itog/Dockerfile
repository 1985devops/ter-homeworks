FROM python:3.10-slim
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install flask mysql-connector-python
COPY app.py .
EXPOSE 80
