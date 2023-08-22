#
# Cookbook:: wordpress
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.

# Descargar cookbooks dependencias:
# - MySQL : https://supermarket.chef.io/cookbooks/mysql
# - apparmor : https://supermarket.chef.io/cookbooks/apparmor
# - line : https://supermarket.chef.io/cookbooks/line

include_recipe '::apache'
include_recipe '::mysqldb'
include_recipe '::wordpress'
