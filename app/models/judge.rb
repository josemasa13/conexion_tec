class Judge < ApplicationRecord
	belongs_to :user
	validates :user, presence: true
	validates :department, presence: true
	validates :name, presence: true
	has_and_belongs_to_many :expertise_areas
	has_many :evaluations

	has_many :evaluations
	has_many :projects, through: :evaluations

	enum department: [
		"Tecnologías de Información",
		"Historia",
		"Química"
	]

	scope :with_no_projects, -> { 
		joins("left join evaluations e on judges.id = e.judge_id")
		.where("e.id is null")
	}
end
