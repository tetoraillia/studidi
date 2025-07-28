class MakeResponsesPolymorphic < ActiveRecord::Migration[8.0]
  def change
    add_reference :responses, :responseable, polymorphic: true, index: true
  end
end
