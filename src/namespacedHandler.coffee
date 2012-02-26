class NamespacedHandler
	constructor: ( event, @handler ) ->
		@namespaces = event.getNamespaces()
		@eventName = event.getEventName()
	
	
	matches: ( event ) ->
		eventName = event.getEventName()
		unless eventName is @eventName or eventName is ""
			return false
		
		for namespace in event.getNamespaces()
			return false unless ~_.indexOf @namespaces, namespace
		
		return true
	
