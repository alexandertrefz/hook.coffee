test "matches", ->
	
	event = new hook.Event("event.namespace")
	handler = new hook.NamespacedHandler event, ->
		
	
	
	equal handler.matches(new hook.Event("event")), true, "handler.matches \"event\" is true"
	equal handler.matches(new hook.Event(".namespace")), true, "handler.matches \".namespace\" is true"
	equal handler.matches(new hook.Event("event.namespace")), true, "handler.matches \"event\", \"namespace\" is true"
	equal handler.matches(new hook.Event(".nonamespace")), false, "handler.matches \"nonamespace\" is false"
	equal handler.matches(new hook.Event("event.nonamespace")), false, "handler.matches \"event\", \"nonamespace\" is false"
	equal handler.matches(new hook.Event("event.namespace.namespace2")), false, "handler.matches \"event\", \"namespace\", \"namespace2\" is false"

