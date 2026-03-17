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


docker exec -it web python manage.py createsuperuser
```

```sql
create database biblioteca;
CREATE USER 'bibliotecar'@'%' IDENTIFIED BY 'passsecr';
GRANT ALL PRIVILEGES ON biblioteca.* TO 'bibliotecar'@'%';

GRANT ALL PRIVILEGES ON `test_%`.* TO 'bibliotecar'@'%';
FLUSH PRIVILEGES;
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

* teste 5

#### Diagrama

```mermaid
%%{init: {'theme':'forest'}}%%
flowchart LR;

id0(user)

subgraph id100 [**Docker host Stage**]
	id104[nginx revprx]
	id101[pre-prod]
	id106[(Mariadb pre)]
end

id0-->id104-->id101-->id106

linkStyle 1 stroke-width:4px,stroke:red
linkStyle 2 stroke-width:4px,stroke:red
linkStyle 0 stroke-width:4px,stroke:red
```

```mermaid
%%{init: {'theme':'forest'}}%%
flowchart LR;

id0(user)

subgraph id100 [**Docker host Prod**]
	id102[blue-prod]
	id103[green-prod]
	id104[nginx revprx]
	id105[(Mariadb prod)]
end

id0-->id104-->id102-->id105
id104-->id103
id103-->id105

linkStyle 0 stroke-width:4px,stroke:blue
linkStyle 1 stroke-width:4px,stroke:blue
linkStyle 2 stroke-width:4px,stroke:blue
linkStyle 3 stroke-width:4px,stroke:green,stroke-dasharray: 5 5
linkStyle 4 stroke-width:4px,stroke:green,stroke-dasharray: 5 5
```

## CI Pipeline

```mermaid
%%{init: {'theme':'forest'}}%%
flowchart LR;

id0((START))-->id1{S-a creat PR?}--DA-->id2[git clone]-->id3[rezolv dependintele]-->id4{Code linting trecut?}--NU-->id5[[adaug comentariu PR]]
id4--DA-->id6{Unittest trecut?}--DA-->id7[merge]-->id0


id1--NU-->id101[Astept 2 min]-->id0
id6--NU-->id5
id5-->id0


```




