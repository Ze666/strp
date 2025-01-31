--[[
FiveM-JailNJury
A Jail and Justice System that gives power back to the players.
Copyright (C) 2018  Jarrett Boice

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

description "Jail n' Jury"
author "Slavko Avsenik"
version "1.0.0"

client_scripts {
  "@paradise-area/area.lua",
  "sh_config.lua",
  "cl_jailnjury.lua"
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  "sh_config.lua",
  "sv_jailnjury.lua"
}

dependencies {
  'es_extended',
  'esx_service',
  'paradise-area'
}