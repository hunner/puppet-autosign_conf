require 'puppetx/filemapper'
require 'securerandom'

Puppet::Type.type(:autosign_conf).provide(:filemapper) do
  include PuppetX::FileMapper

  def self.target_files
    [Puppet[:autosign]]
  end

  def self.parse_file(filename, file_contents)
    lines = file_contents.split("\n")
    autosign_regex = %r/^([\*\w\d\.-]+)(\.([^\.\s]+))(\s+#\s*(.*))?$/
    lines.collect { |line| line.match(autosign_regex) }.compact.collect do |m|
      hash = Hash.new
      if m[3].length == 32
        hash[:name] = m[1]
        hash[:uuid] = :true
        hash[:uuid_value] = m[3]
      else
        hash[:name] = m[1] + m[2]
        hash[:uuid] = :false
      end
      hash[:comment] = m[5] || ""
      hash
    end
  end

  def select_file
    Puppet[:autosign]
  end

  def uuid_value=(value)
    raise Puppet::Error, "uuid_value is a read-only property"
  end

  def self.format_file(filename, providers)
    providers.collect do |provider|
      line = ""
      if provider.uuid == :true
        uuid_value = provider.uuid_value || SecureRandom.hex
        line += "#{provider.name}.#{uuid_value}"
      else
        line += "#{provider.name}"
      end
      line += " # #{provider.comment}" if provider.comment and ! provider.comment.empty?
      line += "\n"
    end.join
  end
end
