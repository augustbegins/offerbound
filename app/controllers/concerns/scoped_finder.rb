module ScopedFinder
  extend ActiveSupport::Concern

  private
  
  def find_scoped!(relation, id:)
    relation.find(id)
  end 
end 
