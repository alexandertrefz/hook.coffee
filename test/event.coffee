test "#constructor(options)", ->
	event = new hook.Event()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is false, "event.isDefaultPrevented is false"
	ok event.isCancelled is false, "event.isCancelled is false"
	ok event.isPropagationStopped is false, "isPropagationStopped is false"
	
	event = new hook.Event {
		eventName: "customEvent"
		isDefaultPrevented: true
		isCancelled: true
		isPropagationStopped: true
	}
	
	ok event.eventName is "customEvent", "event.eventName is customEvent"
	ok event.isDefaultPrevented is true, "event.isDefaultPrevented is true"
	ok event.isCancelled is true, "event.isCancelled is true"
	ok event.isPropagationStopped is true, "isPropagationStopped is true"


test "#preventDefault()", ->
	event = new hook.Event()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is false, "event.isDefaultPrevented is false"
	ok event.isCancelled is false, "event.isCancelled is false"
	ok event.isPropagationStopped is false, "isPropagationStopped is false"
	
	event.preventDefault()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is true, "event.isDefaultPrevented is true"
	ok event.isCancelled is false, "event.isCancelled is false"
	ok event.isPropagationStopped is false, "isPropagationStopped is false"


test "#cancel()", ->
	event = new hook.Event()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is false, "event.isDefaultPrevented is false"
	ok event.isCancelled is false, "event.isCancelled is false"
	ok event.isPropagationStopped is false, "isPropagationStopped is false"
	
	event.cancel()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is false, "event.isDefaultPrevented is false"
	ok event.isCancelled is true, "event.isCancelled is true"
	ok event.isPropagationStopped is false, "isPropagationStopped is false"


test "#stopPropagation()", ->
	event = new hook.Event()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is false, "event.isDefaultPrevented is false"
	ok event.isCancelled is false, "event.isCancelled is false"
	ok event.isPropagationStopped is false, "isPropagationStopped is false"
	
	event.stopPropagation()
	
	ok event.eventName is "", "event.eventName is \"\""
	ok event.isDefaultPrevented is false, "event.isDefaultPrevented is false"
	ok event.isCancelled is false, "event.isCancelled is false"
	ok event.isPropagationStopped is true, "isPropagationStopped is true"


test "#hasNamespaces()", ->
	event = new hook.Event()
	
	event.eventName = "event"
	equal event.hasNamespaces(), false, "event has no namespaces"
	
	event.eventName = "event.namespace"
	equal event.hasNamespaces(), true, "event has namespaces"


test "#getNamespaces()", ->
	event = new hook.Event()
	
	event.eventName = "event"
	deepEqual event.getNamespaces(), [], "event has no namespaces"
	
	event.eventName = "event.namespace"
	deepEqual event.getNamespaces(), ["namespace"], "event has namespace: \"namespace\""
	
	event.eventName = "event.namespace.namespace2"
	deepEqual event.getNamespaces(), ["namespace", "namespace2"], "event has namespace: \"namespace\", \"namespace2\""
	
	event.eventName = ".namespace.namespace2"
	deepEqual event.getNamespaces(), ["namespace", "namespace2"], "event has namespace: \"namespace\", \"namespace2\""


test "#hasEventName()", ->
	event = new hook.Event()
	event.eventName = "event"
	
	equal event.hasEventName(), true
	
	event.eventName = "event.namespace"
	
	equal event.hasEventName(), true
	
	event.eventName = ".namespace"
	
	equal event.hasEventName(), false


test "#getEventName()", ->
	event = new hook.Event()
	event.eventName = "event"
	
	equal event.getEventName(), event.eventName
	
	event.eventName = "event.namespace"
	
	equal event.getEventName(), "event"
	
	event.eventName = "event.namespace.namespace2"
	
	equal event.getEventName(), "event"
	
	event.eventName = ".namespace"
	
	equal event.getEventName(), ""

