class Video < ActiveRecord::Base
	belongs_to :category
	validates :title, presence: true
	validates :description, presence: true


	def search_by_title(search_param)
		string = "%" + search_param + "%"
		Video.where("title LIKE '#{string}'")
	end
end