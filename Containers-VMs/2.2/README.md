# Создании многокомпонентного окружения

 Инициализирован Vagrantfile: **vagrant init**

 В файле Vagrantfile определены конфигурации для двух виртуальных машин: "vm1" и "vm2".


**Конфигурация vm1**
```
config.vm.define "vm1" do |vm1|
    vm1.vm.box = "bento/ubuntu-20.04"
    vm1.vm.network "private_network", type: "dhcp", bridge: "wlp3s0"
    vm1.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    vm1.vm.provision "shell", path: "install_vm1.sh"
  end
```
**Конфигурация vm2**
```
config.vm.define "vm2" do |vm2|
    vm2.vm.box = "bento/ubuntu-20.04"
    vm2.vm.network "private_network", type: "dhcp", bridge: "wlp3s0"
    vm2.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    vm2.vm.provision "shell", path: "install_vm2.sh"
  end
```

### Настройки сети 

Для того чтобы настроить сеть для виртуальных машин, добавлен следующий код

```
vm1.vm.network "private_network", type: "dhcp", bridge: "wlp3s0"
vm2.vm.network "private_network", type: "dhcp", bridge: "wlp3s0"
```
Где **private_network** приватная сеть предоставляет виртуальным машинам сетевой доступ друг к другу внутри виртуальной среды.

Использован динамический IP 

Добавлен **bridge:** **wlp3s0** параметр настройки сети который указывает на сетевой адаптер на хост-компьютере, через который виртуальная машина будет иметь доступ к локальной сети и интернету.

**wlp3s0** был получен с помощбю команды **ip a**

### Создание скриптов установки

Были созданы скрипты установки для виртуальных машин и вынесены в отдельные файлы **install_vm1.sh** и **install_vm2.sh**

```
#!/bin/bash
apt-get update
apt-get install -y nginx
```

```
#!/bin/bash
apt-get update
apt-get install -y mysql-server
```

### Запуск виртуальных машин

Виртуальные машины были запущены с помощью команды **vagrant up**.

### Тестирование и взаимодействие 

* Проверка взаимодействия между "vm1" и "vm2" с использованием команды ping.
    ![image](report/ping_vm1.png)

* Проверка доступа к интернету через NAT.
    ![image](report/ping_google.png)

