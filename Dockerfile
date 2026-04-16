FROM python:3.10-slim

WORKDIR /app

# 1. On copie SEULEMENT le fichier des dépendances
COPY requirements.txt .

# 2. On installe les librairies (Cette étape sera mise en cache)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 3. On copie le reste du code (Seulement maintenant !)
COPY . .

EXPOSE 8000

CMD ["python", "app.py"]
