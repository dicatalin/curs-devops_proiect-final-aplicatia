## Python prereq

```bash
python3 -m venv venv
source venv/bin/activate
pip install django mysqlclient python-dotenv

python manage.py runserver

deactivate

```

```bash
django-admin startproject loc_biblioteca .
python manage.py startapp biblioteca

```

```sql
create database biblioteca;
CREATE USER 'bibliotecar'@'%' IDENTIFIED BY 'passsecr';
GRANT ALL PRIVILEGES ON biblioteca.* TO 'bibliotecar'@'%';
```

## teste

#### Code linting

```bash
pip install flake8 ruff
```

```bash
flake8 . --exclude=venv
```

```bash
ruff check .
ruff check . --fix
```

#### Unit testing

* teste 3


