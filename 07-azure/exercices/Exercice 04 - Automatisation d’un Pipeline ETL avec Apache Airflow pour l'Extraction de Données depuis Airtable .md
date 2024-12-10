### **Projet Complet : Automatisation d’un Pipeline ETL avec Apache Airflow pour l'Extraction de Données depuis Airtable et le Chargement dans une Base de Données PostgreSQL**

---

#### **Objectif :**
Mettre en place un pipeline ETL complet en utilisant **Apache Airflow** pour automatiser :
1. **L'extraction des données** depuis une base Airtable.
2. **La transformation des données** avec Pandas.
3. **Le chargement des données** transformées dans une base PostgreSQL.

---

### **Étapes du Projet :**

---

#### **1. Préparation de l'environnement**

1. **Prérequis :**
   - Un environnement configuré avec Docker et Docker Compose.
   - Apache Airflow installé via Docker Compose.
   - Une base de données PostgreSQL accessible.
   - Une clé API pour accéder à Airtable.

2. **Structure du Projet :**
   ```
   etl_project/
   ├── dags/
   │   ├── etl_pipeline.py
   ├── sql/
   │   ├── create_table.sql
   ├── scripts/
   │   ├── transform_data.py
   ├── docker-compose.yml
   ├── requirements.txt
   ```

---

#### **2. Configuration de Docker Compose**

Créez un fichier `docker-compose.yml` pour déployer Apache Airflow :

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    ports:
      - "5432:5432"

  airflow:
    image: apache/airflow:2.6.0
    environment:
      AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
      AIRFLOW__CORE__EXECUTOR: 'LocalExecutor'
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: 'postgresql+psycopg2://airflow:airflow@postgres:5432/airflow'
    ports:
      - "8080:8080"
    volumes:
      - ./dags:/opt/airflow/dags
      - ./sql:/opt/airflow/sql
      - ./scripts:/opt/airflow/scripts
    depends_on:
      - postgres
```

---

#### **3. Développement du DAG (Pipeline Airflow)**

Dans le fichier `dags/etl_pipeline.py` :

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd
import requests
import psycopg2

# Configurations
AIRTABLE_API_URL = "https://api.airtable.com/v0/{BASE_ID}/{TABLE_NAME}"
AIRTABLE_API_KEY = "your_airtable_api_key"
POSTGRES_CONN = {
    "dbname": "airflow",
    "user": "airflow",
    "password": "airflow",
    "host": "postgres",
    "port": "5432"
}

# Tasks
def extract_data_from_airtable():
    """Fetch data from Airtable API."""
    headers = {"Authorization": f"Bearer {AIRTABLE_API_KEY}"}
    response = requests.get(AIRTABLE_API_URL, headers=headers)
    data = response.json()
    records = data.get('records', [])
    rows = [{"id": rec["id"], **rec["fields"]} for rec in records]
    pd.DataFrame(rows).to_csv("/opt/airflow/dags/temp_data.csv", index=False)

def transform_data():
    """Clean and transform data using Pandas."""
    df = pd.read_csv("/opt/airflow/dags/temp_data.csv")
    df['processed_at'] = datetime.now()
    df.to_csv("/opt/airflow/dags/transformed_data.csv", index=False)

def load_data_to_postgres():
    """Load transformed data into PostgreSQL."""
    conn = psycopg2.connect(**POSTGRES_CONN)
    cursor = conn.cursor()

    # Create table if not exists
    with open("/opt/airflow/sql/create_table.sql", "r") as f:
        cursor.execute(f.read())

    # Load data
    df = pd.read_csv("/opt/airflow/dags/transformed_data.csv")
    for _, row in df.iterrows():
        cursor.execute("""
            INSERT INTO etl_data (id, field1, field2, processed_at)
            VALUES (%s, %s, %s, %s)
        """, (row['id'], row['field1'], row['field2'], row['processed_at']))

    conn.commit()
    cursor.close()
    conn.close()

# DAG definition
with DAG(
    dag_id="airtable_etl_pipeline",
    start_date=datetime(2023, 1, 1),
    schedule_interval="@daily",
    catchup=False
) as dag:
    extract_task = PythonOperator(
        task_id="extract_data",
        python_callable=extract_data_from_airtable
    )
    transform_task = PythonOperator(
        task_id="transform_data",
        python_callable=transform_data
    )
    load_task = PythonOperator(
        task_id="load_data",
        python_callable=load_data_to_postgres
    )

    extract_task >> transform_task >> load_task
```

---

#### **4. SQL Script pour PostgreSQL**

Fichier `sql/create_table.sql` :

```sql
CREATE TABLE IF NOT EXISTS etl_data (
    id TEXT PRIMARY KEY,
    field1 TEXT,
    field2 TEXT,
    processed_at TIMESTAMP
);
```

---

#### **5. Script pour Transformation (optionnel)**

Fichier `scripts/transform_data.py` :

```python
import pandas as pd
from datetime import datetime

def transform_data():
    df = pd.read_csv("/opt/airflow/dags/temp_data.csv")
    df['processed_at'] = datetime.now()
    df.to_csv("/opt/airflow/dags/transformed_data.csv", index=False)

if __name__ == "__main__":
    transform_data()
```

---

#### **6. Lancement du Projet**

1. **Démarrez Docker Compose :**
   ```bash
   docker-compose up
   ```

2. **Accédez à l'interface Airflow :**
   - URL : `http://localhost:8080`
   - Identifiants par défaut : `airflow` / `airflow`

3. **Activez le DAG `airtable_etl_pipeline` dans l’interface.**

4. **Visualisez les données :**
   - Connectez-vous à PostgreSQL pour vérifier les données chargées :
     ```bash
     docker exec -it etl_project_postgres_1 psql -U airflow -d airflow
     SELECT * FROM etl_data;
     ```

---

### **Expansions possibles :**
- **Surveillance des erreurs** : Ajouter des mécanismes de gestion d'erreurs et de notifications en cas d'échec.
- **Scaling** : Étendre le pipeline pour inclure plusieurs tables Airtable.
- **Visualisation** : Connecter PostgreSQL à un outil BI comme Tableau ou Power BI pour visualiser les données.

---

### **Livrables :**
1. Code complet du pipeline Airflow.
2. Instructions pour exécuter et valider le pipeline.
3. Explications détaillées de chaque étape (Extraction, Transformation, Chargement).

---

Ce projet met en avant des compétences clés en **data engineering** : automatisation des pipelines, gestion des API, transformation des données avec Pandas, et intégration avec des bases de données relationnelles.
