AWS_CONFIGS = YAML.load_file("#{Rails.root.to_s}/config/aws_configs.yml")[Rails.env]
