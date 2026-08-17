#!/bin/bash

# Bulunduğun klasörde git yoksa başlat
if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

# Token ve Remote Ayarı
REPO_URL="https://@github.com/MECFORCH/oxalyn.git"
git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"

# Değişiklikleri Hazırla
git add .
git commit -m "." 2>/dev/null

echo "🔄 Güncelleme gönderiliyor..."

# Çakışmaları çöz ve gönder
git pull origin main --allow-unrelated-histories --no-edit 2>/dev/null
if git push -u origin main; then
    echo "✅ İşlem başarılı, GitHub güncellendi!"
else
    echo "⚠️ Zorlama moduyla gönderiliyor..."
    git push -u origin main --force
    echo "✅ Güncelleme tamamlandı!"
fi
