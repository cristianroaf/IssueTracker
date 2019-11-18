class Issue < ApplicationRecord
    belongs_to :user
    belongs_to :asignee, class_name: 'User', foreign_key: :asignee_id, optional: true
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :watchers, dependent: :destroy
    validates :Title, :Type, :Priority, :Status, presence: true
    
    has_attached_file :attachment, styles: { medium: "300x300>", thumb: "100x100>" },
        :storage => :cloudinary,
        :path => 'issues/:id/:filename',
        :cloudinary_resource_type => :raw 
        
    def self.status
        ["New", "Open", "On hold", "Resolved", "Duplicate", "Invalid", "Won't fix", "Closed"]
    end
    def self.type
        ["Bug", "Enhancement", "Proposal", "Task"]
    end
    def self.priority
        ["Trivial", "Minor", "Major", "Critical", "Blocker"]
    end
    
    do_not_validate_attachment_file_type :attachment
    
end
