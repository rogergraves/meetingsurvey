class AddHstore < ActiveRecord::Migration
  def up
    enable_extension :hstore
    # add_column :meetings, :repeat_rule, :hstore
  end

  def down
    disable_extension :hstore
    # remove_column :meetings, :repeat_rule
  end

  # def change
  #   # add_column :meetings, :repeat_rule, :hstore
  #   add_column :meetings, :uid, :string
  #   add_index :meetings, :uid, unique: true
  # end
end

# class AddFieldsToMeetings < ActiveRecord::Migration
#   def up
#     enable_extension :hstore
#     add_column :meetings, :repeat_rule, :hstore
#   end
#
#   def down
#     disable_extension :hstore
#     remove_column :meetings, :repeat_rule
#   end
#
#   # def change
#   #   # add_column :meetings, :repeat_rule, :hstore
#   #   add_column :meetings, :uid, :string
#   #   add_index :meetings, :uid, unique: true
#   # end
# end
