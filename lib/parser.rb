module Parser
  def self.lines(day, type, version = "")
    File.readlines("#{type}/#{day}#{version}.txt", chomp: true)
  end

  def self.read(day, type, version = "")
    File.read("#{type}/#{day}#{version}.txt")
  end
end
