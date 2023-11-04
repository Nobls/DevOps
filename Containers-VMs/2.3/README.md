# Автоматизация конфигурации и администрирование виртуальной машины с помощью Ansible

 Инициализирован Vagrantfile: **vagrant init**

 В файле Vagrantfile определена конфигурация для виртуальной машины 


**Конфигурация vm**
```
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", type: "dhcp", bridge: "wlp3s0"
  config.vm.provider "virtualbox" do |vb| 
    vb.memory = 2048
    vb.cpus = 2
  end  
end
```

### Запуск виртуальных машин

Виртуальные машины были запущены с помощью команды **vagrant up**.

### Настройка Ansible 

Был созданы файлы **ansible.cfg** и **hosts.ini**

```
[defaults]
inventory = hosts.ini
host_key_checking = False
```

inventory = hosts.ini
* Эта опция указывает Ansible на использование файла hosts.ini как инвентаря. Инвентарь в Ansible - это файл, в котором определяются хосты, к которым Ansible будет выполнять задачи. В этом файле вы указываете IP-адреса, имена хостов, пользователей, SSH-ключи и другие параметры, необходимые для подключения и управления хостами.
* Указав inventory = hosts.ini в конфигурации Ansible, вы сообщаете Ansible о том, что используете именно этот файл в качестве инвентаря. Это позволяет легко настраивать список хостов, к которым Ansible будет обращаться.

host_key_checking = False
* Эта опция отключает проверку ключей хостов SSH (SSH host key checking) в Ansible. По умолчанию Ansible выполняет проверку ключей хостов при подключении к удаленным машинам по SSH. Это проверяет, что ключ хоста соответствует ожидаемому ключу для данного хоста, что обеспечивает безопасность соединения.
* Важно отметить, что отключение проверки ключей хостов может повысить уязвимость вашей системы к атакам Man-in-the-Middle (MITM), поэтому оно должно использоваться осторожно и только в доверенных средах.

```
[vmhost]
192.168.56.12 ansible_ssh_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
```
**[vmhost]**: Это имя группы хостов.

**192.168.56.12**: то IP-адрес хоста, который принадлежит группе 'vmhost'

**ansible_ssh_user=vagrant**: Это параметр, указывающий, каким пользователем Ansible будет подключаться к удаленному хосту по SSH.

**ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key**: Этот параметр указывает путь к файлу приватного ключа SSH, который Ansible будет использовать для аутентификации при подключении к удаленному хосту.

### Написание Ansible-плейбука

Был создан файл **playbook.yml**

```
---
- name: Configure VM
  hosts: vmhost
  become: true
  tasks:
    - name: Update package cache
      apt:
        update_cache: yes

    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Start Apache service
      service:
        name: apache2
        state: started

    - name: Create a user
      user:
        name: myuser
        state: present
        shell: /bin/bash
        groups: sudo
        create_home: true

    - name: Generate SSH key
      user:
        name: myuser
        generate_ssh_key: yes
        ssh_key_bits: 2048
        ssh_key_file: .ssh/id_rsa    

    - name: Add SSH key to the user
      authorized_key:
        user: myuser
        state: present
        key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
```

**- name: Configure VM**:  Имя блока задачи. Этот блок будет выполняться на удаленной виртуальной машине с именем vmhost.

**hosts: vmhost**:  Указывает виртуальную машину, на которой будут выполняться задачи.

**become: true**: Указывает Ansible выполнять задачи с правами суперпользователя.

**- name: Update package cache**: Обновляет кэш пакетов на виртуальной машине с помощью модуля apt.

**- name: Install Apache**: Устанавливает пакет Apache с помощью модуля apt.

**- name: Start Apache service**: Запускает службу Apache с помощью модуля service.

**- name: Create a user**: Создает нового пользователя с именем myuser с правами администратора (группа sudo) и оболочкой /bin/bash. Также создается домашний каталог пользователя (**create_home: true**).

**- name: Generate SSH key**: Генерирует SSH-ключ для пользователя myuser с длиной 2048 бит и сохраняет его в каталоге ~/.ssh/id_rsa пользователя.

**- name: Add SSH key to the user**: Добавляет публичный SSH-ключ (из файла ~/.ssh/id_rsa.pub) в файл ~/.ssh/authorized_keys пользователя myuser. Это позволяет пользователю myuser аутентифицироваться с использованием SSH-ключей.

Для запуска **playbook.yml** выполняется команда **ansible-playbook playbook.yml**

### Задачи по администрированию Linux

Был создан файл **administerlinux.yml**

```
---
- name: Administer Linux
  hosts: vmhost
  become: true
  tasks:
    - name: Create  text file with timestamp
      command: touch /home/myuser/myfile_{{ ansible_date_time.date }}_{{ ansible_date_time.hour }}:{{ ansible_date_time.minute }}.txt
      args:
        creates: /home/myuser/myfile_{{ ansible_date_time.date }}_{{ ansible_date_time.hour }}:{{ ansible_date_time.minute }}
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Create a cron job for regular tmp file cleanup
      cron:
        name: "Cleanup tmp files"
        user: myuser
        job: "find /tmp -type f -mtime +7 -delete"
        cron_file: cleanup_temp_files
        state: present

    - name: Log the actions
      debug:
        msg: "Performed administrative tasks with Ansible on {{ inventory_hostname }}"

```

**- name: Create text file with timestamp**: Создает текстовый файл с текущим временем в имени файла. Использует команду touch с переменными **ansible_date_time.date**, **ansible_date_time.hour** и **ansible_date_time.minute** для вставки текущей даты и времени в имя файла. Параметр **creates** используется для проверки наличия файла перед выполнением задачи.

**- name: Install Nginx**: Устанавливает пакет Nginx с помощью модуля apt.

**- name: Create a cron job for regular tmp file cleanup**: Создает cron-задачу для регулярной очистки временных файлов. Это выполняется с помощью модуля **cron**. Задача будет выполняться под пользователем myuser и будет запускать команду **find**, которая удаляет временные файлы в директории /tmp, старше 7 дней.

**- name: Log the actions**: Выводит сообщение в лог о выполнении действий. Использует модуль **debug** и выводит сообщение с именем хоста из инвентаря (inventory_hostname), указывая, какие действия были выполнены.
