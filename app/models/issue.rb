class Issue < ApplicationRecord
    belongs_to :user
    belongs_to :asignee, class_name: 'User', foreign_key: :asignee_id, optional: true
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :watchers, dependent: :destroy
    validates :Title, :Type, :Priority, :Status, presence: true
end
