# Скрипт для массового обновления авторства в Git-репозиториях

## Описание

Этот скрипт предназначен для автоматического обновления информации об авторе и коммитере в нескольких Git-репозиториях. Он особенно полезен в ситуациях, когда необходимо изменить старые email адреса на новые во всей истории коммитов нескольких проектов.

## Назначение

Скрипт решает следующие задачи:

1. Массовое обновление информации об авторе и коммитере в нескольких репозиториях.
2. Замена старых email адресов на новый во всех коммитах истории.
3. Автоматизация процесса клонирования, обновления и отправки изменений в репозитории.

## Логика работы

1. Скрипт использует два предопределенных массива:
   - `repositories`: список URL-адресов Git-репозиториев для обработки.
   - `old_emails`: список старых email адресов, которые нужно заменить.

2. Для каждого репозитория из списка выполняются следующие действия:
   - Клонирование репозитория в локальную директорию.
   - Перебор всех старых email адресов.
   - Для каждого старого email выполняется `git filter-branch`, который заменяет информацию об авторе и коммитере во всех коммитах.
   - Отправка обновленной истории в удаленный репозиторий с помощью `git push --force`.

3. Процесс повторяется для каждого репозитория в списке.

## Важные замечания

- Скрипт использует `git push --force`, что может привести к потере данных при неправильном использовании.
- Необходимо иметь соответствующие права доступа ко всем репозиториям в списке.
- Рекомендуется сначала протестировать скрипт на копиях репозиториев.
- Убедитесь, что у вас достаточно места на диске для клонирования всех репозиториев.

## Использование

1. Отредактируйте массивы `repositories` и `old_emails` в скрипте, добавив нужные репозитории и email адреса.
2. Установите правильные значения для `CORRECT_NAME` и `CORRECT_EMAIL`.
3. Запустите скрипт: `./rewrite_author.sh`

**Внимание:** Используйте этот скрипт с осторожностью, особенно на продакшн-репозиториях. Всегда делайте резервные копии перед выполнением массовых изменений в истории Git.