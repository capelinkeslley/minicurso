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

Agora podemos definir no routes uma rota padrão para a aplicação direcionar o usuário quando estiver logado:

```ruby
devise_scope :user do
  ...
  authenticated do
    root "topics#index"
  end
end
```

Indo para a apresentação do Tópico. Adicione o seguinte trecho de código em `app/views/topics/_topic.html.erb`:

```ruby
<div id="<%= dom_id topic %>">
  <ul role="list" class="divide-y divide-gray-100">
    <li class="flex justify-between gap-x-6 py-5">
      <div class="flex min-w-0 gap-x-4">
        <div class="min-w-0 flex-auto">
          <p class="text-lg font-semibold text-gray-900"><%= topic.title %></p>
          <p class="text-sm/6 font-semibold text-xs/5 text-gray-900"><%= topic.user.email %></p>
          <p class="mt-1 truncate text-xs/5 text-gray-500"><%= topic.description %></p>
          <p class="mt-1 truncate text-xs/5 text-gray-500"><%= topic.is_private ? "Privado" : "" %></p>
        </div>
      </div>
    </li>
  </ul>
</div>
```

## Criar CRUD de Post

Agora seguindo com a criação do CRUD do Post que terá relação com o Topic.

Primeiro vamos usar o gerador do Rails para para criar a estrutura necessária para adicionarmos as regras necessárias.

```bash
rails generate scaffold post title:string content:text topic:references
```

Vamos validar a migração e na sequência "rodar" ela:

```bash
rails db:migrate
```

Com isso, podemos seguir criando as validações necessárias e definindo os relacionamentos.

No model `Post` em `app/models/post.rb` adicione o seguinte:

```ruby
...
  validates :title, :content, presence: true
end
```

No model `Topic` em `app/models/topic.rb` adicione o seguinte embaixo do `belongs_to`

```ruby
  ...
  has_many :posts, dependent: :destroy
```

No arquivo `test/models/post_test.rb` adicione os seguintes testes:

```ruby
...
test "the truth" do
  post = posts(:one)
  assert post.valid?
end

test "should not be valid without content" do
  post = posts(:one)
  post.content = nil

  assert_not post.valid?
end

test "should not be valid without topic" do
  post = posts(:one)
  post.topic = nil

  assert_not post.valid?
end
```

Agora vamos quebrar as coisas para criarmos rotas aninhadas.
No arquivo `config/routes.rb` altere isso:

```ruby
resources :posts
resources :topics
```

para:

```ruby
resources :topics do
  resources :posts
end
```

Com isso geramos rotas aninhadas, e também quebramos toda parte da aplicação relacionado com o Post.

No arquivo `app/controllers/posts_controller.rb` adicione as seguintes linhas de código:

Na linha 2:

```ruby
before_action :authenticate_user!
before_action :set_topic
```

Na linha 62, logo abaixo do `private`:

```ruby
def set_topic
  @topic = Topic.find(params.expect(:topic_id))
end
```

E na linha 68 altere o para isso:

```ruby
@post = @topic.posts.find(params.expect(:id))
```

Na linha 25 altere para isso:

```ruby
@post = @topic.posts.new(post_params)
```

Agora precisamos alterar as visualizações.

Acessando a rota `show` de um dos Tópicos e indo na url e alterarmos para: `http://localhost:3000/topics/1/posts`
poderemos acessar a rota index do Post, ou quase...

No arquivo `app/views/posts/index.html.erb` altere essa linha de código de:

```ruby
<%= link_to "New post", new_post_path, class: "rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium" %>
```

para:

```ruby
<%= link_to "New post", new_topic_post_path(@topic), class: "rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium" %>
```

Isso fará com que seja possível acessar a visualização index. E também com esse ajuste vamos poder acessar o visualizarção para criar um novo `Post`.

Clicando no "New post" vamos ser direcionados para a visualização de cadastro do Post. Porém...

Também precisamos aninhar a rota do formulário:

Altere isso:

```ruby
<%= form_with(model: post, class: "contents") do |form| %>
```

para:

```ruby
<%= form_with(model: [ @topic, post ], class: "contents") do |form| %>
```

Nos arquivos `app/views/posts/new.html.erb`, `app/views/posts/edit.html.erb`, `app/views/posts/show.html.erb` altere o seguinte trecho de:

```ruby
<%= link_to "Back to posts", posts_path, class: "ml-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

para:
```ruby
<%= link_to "Back to posts", topic_posts_path(@topic), class: "ml-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

Agora sim podemos acessar o formulário.

Agora vamos  conseguir criar Posts, porém teremos alguns problemas de redirecionamento. Com isos vamos precisar fazer algumas alterações:

Na linha 29 do arquivo `app/controllers/posts_controller.rb` adicione um array e adicione a ele o `@topic` e o `@post`:

```ruby
format.html { redirect_to [ @topic, @post ], notice: "Post was successfully created." }
```

Vamos aproveitar e alterar nas outras linhas, inclusive na linha 56:

```ruby
format.html { redirect_to topic_posts_path(@topic), status: :see_other, notice: "Post was successfully destroyed." }
```

Agora se tentarmos recarregar a tela, ou voltar para o index dos Posts teremos outro erro, para resolver isso basta apenas fazer a mesma coisa, mas agora dentro de
uma visualização:

```ruby
# app/views/posts/index.html.erb
<%= link_to "Show this post", [ @topic, post ], class: "ml-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

Clicando no botão "Show this Post" também teremos um erro, e para resolver basta acessar o arquivo `app/views/posts/show.html.erb` e alterar a linha 9 para:
```ruby
<%= link_to "Edit this post", edit_topic_post_path(@topic, @post), class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

Ainda no `show` altere a linha 12 para:

```ruby
<%= button_to "Destroy this post", [ @topic, @post ], method: :delete, class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 font-medium" %>
```

Agora vai funcionar, mas clicando no "Edit" também teremos problemas, mas para isso basta voltarmos para o arquivo `app/views/posts/edit.html.erb` e
alterar a linha 6 para:

```ruby
<%= link_to "Show this post", [ @topic, @post ], class: "ml-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

Com isso já é possível visualizar, editar, criar e remover Posts, mas os testes continuam falhando...

Para resolver vamos isso precisamos ajustar as rotas nos testes e adicionar o sign_in antes de cada chamada.

em `test/controllers/posts_controller_test.rb` faça o seguinte:
 encontre o `def setup` e nele adicione isso:

```ruby
setup do
  @post = posts(:one)
  @topic = @post.topic
  @user = @post.user
end
```

Se você está se perguntando "Como vamos acessar o user direto pelo @post se o Post não possui usuário?"
Exato, o Post não tem acesso, mas o Topic sim, e para acessar basta ir no model Post em `app/models/post.rb` e adicionar a seguinte linha embaixo no `belongs_to`:

```ruby
has_one :user, through: :topic
```

Isso faz com o que o Post consiga acessar o User através do Topic.

Agora antes de cada teste adicione o
```ruby
sign_in @user
```

e adéque as urls, por exemplo:
```ruby
get posts_url
```

para:
```ruby
get topic_posts_url(@topic)
``` 

Agora temos os testes passando.

```bash

Rebuilding...

Done in 274ms.
Running 22 tests in a single process (parallelization threshold is 50)
Run options: --seed 30485

# Running:

......................

Finished in 0.181536s, 121.1881 runs/s, 165.2565 assertions/s.
22 runs, 30 assertions, 0 failures, 0 errors, 0 skips
```

Temos quase tudo funcionando, mas ainda precisamos alterar a rota para acessar os Posts do Topic, para isso vamos adicionar um botão para facilitar o acesso:

No arquivo `app/views/topics/show.html.erb` adicione isso na linha 9:

```ruby
<%= link_to "Posts", topic_posts_path(@topic), class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

e no arquivo `app/views/posts/index.html.erb` adicione isso na linha 13 adicione o seguinte:

```ruby
<div class="mt-5 flex items-start">
  <%= link_to "Back to topic", topic_path(@topic), class: "rounded-lg py-3 px-5 bg-gray-100 block font-medium" %>
</div>
```

Também podemos alterar a exibição do Post para ele seguir o padrão do Topic, para isso, altere o arquivo `app/views/posts/_post.html.erb` para:

```ruby
<div id="<%= dom_id post %>">
  <ul role="list" class="divide-y divide-gray-100">
    <li class="flex justify-between gap-x-6 py-5">
      <div class="flex min-w-0 gap-x-4">
        <div class="min-w-0 flex-auto">
          <p class="text-lg font-semibold text-gray-900"><%= post.title %></p>
          <p class="mt-1 truncate text-xs/5 text-gray-500"><%= post.content %></p>
        </div>
      </div>
    </li>
  </ul>
</div>
```

E no bloco da linha 18 do arquivo `app/views/posts/index.html.erb` adicione isso:

```ruby
<% @posts.each do |post| %>
  <div class="flex justify-between">
    <%= render post %>
    <p>
      <%= link_to "Show this post", [ @topic, post ], class: "ml-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
    </p>
  </div>
<% end %>
```

Com isso temos a funcionalidade do Post integrada na nossa aplicação, mas ainda podemos melhorar...

## Adicionando o ActionText na aplicação

Que tal fazer com que o `content` do Post aceite textos em negrito, itálico e até scrips (rich text)?

Para isso vamos adicionar o [ActionText](https://edgeguides.rubyonrails.org/action_text_overview.html) no nosso projeto. No terminal rode:

```bash
rails action_text:install
```

Isso vai adicionar o ActionText e adicionar alguns arquivos inclusive migrations. Para isso vamos rodar as migrações:
```bash
rails db:migrate
```

Agora no model Post precisamos definir a coluna `rich text`, no nosso caso a `content`:

```ruby
 has_rich_text :content
```

E no `app/views/posts/_form.html.erb` precisamos alterar o `form.textarea` para: `form.rich_textarea`:
```ruby
<%= form.rich_textarea :content, rows: 4, class: "block shadow rounded-md border border-gray-400 outline-none px-3 py-2 mt-2 w-full" %>
```

A adição do ActionText alterou alguns arquivos de configuração, e com isso, precisamos parar a aplicação e iniciar ela novamente para "carregar"
as alterações.

Algumas alterações que podemos fazer no `app/views/posts/_post.html.erb`

```ruby
<div id="<%= dom_id post %>">
  <ul role="list" class="divide-y divide-gray-100">
    <li class="flex justify-between gap-x-6 py-5">
      <div class="flex min-w-0 gap-x-4">
        <div class="min-w-0 flex-auto">
          <p class="text-lg font-semibold text-gray-900"><%= post.title %></p>
          <% if action_name.eql?('show') %>
            <p class="mt-1 truncate text-xs/5 text-gray-500"><%= post.content %></p>
          <% else%>
          <p class="mt-1 truncate text-xs/5 text-gray-500"><%= distance_of_time_in_words(Post.last.created_at, Time.current) %></p>
          <% end %>
        </div>
      </div>
    </li>
  </ul>
</div>
```

## Adicionando algumas regras:

- Retornar para os usuários apenas os seus Topics e Topics públicos

No Model Topic vamos adicionar um scope:

```ruby
scope :accessible_by, ->(user) {
  where("is_private = false OR user_id = ?", user.id)
}
```

E no TopicsController:

```ruby
def index
  @topics = Topic.accessible_by(current_user)
end
```

```ruby
def set_topic
  @topic = Topic.accessible_by(current_user).find(params.expect(:id))
end
```

Também podemos bloquear alguns botões, por exemplo os botões de "Editar" e "Deletar"

No `app/views/topics/show.html.erb`:
```ruby
<%= link_to "Posts", topic_posts_path(@topic), class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>

<% if current_user.id.eql?(@topic.user_id) %>
  <%= link_to "Edit this topic", edit_topic_path(@topic), class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
  <div class="inline-block ml-2">
    <%= button_to "Destroy this topic", @topic, method: :delete, class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 font-medium" %>
  </div>
<% end %>

<%= link_to "Back to topics", topics_path, class: "ml-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

No index do controller do Post:

```ruby
def index
  @posts = @topic.posts
end
```

No `set_topic` do Post:

```ruby
def set_topic
  @topic = Topic.accessible_by(current_user).find(params.expect(:id))
end
```