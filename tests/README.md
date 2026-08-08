# Oxalyn-64 testleri

Bu klasör, assembler ve simülatör için uçtan uca test alanıdır.

Şimdilik mevcut eski testler temizlendi. Yeni test eklemek için:

1. `tests/ornek.asm` dosyasına assembly programını yaz.
2. `tests/ornek.expected` dosyasına `sim -q` çıktısında aranacak satırları yaz.
3. `make test` çalıştır.

`template.asm` ve `template.expected` dosyaları bilerek boş bırakılmıştır.

## Compiler testleri

Mimari algılama ve assembly çevirisi için:

```bash
make compiler-test
```

Bu testler x86-64, ARM64 ve RISC-V64 kaynak assembly alt kümelerini,
Oxalyn `.asm`/`.bin` üretimini, WebAssembly başlık algılamasını ve
desteklenmeyen komutlarda sahte binary üretilmediğini kontrol eder.
Çalıştırıcı boş şablonları hata saymadan atlar.