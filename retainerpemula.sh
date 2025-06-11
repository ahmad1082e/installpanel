#!/bin/bash

# RetainerPemula - Pterodactyl Node Auto Creator
# Script untuk membuat lokasi dan node pterodactyl secara otomatis

echo "=================================================="
echo "        RetainerPemula Node Creator v1.0          "
echo "=================================================="
echo ""

# Fungsi untuk validasi input
validate_input() {
    if [ -z "$1" ]; then
        echo "❌ Input tidak boleh kosong!"
        exit 1
    fi
}

# Minta input dari pengguna
echo "📍 Masukkan nama lokasi: "
read -r location_name
validate_input "$location_name"

echo "📝 Masukkan deskripsi lokasi: "
read -r location_description
validate_input "$location_description"

echo "🌐 Masukkan domain: "
read -r domain
validate_input "$domain"

echo "🖥️ Masukkan nama node: "
read -r node_name
validate_input "$node_name"

echo "💾 Masukkan RAM (dalam MB): "
read -r ram
validate_input "$ram"

echo "💿 Masukkan jumlah maksimum disk space (dalam MB): "
read -r disk_space
validate_input "$disk_space"

echo "🆔 Masukkan Locid: "
read -r locid
validate_input "$locid"

echo ""
echo "=================================================="
echo "           Memproses Pembuatan Node...            "
echo "=================================================="

# Ubah ke direktori pterodactyl
cd /var/www/pterodactyl || { 
    echo "❌ Direktori /var/www/pterodactyl tidak ditemukan"
    echo "Pastikan Pterodactyl sudah terinstall dengan benar"
    exit 1
}

# Cek apakah artisan command tersedia
if [ ! -f "artisan" ]; then
    echo "❌ File artisan tidak ditemukan"
    echo "Pastikan Anda berada di direktori pterodactyl yang benar"
    exit 1
fi

echo "🏗️ Membuat lokasi baru..."
# Membuat lokasi baru
php artisan p:location:make <<EOF
$location_name
$location_description
EOF

if [ $? -eq 0 ]; then
    echo "✅ Lokasi berhasil dibuat!"
else
    echo "❌ Gagal membuat lokasi"
    exit 1
fi

echo "🖥️ Membuat node baru..."
# Membuat node baru
php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF

if [ $? -eq 0 ]; then
    echo "✅ Node berhasil dibuat!"
    echo ""
    echo "=================================================="
    echo "              Pembuatan Selesai! ✅               "
    echo "=================================================="
    echo "📍 Lokasi: $location_name"
    echo "🖥️ Node: $node_name"
    echo "🌐 Domain: $domain"
    echo "💾 RAM: ${ram}MB"
    echo "💿 Disk: ${disk_space}MB"
    echo "=================================================="
else
    echo "❌ Gagal membuat node"
    exit 1
fi

echo "🎉 Proses pembuatan lokasi dan node telah selesai!"
echo "📝 Jangan lupa untuk:"
echo "   1. Konfigurasi DNS untuk domain: $domain"
echo "   2. Generate allocation untuk node"
echo "   3. Dapatkan token configuration untuk wings"
echo ""
echo "RetainerPemula - Created with ❤️"