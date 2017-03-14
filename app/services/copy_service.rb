class CopyService
  def initialize(interaction_name, hash)
    @interaction_name = interaction_name
    @context = hash_to_binding hash
  end

  def get_copy(key)
    erb = ERB.new get_erb(key)

    erb.result @context
  end

  def get_erb(key)
    sections = key.split '.'
    copy = get_interaction_yaml(@interaction_name)

    sections.each { |s| copy = copy[s] }

    # If there are multiple options, choose one at random.
    copy.respond_to?('each') ? copy.sample : copy
  end

  private

  def get_interaction_yaml(name)
    path = File.join(copy_route, "#{name}.yml")

    YAML.load File.read(path)
  end

  def copy_route
    Rails.root.join 'lib/data/copy/'
  end

  def hash_to_binding(hash)
    b = binding
    b.local_variable_set('info', hash)
    b
  end
end
