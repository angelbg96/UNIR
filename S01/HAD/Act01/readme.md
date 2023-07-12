# Actividad 01 - Instalacion de Wordpress con Puppet

## Laboratorio
- Windows 11
- VirtualBox con SO Ubuntu 22.04, 2GB RAM, 64GB Storage, 2 CPU
- Puppet 7
- Wordpress 6.2

## Requisitos previos
- Instalar puppet en los hosts
- Instalar puppet server en el host Master
- Descargar y descomprimir modulo
[mysql v15.0](https://forge.puppet.com/modules/puppetlabs/mysql/readme) en directorio modules
- Descargar y descomprimir dependencia de mysql, modulo
[stdlib v9.2](https://forge.puppet.com/modules/puppetlabs/stdlib) en directorio modules
- Agregar IP del puppet server a `/etc/hosts` de los hosts
- Instalar puppet agent en los host Agentes
- Firmar los certificados de los agentes en el puppet server
- **NOTA**: El directorio del módulo *mysql::server*, se renombró en windows por *mysql__server*

