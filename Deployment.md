#### Подготовка
Прежде всего нужно настроить ssh-ключи как описано [здесь](https://help.github.com/articles/generating-ssh-keys).

```
git clone git@github.com:AndreyM/VentureDB.git
cd VentureDB
brew install postgresql
bundle
```

#### Добавляем свой публичный ключ на сервер в ~/.ssh/authorized_keys
```
cat ~/.ssh/id_rsa.pub | ssh root@176.58.108.251 'cat >> ~/.ssh/authorized_keys'
ssh-add -K
```

#### Чтобы развернуть приложение на сервере (на нем уже должны стоять нужные пакеты)
```
cap deploy:setup
cap deploy:cold deploy:seed
```

#### Чтобы обновить код
```
cap deploy
```


#### Бэкап базы данных
```
ssh root@venture.bi "pg_dump venture_staging > venture_backup.sql" && rsync -v root@venture.bi:venture_backup.sql .
```
По окончании операции файл `venture_backup.sql` окажется в текущей директории.  Здесь `venture_staging` — имя базы данных.

### После migration создать всем user-ам person. (+задать всем plan_ends_at):
User.where{person_id==nil}.each do |u| p = u.person; p.name = u.email; p.save!; u.person = p; u.save!; end