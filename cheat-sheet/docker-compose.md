`docker-compose build` — Cборка образа. Собранные образы помечаются, как projectservice.  
`docker-compose pull` — Скачивает образы из удалённого реестра в локальный Docker Registry.  
`docker-compose push` — Загружает образ из локально реестра в удаленный реестр (Docker Registry).  
`docker-compose up (-d)` — Извлекает/Собирает/Запускает контейнеры на основе указанных в stanza service: образов.  
`docker-compose logs (-f)` — Выводит в STDOUT логи контейнеров на основе указанных в stanza service: запущенных контейнеров.  
`docker-compose ps (-a)` — Выводит список запущенных контейнеров на основе указанных в stanza service: в docker-compose файле.  
`docker-compose top` — Выводит список запущенных процессов внутри контейнеров на основе указанных в stanza service: в docker-compose файле.  
`docker-compose down` — Останавливает все запущенные контейнеры на основе указанных в stanza service: в docker-compose файле.  