
# Jekyll in docker

Build jekyll webu z githubu v dockeru.

1. Přečíst parametr `-e repo=praha.pirati.cz`
2. Zkontrolovat namountování docker volume (pro čtení, může sloužiz jako cache), cesta v `<path>`
3. `cd <path>/<repo>`
4. Pokud existuje složka `<repo>` tak updatovat `git pull`, pokud ne (nebo v případě selhání) `git clone <repo>`. Popřípadě přidat ještě parametr `force`, který smaže a naklonuje
5. `bundle install --without development`
6. `bundle exec jekyll build`

Další náležitosti:

/bin/bash: q: příkaz nenalezen

Mountujeme:

- docker volume s repo
- docker volume s buildy

Otázky:

- Používat pro všechny weby stejné docker volume? Popř. oddělit např. jen centrální web?
- Centrální web by měl být na 2 lokacích. Má to dělat tento container?
- Chování v případě neúspěchu?
