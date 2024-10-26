#!/usr/bin/env bash

# Массив репозиториев
repositories=(
    "https://github.com/user/repo1.git"
    "https://github.com/user/repo2.git"
    "https://github.com/user/repo3.git"
)

# Массив старых email адресов
old_emails=(
    "old_email1@example.com"
    "old_email2@example.com"
    "old_email3@example.com"
)

# Новые данные автора
CORRECT_NAME="WEBzaytsev"
CORRECT_EMAIL="studio@webzaytsev.ru"

# Функция для обработки репозитория
process_repository() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)

    echo "Клонирование репозитория $repo_name..."
    git clone "$repo_url"
    cd "$repo_name" || exit

    for old_email in "${old_emails[@]}"; do
        echo "Обработка email: $old_email"
        git filter-branch --env-filter '
        OLD_EMAIL="'"$old_email"'"
        CORRECT_NAME="'"$CORRECT_NAME"'"
        CORRECT_EMAIL="'"$CORRECT_EMAIL"'"
        if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
        then
            export GIT_COMMITTER_NAME="$CORRECT_NAME"
            export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
        fi
        if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
        then
            export GIT_AUTHOR_NAME="$CORRECT_NAME"
            export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
        fi
        ' --tag-name-filter cat -- --branches --tags
    done

    echo "Отправка изменений в репозиторий $repo_name..."
    git push --force --all
    git push --force --tags

    cd ..
    echo "Обработка репозитория $repo_name завершена."
}

# Основной цикл обработки репозиториев
for repo in "${repositories[@]}"; do
    process_repository "$repo"
done

echo "Все репозитории обработаны."
