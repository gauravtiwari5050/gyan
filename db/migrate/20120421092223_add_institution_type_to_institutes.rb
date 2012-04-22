class AddInstitutionTypeToInstitutes < ActiveRecord::Migration
  def change
    add_column :institutes,:institution_type,:string
  end
end
