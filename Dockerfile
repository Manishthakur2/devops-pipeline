FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN adduser --disabled-password --gecos "" thor
USER thor
COPY . .
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
