class ResponseAttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  version :thumb, if: :image? do
    process resize_to_fit: [ 400, 400 ]
  end

  def image?(new_file)
    new_file.content_type.start_with?("image/")
  end

  def size_range
    0..5.megabytes
  end

  def validate_file_size
    if file.size > size_range.max
      errors.add(:file, "File size exceeds the limit of #{size_range.max}")
    end
  end

  protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
    end

    def default_url(*args)
      "/images/fallback/" + [ version_name, "default.png" ].compact.join("_")
    end

    def extension_allowlist
      %w[jpg jpeg gif png pdf doc docx]
    end
end
