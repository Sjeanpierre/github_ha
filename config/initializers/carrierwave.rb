S3_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'amazon_s3.yml'))[Rails.env]



CarrierWave.configure do |config|
  config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: S3_CONFIG["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: S3_CONFIG["AWS_SECRET_ACCESS_KEY"]
  }
  config.fog_directory = S3_CONFIG["AWS_S3_BUCKET"]
end

