class_name ObjectState extends Object

var node_id = 0
var node: Primitive
var object_type: ObjectType.ObjectType
var attributes: Attributes

func setup(nod: Primitive, attrs: Attributes):
	self.node_id = nod.get_instance_id()
	self.node= nod
	self.object_type = nod.object_type
	self.attributes  = attrs.duplicate()
	return self
	
func setup_from_node(nod: Primitive):
	self.node_id = nod.get_instance_id()
	self.node   = nod
	self.attributes = nod.attributes.duplicate()
	self.object_type = nod.object_type
	return self

func is_equal_to(state: ObjectState):
	if self.node == null or state.node == null:
		return false
	if state.node.get_instance_id() == self.node.get_instance_id() and state.attributes == self.attributes:
		return true
	return false

func go_here():
	if self.node == null:
		var instance = Editor.create_new_object_from_attributes(self.object_type, self.attributes)
		self.node_id = instance.get_instance_id()
		for state in UserInterface.SingleTon.undo_list:
			if state.node_id == self.node_id:
				state.node = instance
				state.node_id = instance.get_instance_id()
		return
	
	for attr: Attribute in self.attributes.get_attributes():
		self.node.set_attribute(attr.name, attr.value)

