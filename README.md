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

## Adicionando a gem Devise para autenticação (e muito mais):

Segue a documentação da gem: [Gem Devise](https://github.com/heartcombo/devise?tab=readme-ov-file#getting-started)

Para adicionar a gem no projeto, rode o seguinte comando no terminal:

```bash
bundle add devise
```

Instalando a gem:

```bash
rails generate devise:install
```

Gerando a autenticação para o model User:

```bash
rails generate devise User
```

Rodando a migração para criar a tabela no banco de dados:

```bash
rails db:migrate
```

## Vamos por a mão na massa, definindo qual rota o usuário deve ser direcionado caso não esteja logado:

Adicione isso dentro do `config/routes.rb`
```ruby
  ...
  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
```

MUITO IMPORTANTE!
Pare o servidor e inicie ele novamente. Alguns arquivos de configuração foram adicionados, e o RoR não faz o reload desses arquivos.

Rodando o servidor novamente, recarregue a tela. Agora é possível adicionar um novo usuário através do "Sign Up" ou fazer login se já ter um usuário cadastrado.

