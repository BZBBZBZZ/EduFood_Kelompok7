# 🥗 EduFood — Kelompok 7

Aplikasi iOS edukatif berbasis **SwiftUI** yang membantu pengguna belajar tentang makanan bergizi, mengerjakan kuis, dan melihat leaderboard. Ditenagai oleh **Supabase** sebagai backend (database, autentikasi, dan storage).

---

## 📋 Persyaratan

| Kebutuhan | Versi Minimum |
|---|---|
| macOS | 13 Ventura atau lebih baru |
| Xcode | 15 atau lebih baru |
| iOS Deployment Target | iOS 17.0 |
| Swift | 5.9 |
| Supabase Swift Package | `2.x` |

---

## 🚀 Cara Setup & Menjalankan Project

### 1. Clone / Download Project

Download atau clone repository ini, lalu buka folder hasil download-nya.

```bash
git clone <url-repo>
```

Atau ekstrak file ZIP yang telah didownload.

---

### 2. Buka Project di Xcode

Buka file **`EduFood_Kelompok7.xcodeproj`** dengan Xcode (double-click atau klik kanan → Open With → Xcode).

---

### 3. ⚠️ Tambahkan Supabase Package (WAJIB)

> Ini adalah langkah **paling penting**. Tanpa ini, project tidak akan bisa di-build.

Ikuti langkah-langkah berikut untuk menambahkan Supabase ke dalam project:

#### a. Tambahkan Swift Package

1. Di Xcode, klik **File** di menu bar → **Add Package Dependencies...**
2. Di kolom pencarian (pojok kanan atas), masukkan URL berikut:
   ```
   https://github.com/supabase/supabase-swift
   ```
3. Pilih versi **`2.x.x`** (Up to Next Major Version dari `2.0.0`).
4. Klik **Add Package**.
5. Centang produk **`Supabase`**, lalu klik **Add Package** lagi.

#### b. Tambahkan ke Frameworks, Libraries, and Embedded Content

1. Di **Project Navigator** (panel kiri), klik **root project** `EduFood_Kelompok7` (ikon biru paling atas).
2. Pilih **target** `EduFood_Kelompok7` di panel tengah.
3. Klik tab **General**.
4. Scroll ke bawah hingga menemukan bagian **"Frameworks, Libraries, and Embedded Content"**.
5. Klik tombol **`+`** di bagian tersebut.
6. Cari dan pilih **`Supabase`**, lalu klik **Add**.

   > Pastikan kolom "Embed" diset ke **"Do Not Embed"** (default untuk Swift Package).

---

### 4. ⚠️ Masukkan Supabase URL & API Key (WAJIB)

Buka file berikut di Xcode:

```
EduFood_Kelompok7 / Service / SupabaseService.swift
```

Cari bagian ini dan **ganti** dengan URL dan Key Supabase project milikmu:

```swift
self.client = SupabaseClient(
    supabaseURL: URL(string: "MASUKKAN_SUPABASE_URL_KAMU_DI_SINI")!,
    supabaseKey: "MASUKKAN_SUPABASE_ANON_KEY_KAMU_DI_SINI",
    ...
)
```

#### Cara mendapatkan URL & Key Supabase:

1. Login ke [https://supabase.com](https://supabase.com) dan buka project kamu.
2. Klik **Settings** (ikon gear) di sidebar kiri → **API**.
3. Salin nilai berikut:
   - **Project URL** → masukkan ke `supabaseURL`
   - **`anon` / `public` key** → masukkan ke `supabaseKey`

---

### 5. Pilih Simulator / Device

Di toolbar Xcode (atas), pilih simulator atau perangkat iPhone yang ingin digunakan (misalnya **iPhone 16**).

---

### 6. Build & Run

Tekan **`⌘ + R`** atau klik tombol ▶ **Run** di toolbar Xcode.

Tunggu proses build selesai, lalu aplikasi akan terbuka di simulator.
