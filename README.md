# Criando um Blog de Notas para Programadores

## Gerando o projeto minicurso:

```bash
rails new minicurso -d postgresql
```

Isso vai gerar toda a estrutura do projeto Ruby on Rails.

## Configurando o TailwindCSS:

A aplicação já gera as visualizações com estilização, mas podemos melhorar um pouco mais, com isso, vamos instalar o [TailwindCSS](https://tailwindui.com/).
Link da documentação completa da instalação: [Guia para instalar o TailwindCSS no Ruby on Rails](https://tailwindcss.com/docs/guides/ruby-on-rails).

No terminal rode o seguinte comando para adicionar o TailwindCSS no projeto:

```bash
./bin/bundle add tailwindcss-rails
```

Rode o seguinte comando para instalar:

```bash
./bin/rails tailwindcss:install
```

## Rodando o servidor:

Após a instalação do TailwindCSS rode o projeto usando o seguinte comando:

```bash
./bin/dev
```

Crie o banco de dados, isso pode ser feito pela interface clicando no botão "Create database" ou pelo terminal:

```bash
rails db:migrate
```

