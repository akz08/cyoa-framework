require 'yaml'

env_file = File.join("config/environment_variables.yml")

if File.exists?(env_file)

	YAML.load_file(env_file)['development'].each do |key, value|
		ENV[key.to_s] = value
	end
end