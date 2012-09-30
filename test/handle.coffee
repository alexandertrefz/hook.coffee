test "#constructor(options)", ->
	handle = new hook.Handle()
	
	deepEqual handle.events, {}, "handle.events is {}"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"


test "#addHandler(event, handler)", ->
	handle = new hook.Handle()
	
	event = new hook.Event {
		eventName: "customEvent"
	}
	
	handler1 = ->
		
	
	
	handler2 = ->
		
	
	
	handle.addHandler event, handler1
	
	ok Array.isArray(handle.events.customEvent), "Array.isArray(handle.events.customEvent)"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"
	equal handle.events.customEvent.length, 1, "handle.events.customEvent.length is 1"
	equal handle.events.customEvent[0], handler1, "handle.events.customEvent[0] is handler1"
	
	handle.addHandler event, handler2
	
	ok Array.isArray(handle.events.customEvent), "Array.isArray(handle.events.customEvent)"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"
	equal handle.events.customEvent.length, 2, "handle.events.customEvent.length is 2"
	equal handle.events.customEvent[0], handler1, "handle.events.customEvent[0] is handler1"
	equal handle.events.customEvent[1], handler2, "handle.events.customEvent[1] is handler2"
	
	
	handle = new hook.Handle()
	
	event.eventName = "customEvent customEvent2"
	handle.addHandler event, handler1
	
	ok Array.isArray(handle.events.customEvent), "Array.isArray(handle.events.customEvent)"
	ok Array.isArray(handle.events.customEvent2), "Array.isArray(handle.events.customEvent2)"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"
	equal handle.events.customEvent.length, 1, "handle.events.customEvent.length is 1"
	equal handle.events.customEvent[0], handler1, "handle.events.customEvent[0] is handler1"
	equal handle.events.customEvent2.length, 1, "handle.events.customEvent2.length is 1"
	equal handle.events.customEvent2[0], handler1, "handle.events.customEvent2[0] is handler1"
	
	
	handle = new hook.Handle()
	
	event.eventName = "customEvent.namespace"
	
	handle.addHandler event, handler1
	
	deepEqual handle.events, {}, "handle.events is {}"
	ok Array.isArray(handle.namespacedHandlers), "Array.isArray(handle.namespacedHandlers)"
	deepEqual handle.namespacedHandlers[0], new hook.NamespacedHandler(event, handler1), "handle.namespacedHandlers[0] is a NamespacedHandler with event.getNamespaces() and handler1"
	


test "#removeHandler()", ->
	handle = new hook.Handle()
	
	event = new hook.Event {
		eventName: "customEvent"
	}
	
	handler1 = ->
		
	
	
	handler2 = ->
		
	
	
	handle.addHandler event, handler1
	handle.removeHandler event, handler1
	
	deepEqual handle.events, {customEvent: []}, "handle.events is {customEvent: []}"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"
	
	handle.addHandler event, handler1
	
	handle.removeHandler()
	
	deepEqual handle.events, {customEvent: []}, "handle.events is {customEvent: []}"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"


test "#removeHandler(event)", ->
	handle = new hook.Handle()
	
	event = new hook.Event {
		eventName: "customEvent"
	}
	
	handler1 = ->
		
	
	
	handler2 = ->
		
	
	
	event.eventName = "customEvent customEvent2"
	
	handle.addHandler event, handler1
	
	handle.removeHandler event
	
	deepEqual handle.events, {customEvent: [], customEvent2: []}, "handle.events is {customEvent: [], customEvent2: []}"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"
	
	event.eventName = "customEvent.namespace"
	
	handle.addHandler event, handler1
	handle.removeHandler event
	
	deepEqual handle.events, {customEvent: [], customEvent2: []}, "handle.events is {customEvent: [], customEvent2: []}"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"


test "#removeHandler(event, handler)", ->
	handle = new hook.Handle()
	
	event = new hook.Event {
		eventName: "customEvent"
	}
	
	handler1 = ->
		
	
	
	handler2 = ->
		
	
	
	handle.addHandler event, handler1
	handle.addHandler event, handler2
	handle.removeHandler event, handler1
	
	ok Array.isArray(handle.events.customEvent), "Array.isArray(handle.events.customEvent)"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"
	equal handle.events.customEvent.length, 1, "handle.events.customEvent.length is 1"
	equal handle.events.customEvent[0], handler2, "handle.events.customEvent[0] is handler2"
	
	
	handle.removeHandler event, handler2
	
	deepEqual handle.events, {customEvent: []}, "handle.events is {customEvent: []}"
	deepEqual handle.namespacedHandlers, [], "handle.namespacedHandlers is []"


test "#triggerHandlers(event)", () ->
	obj = {}
	
	event = new hook.Event {
		eventName: "customEvent"
	}
	
	data = {}
	
	handle = new hook.Handle()
	
	handler1 = (e) ->
		ok true, "handler1 run"
		equal e, event, "event got correctly passed"
	
	
	handler2 = (e, passedData) ->
		handler1 e, passedData
		equal data, passedData, "data got correctly passed"
	
	
	
	handle.addHandler event, handler1
	
	handle.triggerHandlers obj, event
	
	handle.addHandler event, handler1
	
	handle.triggerHandlers obj, event
	
	handle.removeHandler event
	
	handle.addHandler event, handler2
	
	handle.triggerHandlers obj, event, [data]
	
	handle.removeHandler()
	
	handle.addHandler event, handler1
	
	event.eventName = "customEvent.namespace"
	
	handle.addHandler event, handler1
	
	handle.triggerHandlers obj, event
	
	event.eventName = "customEvent"
	
	handle.triggerHandlers obj, event
	
	event.eventName = "customEvent.namespace.namespace2"
	
	handle.addHandler event, handler1
	
	event.eventName = "namespace.namespace2"
	
	handle.triggerHandlers obj, event
	
	# check that a unnamespaced event can trigger a namespaced handler
	# even if the unnamespaced event was never registered
	
	event.eventName = "event.namespace"
	
	handle = new hook.Handle()
	
	handle.addHandler event, handler1
	
	event.eventName = "event"
	
	handle.triggerHandlers obj, event

