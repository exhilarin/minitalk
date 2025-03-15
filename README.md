# Minitalk Projesi

## 📌 Projenin Amacı ve Çalışma Mantığı
Bu proje, sinyal tabanlı bir mesajlaşma sistemi oluşturur. Sunucu (server) ve istemci (client) olarak çalışan iki farklı programdan oluşur.

- **İstemci (client)**, kullanıcıdan aldığı mesajı bit seviyesinde işler ve her karakterin 7 bitlik binary karşılığını Unix sinyalleri (**SIGUSR1, SIGUSR2**) kullanarak sunucuya yollar.
- **Sunucu (server)**, gelen sinyalleri toplar, bitleri birleştirerek karakterleri geri oluşturur ve ekrana yazdırır.

---

## 📌 Projenin Çalışma Adımları

### 1. Sunucu Çalıştırılır
Sunucu çalıştırıldığında, çalışan işlemin **PID’sini (Process ID)** ekrana yazdırır ve istemciden gelecek mesajları beklemeye başlar.

### 2. İstemci Çalıştırılır
İstemci çalıştırıldığında:
- Kullanıcıdan **mesaj ve sunucu PID'si** alınır.
- Her karakter **7 bitlik binary**’ye dönüştürülür.
- Bu bitler, **SIGUSR1 (1) ve SIGUSR2 (0)** sinyalleri ile sunucuya gönderilir.
- Her bit gönderildikten sonra **sunucunun onayı beklenir**.

### 3. Sunucu Sinyalleri Alır ve Karakterleri Geri Oluşturur
Sunucu, gelen **SIGUSR1 ve SIGUSR2** sinyallerini bit bit işler ve **7 bit tamamlandığında** karakteri oluşturup ekrana basar.

---

## 📌 server.c Dosyasının Ayrıntılı Açıklaması

### 💡 Sunucunun Yapacağı İşlemler
✅ **SIGUSR1 ve SIGUSR2** sinyallerini dinler.  
✅ Gelen **bitleri birleştirerek** karakterleri oluşturur.  
✅ Her karakter tamamlandığında **ekrana yazar**.  
✅ Karakteri aldığına dair istemciye **onay sinyali gönderir**.  

---

### 1️⃣ **bit_receiver() - Sunucunun Sinyalleri Alıp İşlemesi**
Bu fonksiyon, istemciden gelen **SIGUSR1 ve SIGUSR2** sinyallerini yakalar ve **bitleri birleştirerek** karakteri oluşturur.

```c
void bit_receiver(int signal, siginfo_t *info, void *context)
{
    static int i = 0; // Şu ana kadar kaç bit alındığını takip eder.
    static int c = 0; // Gelen bitlerin birleşerek oluşturduğu karakter.

    (void)context;
    if (signal == SIGUSR2)
        c = c << 1; // Eğer SIGUSR2 (0) gelirse, sola kaydır (0 ekle).
    else if (signal == SIGUSR1)
        c = (c << 1) | 1; // Eğer SIGUSR1 (1) gelirse, sola kaydır ve 1 ekle.
    
    i++;
    if (i == 7) // 7 bit tamamlandığında:
    {
        ft_printf("%c", c); // Karakteri ekrana yazdır.
        i = 0;  // Sayaç sıfırla.
        c = 0;  // Yeni karakter için sıfırla.
    }
    kill(info->si_pid, SIGUSR1); // İstemciye onay gönder.
}
```

---

### 2️⃣ **main() - Sunucunun Başlatılması**
```c
int main()
{
    struct sigaction sa;
    pid_t server_pid;

    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = bit_receiver;
    if (sigaction(SIGUSR1, &sa, NULL) == -1 || sigaction(SIGUSR2, &sa, NULL) == -1)
        return (ft_printf("sigaction() call failed.\n"), 1);
    
    server_pid = getpid();
    ft_printf("Server PID: %d\n", server_pid);
    while (1)
        pause();
    
    return (0);
}
```
---

## 📌 client.c Dosyasının Açıklaması

### 💡 İstemcinin Yapacağı İşlemler
✅ Kullanıcıdan **sunucu PID’sini ve mesajı** alır.  
✅ Mesajı **bit seviyesine çevirir** ve her bit için **SIGUSR1 (1) ve SIGUSR2 (0)** sinyallerini sunucuya yollar.  
✅ Her bit gönderildikten sonra, **sunucunun onay sinyalini bekler**.  
✅ Mesaj bittiğinde **yeni bir satıra geçmek için** `\n` karakterini de gönderir.  

---

### 1️⃣ **signal_handler() - Sunucudan Gelen Onay Sinyalini İşleme**
```c
volatile sig_atomic_t signal_check = 0;

void signal_handler(int signal_number)
{
    if (signal_number == SIGUSR1)
        signal_check = 1;  // Onay alındığında flag değiştir.
    else
        exit(EXIT_FAILURE); // Beklenmeyen sinyal alınırsa programı sonlandır.
}
```

---

### 2️⃣ **bit_converter() - Mesajı Bitlere Ayırma ve Gönderme**
```c
void bit_converter(int server_pid, char *str)
{
    int i;
    int bit;

    i = -1;
    while (str[++i]) // Mesajdaki her karakter için:
    {
        bit = 7;
        while (--bit >= 0) // Her karakterin 7 bitini sırayla gönder.
        {
            signal_check = 0; // Onay sinyalini sıfırla.
            if ((str[i] >> bit) & 1)  // Eğer bit 1 ise:
                kill(server_pid, SIGUSR1);
            else // Eğer bit 0 ise:
                kill(server_pid, SIGUSR2);
            
            while (signal_check == 0) // Sunucudan onay sinyalini bekle.
                pause();
        }
    }
}
```

---

### 3️⃣ **main() - Kullanıcıdan Veriyi Alma ve Gönderme**
```c
int main(int ac, char *av[])
{
    pid_t server_pid;
    char *str;

    if (ac == 3)
    {
        server_pid = ft_atoi(av[1]);
        if (kill(server_pid, 0) == -1 || server_pid > 4194304 || server_pid == -1)
            return(ft_printf("Invalid PID\n"), 1);

        str = av[2];
        signal(SIGUSR1, signal_handler);
        bit_converter(server_pid, str);
        bit_converter(server_pid, "\n");
    }
    else
        ft_printf("Usage: %s <PID> <message>\n", av[0]);
    return (0);
}
```

---

## 📌 Kullanım Örneği
### Sunucuyu çalıştır:
```sh
./server
```
Örnek çıktı:
```sh
Server PID: 12345
```
### İstemciyi çalıştır:
```sh
./client 12345 "Hello, World!"
```
Sunucu çıktısı:
```sh
Hello, World!
```

# **📌 Özet**
- **İstemci, mesajı tek tek bitlere ayırır ve sunucuya gönderir.**
- **Her bit gönderildikten sonra sunucunun onay sinyalini bekler.**
- **Sunucu, bitleri toplar ve karakterleri oluşturup ekrana yazdırır.**
- **Bu sistem sayesinde, sinyaller kullanılarak IPC (Inter-Process Communication) sağlanır.**

🚀 **Artık Minitalk projeniz hazır!** 🚀

