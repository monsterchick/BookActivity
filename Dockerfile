FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
# 安装系统依赖（用于mysqlclient）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        pkg-config \
        default-libmysqlclient-dev \
        build-essential \
        gcc \
        && pip install --no-cache-dir -r requirements.txt \
        && apt-get purge -y --auto-remove build-essential gcc \
        && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
