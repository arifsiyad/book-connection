class ActiveForm # :nodoc:
  def initialize(attributes = nil)
    if attributes
      attributes.each do |key,value|
        send(key.to_s + '=', value)
      end
    end
    yield self if block_given?
  end
  
  def [](key)
    instance_variable_get("@#{key}")
  end
  
  def method_missing(method_id, *args)
    if md = /_before_type_cast$/.match(method_id.to_s)
      attr_name = md.pre_match
      return self[attr_name] if self.respond_to?(attr_name)
    end
    super
  end
  
  def new_record?
    true
  end
  
  #--
  # Protected Methods
  #++
  protected
  
  class << self
    def raise_not_implemented_error(*params)
      raise NotImplementedError
    end
    
    alias validates_uniqueness_of raise_not_implemented_error
    alias create! raise_not_implemented_error
    alias validate_on_create raise_not_implemented_error
    alias validate_on_update raise_not_implemented_error
    alias save_with_validation raise_not_implemented_error
  end
  
  def raise_not_implemented_error(*params)
    ValidatingModel.raise_not_implemented_error(*params)
  end
  
  def self.human_attribute_name(attribute_key_name)
    attribute_key_name.humanize
  end
  
  alias save raise_not_implemented_error
  alias update_attribute raise_not_implemented_error
  alias save! raise_not_implemented_error
  
  #--
  # Public Methods
  #++
  public
  
  include ActiveRecord::Validations
end