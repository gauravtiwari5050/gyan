class ObjectDestroyJob < Struct.new(:obj_type,:obj_id)
  def perform
    Object.const_get(obj_type).destroy(obj_id)
  end
end
