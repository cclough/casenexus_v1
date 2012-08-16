class ChangeColumnContentInPostsToText < ActiveRecord::Migration
	def change
		remove_column :posts, :content
		add_column :posts, :content, :text
	end
end
