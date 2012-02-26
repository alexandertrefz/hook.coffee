class Handle
	constructor: () ->
		@events = {}
		@namespacedHandlers = []
		@namespacedEvents = []
	
	
	_getEventsArr: (event) ->
		@events[event.eventName]
	
	
	_splitEvent: (event, origArgs, methodName) ->
		for eventName in event.eventName.split " "
			args = Array::slice.call origArgs, 0
			args[0] = new hook.Event args[0]
			args[0].eventName = eventName
			@[methodName].apply @, args
		
	
	
	addHandler: (event, handler) ->
		# Split for IE7
		if ~_.indexOf event.eventName.split(""), " "
			@_splitEvent event, arguments, "addHandler"
			return
		
		unless event.hasNamespaces()
			eventArr = @_getEventsArr event
			if eventArr
				eventArr.push handler
			else
				@events[event.eventName] = []
				@addHandler.apply @, arguments
		else
			namespaces = event.getNamespaces()
			@namespacedEvents.push event.getEventName() if event.hasEventName()
			handler = new hook.NamespacedHandler event, handler
			@namespacedHandlers.push handler
		
	
	
	removeHandler: (event, handler) ->
		# Split for IE7
		if event? and ~_.indexOf event.eventName.split(""), " "
			@_splitEvent event, arguments, "removeHandler"
			return
		
		if not event? and not handler?
			@namespacedHandlers = []
			@events[eventName] = [] for eventName of @events
			return
			
		unless event.hasNamespaces()
			if event? and handler? and typeof handler is "function"
				eventArr = @_getEventsArr event
				eventArr?.splice(_.indexOf(eventArr, handler), 1)
			else if event? and not handler?
				@events[event.eventName] = []
		else
			if event? and handler? and typeof handler is "function"
				i = 0
				loop 
					if @namespacedHandlers[i].handler is handler
						@namespacedHandlers.splice(i, 1)
					i++
					if i >= @namespacedHandlers.length
						break
			else if event? and not handler?
				i = 0
				loop
					if @namespacedHandlers[i].matches event
						@namespacedHandlers.splice(i, 1)
					i++
					if i >= @namespacedHandlers.length
						break
			
	
	
	triggerHandlers: (obj, event, data = []) ->
		# Split for IE7
		if ~_.indexOf event.eventName.split(""), " "
			@_splitEvent event, arguments, "triggerHandlers"
			return
		
		event.data = data
		
		unless _.isArray(data)
			data = [data]
		
		handlerArgs = [event].concat data
		
		unless event.hasNamespaces()
			eventArr = @_getEventsArr event
		
			if eventArr?
				for handler in eventArr
					handler.apply obj, handlerArgs
		
		if not event.hasEventName() or ~_.indexOf(@namespacedEvents, event.getEventName())
			for handler in @namespacedHandlers
				if handler.matches event
					handler.handler.apply obj, handlerArgs
	
