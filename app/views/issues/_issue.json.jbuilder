json.extract! issue, :id, :Title, :Description, :Type, :Priority, :Status, :user_id, :asignee_id, :Votes, :Watchers, :at_name, :at_format, :at_size, :at_updated_at, :created_at, :updated_at
json.url issue_url(issue, format: :json)
