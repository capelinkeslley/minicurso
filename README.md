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

## CRUD de Tópicos

Seguindo com a aplicação, vamos criar o CRUD de tópicos. Para isso use o gerador `scaffold`

```bash
rails generate scaffold topic title:string description:string is_private:boolean user:references
```

Isso vai gerar tudo o que precisamos para trabalhar com os tópicos.

- Rode a migração.

Em `models/topic.rb` adicione as validações necessárias:

```ruby
...
validates :title, :description, presence: true
```

No arquivo `models/user.rb` defina o relacionamento entre Topic e User:

```ruby
has_many :topics, dependent: :destroy
```

Isso quer dizer que o User pode ter muitos Topics e se o usuário for destruído os tópicos também serão destruídos.

Seguindo para os testes:

Em `test/fixtures/users.yml` adicione o seguinte código:

```yml
one:
  email: "user@example.com"

two:
  email: "another_user@example.com"
```

E em `test/fixtures/topics.yml`:
```yml
one:
  title: MyString
  description: MyString
  user: one
  is_private: false

two:
  title: MyString
  description: MyString
  user: two
  is_private: false
```

Em `test/models/topic_test.rb`:
```ruby
 test "the truth" do
    topic = topics(:one)
    assert topic.valid?
  end

  test "should not be valid without title" do
    topic = topics(:one)
    topic.title = nil

    assert_not topic.valid?
  end

  test "should not be valid without description" do
    topic = topics(:one)
    topic.description = nil

    assert_not topic.valid?
  end

  test "should not be valid without user" do
    topic = topics(:one)
    topic.user = nil

    assert_not topic.valid?
  end
```

Rode os testes:

```bash
rails test
```

Todos os testes estão passando?!

Adicionando autenticação no `TopicsController`
Adicione a `before_action` no controller:

```ruby
class TopicsController < ApplicationController
  before_action :authenticate_user!
  ....
```

Agora rode os testes novamente...

O teste não está realizando a autenticação antes de fazer a request, e por isso está quebrando. Vamos resolver isso:

Para isso vá para o arquivo dos testes que estão quebrando:
`test/controllers/topics_controller_test.rb`

Carregue uma instância de usuário no setup, definindo como uma variável global:

```ruby
  setup do
    @user = users(:one)
    @topic = topics(:one)
  end
```

E antes de todas as chamadas de request adicione o `sign_in`:
```ruby
  test "should get index" do
    sign_in @user

    get topics_url
    assert_response :success
  end
```

Isso ainda não vai funcionar, vamos precisar incluir uma classe para isso funcionar, para isso, abra o arquivo `test/test_helper.rb`
e na linha 7 adicione isso:

```ruby
include Devise::Test::IntegrationHelpers
```

Agora sim, rode os testes novamente. Todos passaram?

