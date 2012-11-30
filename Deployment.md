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
cap staging deploy:setup
cap staging deploy:cold deploy:seed
```

#### Чтобы обновить код
```
cap staging deploy
```


#### Production
- Профиль production деплоится с ветки deploy (получить ветку в первый раз `git checkout --track origin/deploy`)
- Команды все те же что для staging, только заменить staging на production.

