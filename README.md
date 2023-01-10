# Despliegue de un máster-minion en Vagrant y aprovisionamiento en Salt 🧂.

El objetivo es desplegar dos máquinas virtuales 'virtualbox' definidas en Vagrant sobre las cuáles montar un cluster de Salt. Una MV hará el rol de master y la otra de minion. El master, a través de Salt deplegará todos los servicios necesarios para hacer funcionar un magento base (states) con toda su configuración (pilares) en el minion.

## Requisitos del sistema.

- Virtualbox [obligatorio].
- Vagrant [obligatorio].
- OpenSSL [opcional].

En Ubuntu, para instalar virtualbox:

```sh
sudo apt install virtualbox
```

> [Cómo instalar Vagrant.](https://developer.hashicorp.com/vagrant/downloads)

## ⚠️ IMPORTANTE

En caso de tenerlo instalado, desinstalar el plugin de vagrant-salt ya que está desactualizado y ya viene por defecto en la instalación de Vagrant.

```sh
vagrant plugin list
```

En caso de estar instalado, desinstalar el plugin con:

```sh
vagrant plugin uninstall vagrant-salt
```

## Descargar el código.

Clonar el repositorio en un directorio local.

```sh
git clone https://github.com/gruizonestic/magento-salt
```

Navegar al directorio magento-salt.

```sh
cd magento-salt
```

## ⚠️ Previo a arrancar las MV.

Un cluster de Salt necesita que el máster verifique la autenticidad de los minions que se le conectan. Para ello habrá que generar un par de claves pública/privada. Tal y como está configurado por defecto, hay que:

En el directorio magento-salt, crear el directorio ssh-keys y acceder a él.

```sh
mkdir ssh-keys && cd ssh-keys
```

Generar la clave privada del máster.

```sh
openssl genrsa -out master.pem 2048
```

Extraer la clave pública del máster.

```sh
openssl rsa -in master.pem -outform PEM -pubout -out master.pem
```

Generar la clave privada del minion.

```sh
openssl genrsa -out minion.pem 2048
```

Extraer la clave pública del minion.

```sh
openssl rsa -in minion.pem -outform PEM -pubout -out minion.pub
```

## Poner en marcha el máster.

Navegar al directorio master.

```sh
cd ../master
```

Arrancar la máquina virtual ejecutando:

```sh
vagrant up
```

La primera vez que arranques la máquina, Vagrant hará el aprovisionamiento con una instalación básica de Salt y sus dependencias. Para ello, descargará el [bootstrap de Salt](https://docs.saltproject.io/salt/install-guide/en/latest/topics/bootstrap.html) y lo ejecutará. También se guardará las claves de acceso del minion.

Acceder por ssh al máster.

```sh
vagrant ssh
```

## Comprobar instalación de salt y las claves del minion.

Para comprobar que la instalación de salt está funcionado correctamente y que las claves del minion se han aceptado, ejecutamos:

```sh
sudo salt-key
```

Nos debería de aparecer en verde "minion" en la sección Accepted Keys.

> ⚠️ Los ficheros de configuración de la MV están en **Vagrantfile**. Por defecto, la dirección IP asignada al máster es 192.168.56.10. Si quieres cambiar esta IP, asegúrate de cambiarla también en el archivo de configuración de Salt para que el minion encuentre a su master (magento-salt/minion/salt/config).

## Poner en marcha el minion.

Abrimos una terminal nueva y navegamos al directorio minion.

```sh
cd magento-salt/minion
```

Arrancar la máquina virtual ejecutando:

```sh
vagrant up
```

Acceder por ssh al minion.

```sh
vagrant ssh
```

## Comprobar instalación de salt en el minion.

Para comprobar que la instalación de salt está funcionado correctamente, lanzamos:

```sh
sudo systemctl status salt-minion.service
```

Y comprobamos que el servicio está ejecutándose.

## Estructura de ficheros

```
magento-salt/
├── master
│   ├── .vagrant
│   ├── salt
│   │   ├── pillar
│   │   ├── states
│   │   └── config (configuración de Salt)
│   └── Vagrantfile (configuración máster)
├── minion
│   ├── .vagrant
│   ├── salt
│   │   └── config (configuración de Salt)
│   └── Vagrantfile (configuración minion)
├── ssh-keys
│   ├── master.pem
│   ├── master.pub
│   ├── minion.pem
│   └── minion.pub
└── README
```

> Por comodidad, los directorios pillar y states están en local y montados dentro de /srv/salt y /srv/pillar dentro de la MV.

## Archivos de configuración

### Vagrantfile

Define las características de las máquinas virtuales.
Por defecto, las IP son:

```
# Config del máster
Vagrant.configure("2") do |config|
...
config.vm.network "private_network", ip: "192.168.56.10"
...
```

```
# Config del minion
Vagrant.configure("2") do |config|
...
config.vm.network "private_network", ip: "192.168.56.11"
...
```

[Más información sobre cómo personalizar las MV con Vagrant](https://developer.hashicorp.com/vagrant/docs/vagrantfile)

### Salt config

El fichero config se almacenará en /etc/salt una vez finalizado el aprovisionamiento. El minion ha de incluir la clave

```
master: {ip_master}
```

para poder encontrar al master.

## ⚠️ Configuración de los pilares

Es necesario que modifiques la información de los pilares indicada con:

```
# Modificar información
```

con los datos que tú quieras.

## Cifrado de la información sensible.

Salt permite cifrar la información sensible almacenada en los pilares. Para ello, seguir el tutorial que se indica [aquí](https://r-pufky.github.io/docs/configuration-management/saltstack/salt-master/gpg.html).

## Comprobar los pilares.

Antes de ejecutar un highstate es conveniente comprobar que la información de los pilares se descifra correctamente. Para ello, ejecutar en el master:

```sh
sudo salt 'minion' pillar.items
```

y comprobamos que toda la información está descifrada.

## Ejecutar el highstate.

Para instalar magento y todas sus configuraciones lanzamos un highstate.

```sh
sudo salt 'minion' state.apply
```
