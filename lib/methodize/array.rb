require 'methodize'
class Array
  def methodize!
    self.each do |v|
      v.extend(Methodize) if v.kind_of? Hash
    end
  end
end