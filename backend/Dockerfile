FROM python:3.8 AS builder

WORKDIR /app

RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# migrationコマンドのために追加
ENV PYTHONPATH="/app/src"

RUN pip install --upgrade pip

# requirements.txt を先にコピーして依存関係をインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .


FROM python:3.8 AS service
WORKDIR /root/app/site-packages
COPY --from=builder /venv /venv
COPY --from=builder /app/src /app/src
ENV PATH=/venv/bin:$PATH
ENV PYTHONPATH="/app/src"
