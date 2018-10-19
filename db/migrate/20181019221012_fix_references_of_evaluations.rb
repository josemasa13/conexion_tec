class FixReferencesOfEvaluations < ActiveRecord::Migration[5.2]
  def change
    remove_reference :evaluations, :professor, index:true, foreign_key:true
    add_reference :evaluations, :judge, index: true
  end
end
