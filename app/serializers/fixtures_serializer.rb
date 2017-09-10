class FixturesSerializer < ActiveModel::Serializer
  attributes :overall_score

  def overall_score
    "Fixture updated."
  end
end
