```bash
python3 -m venv venv
source venv/bin/activate
pip install django mysqlclient

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
