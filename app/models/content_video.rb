class ContentVideo < ActiveRecord::Base
  attr_accessible :branch,:course,:credits

  searchable do
    text :branch,:course,:credits
    text :topic,:boost => 5
  end
end
