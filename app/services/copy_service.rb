class CopyService
  def initialize(conversation_name, hash)
    @conversation_name = conversation_name
    @context = hash_to_binding hash
  end

  def get_copy(key)
    sections = key.split '.'
    copy = get_conversation(@conversation_name)

    sections.each { |s| copy = copy[s] }

    # Are there multiple copy options for us to choose from? If there is, pick
    # one at random and spit it out.
    if copy.respond_to? 'each'
      return copy.sample
    end

    copy
  end

  private

  def get_conversation(name)
    path = File.join(copy_route, "#{name}.yml")
    copy = ERB.new(File.read path).result @context

    YAML.load(copy)
  end

  def copy_route
    "#{Rails.root}/lib/data/copy/"
  end

  def hash_to_binding(hash)
    b = binding
    b.local_variable_set("info", hash)
    b
  end
end
