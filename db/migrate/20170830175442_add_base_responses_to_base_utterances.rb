class AddBaseResponsesToBaseUtterances < ActiveRecord::Migration[5.1]
  def change
    add_reference :base_utterances, :base_response, foreign_key: true
  end
end
