from flask import Flask
import mysql.connector
import os

app = Flask(__name__)

@app.route('/')
def hello():
    db_host = os.environ.get('DB_HOST', 'localhost')
    db_user = os.environ.get('DB_USER', 'db_user')
    db_password = os.environ.get('DB_PASSWORD', 'SuperSecretPassword123!')
    db_name = os.environ.get('DB_NAME', 'app_database')

    try:
        connection = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        if connection.is_connected():
            status = "Супер успешное подключено к СУБД MySQL в Yandex Cloud!"
            connection.close()
    except Exception as e:
        status = f"Ну ё маё, ошибка подключения к БД: {e}"

    return f"<h1>Курсовая работа наконец то готова, фууууу!</h1><p>Статус БД: <b>{status}</b></p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
