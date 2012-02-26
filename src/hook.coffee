window.hook = hook = {
	
	Event
	
	NamespacedHandler
	
	Handle
	
	_handles: []
	
	_objects: []
	
	_getHandleObject: (obj) ->
		objectIndex = _.indexOf hook._objects, obj
		
		if ~objectIndex
			hook._handles[objectIndex]
		else
			hook._objects.push obj
			hook._getHandleObject obj
		
	
	
	event: {
		
		_checkEvent: (event) ->
			if typeof event is "string"
				event = new hook.Event { eventName: event }
			return event
		
		
		add: (obj, event, handler) ->
			event = hook.event._checkEvent event
			
			handleObject = hook._getHandleObject obj
			
			if handleObject?
				handleObject.addHandler event, handler
			else
				hook._handles[_.indexOf(hook._objects, obj)] = new hook.Handle()
				hook.event.add.apply hook, arguments
			
		
		
		remove: (obj, event, handler) ->
			event = hook.event._checkEvent event
			
			handleObject = hook._getHandleObject obj
			
			if handleObject?
					handleObject.removeHandler event, handler
			
		
		
		trigger: (obj, event, data) ->
			event = hook.event._checkEvent event
			
			handleObject = hook._getHandleObject obj
			
			if handleObject?
				handleObject.triggerHandlers obj, event, data
			
		
	
	}

}
