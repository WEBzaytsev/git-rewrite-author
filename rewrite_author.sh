#!/usr/bin/env bash

# GitHub credentials
GITHUB_USERNAME="your_username"
GITHUB_TOKEN="your_personal_access_token"

# Массив репозиториев (только имена репозиториев)
REPOSITORIES=(
    "repo1"
    "repo2"
    "repo3"
)

# Массив старых email адресов
OLD_EMAILS=(
    "old_email1@example.com"
    "old_email2@example.com"
    "old_email3@example.com"
)

# Новые данные автора
CORRECT_NAME="WEBzaytsev"
CORRECT_EMAIL="nikita@zaitsv.dev"

# Функция для обработки репозитория
process_repository() {
    local repo_name="$1"

    echo "Обработка репозитория $repo_name..."
    
    if [ -d "$repo_name" ]; then
        echo "Директория $repo_name уже существует. Пропускаем клонирование."
        cd "$repo_name" || exit
    else
        echo "Клонирование репозитория $repo_name..."
        git clone "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${repo_name}.git"
        cd "$repo_name" || exit
    fi

    # Проверяем, были ли уже внесены изменения
    if git log -1 --pretty=%B | grep -q "Update author information"; then
        echo "Изменения уже были внесены. Пропускаем обработку."
        cd ..
        return
    fi

    for old_email in "${OLD_EMAILS[@]}"; do
        echo "Обработка email: $old_email"
        git filter-branch -f --env-filter '
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

    # Добавляем коммит-маркер
    git commit --allow-empty -m "Update author information"
    git push

    cd ..
    echo "Обработка репозитория $repo_name завершена."
}

# Основной цикл обработки репозиториев
for repo in "${REPOSITORIES[@]}"; do
    process_repository "$repo"
done

echo "Все репозитории обработаны."
