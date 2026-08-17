# Oxalyn Compiler

`compiler/`, farklı kaynak formatlarını ve mimarileri güvenli biçimde
tanıyıp Oxalyn-64'e çevirmek için eklenti tabanlı compiler çekirdeğidir.

## Kullanım

```bash
make compiler
build/compiler --list-arch
build/compiler --inspect program.elf
build/compiler program.asm -o build/program
build/compiler program.s -o build/program-auto
```

Oxalyn assembly için çıktı:

```text
build/program.asm
build/program.bin
build/program.report.txt
```

`x86-64`, `ARM64` ve `RISC-V64` kaynak assembly'lerinin güvenli bir temel
alt kümesi Oxalyn assembly ve `.bin` çıktısına çevrilebilir. WebAssembly,
ELF, PE/COFF ve Mach-O dosyaları başlık/mimari seviyesinde tanınır.
Henüz tamamlanmamış binary decoder'ları için sahte Oxalyn kodu üretilmez;
`.report.txt` oluşturulur ve compiler hata koduyla durur. Bu davranış,
sessizce yanlış makine kodu üretmekten daha güvenlidir.

`.asm` ve `.oxs` uzantıları Oxalyn assembly olarak, `.s` ve `.S` uzantıları
ise içindeki register/mnemonic izlerine göre otomatik algılanır. Belirsiz
bir `.s` dosyasında `--arch x86-64`, `--arch arm64` veya `--arch riscv64`
kullanılmalıdır.

## Eklenti modeli

Mimari backend'leri `compiler/arch.c` içindeki kayıt tablosuyla tanımlanır.
Her backend'in üç sorumluluğu vardır:

1. Kaynak/ikili biçimin mimarisini tanımak.
2. Komutları ortak ara gösterime çevirmek.
3. Ara gösterimden Oxalyn assembly üretmek.

Bir backend bilinmeyen veya desteklenmeyen komutla karşılaşırsa çevrimi
başarısız etmeli ve komut adresini/bytes bilgisini raporlamalıdır.