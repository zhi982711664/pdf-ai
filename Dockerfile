FROM python:3.9-slim-bullseye
WORKDIR /app

# 安装系统依赖（含OCR支持）
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-chi-sim \
    poppler-utils && \
    rm -rf /var/lib/apt/lists/*

# 安装Python依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN RUN pip install uvicorn

# 复制代码
COPY ./app ./app

# 设置环境变量（CPU线程优化）
ENV OMP_NUM_THREADS=4
ENV OMP_THREAD_LIMIT=4

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
