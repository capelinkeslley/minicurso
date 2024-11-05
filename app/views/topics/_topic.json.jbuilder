json.extract! topic, :id, :title, :description, :is_private, :user_id, :created_at, :updated_at
json.url topic_url(topic, format: :json)
