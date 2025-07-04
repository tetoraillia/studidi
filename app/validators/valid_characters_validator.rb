class ValidCharactersValidator < ActiveModel::EachValidator
  VALID_CHARACTERS_REGEX = /\A[\w\s.,!?"'-]*\z/

  def validate_each(record, attribute, value)
    if value.present? && !(value =~ VALID_CHARACTERS_REGEX)
      record.errors.add(attribute, "contains invalid characters")
    end
  end
end
