test "namespace", ->
	ok hook.Event?, "hook.Event exists"
	ok hook.NamespacedHandler?, "hook.NamespacedHandler exists"
	ok hook.Handle?, "hook.Handle exists"
	ok hook.event?, "hook.event exists"


test "#hook.event.add(obj, event)", ->
	# cleanup potentially altered global objects
	hook._objects = []
	hook._handles = []
	
	obj = {}
	hook.event.add obj, "event", ->
	
	
	equal hook._objects.length, 1
	equal hook._objects[0], obj
	equal hook._handles.length, 1


test "#hook.event.remove(obj, [[event], [handler]])", ->
    expect 0
	# this method straight up only gets the handle and calls .removeHandler, so there are no DRY tests to do


test "#hook.event.trigger(obj, event, handler)", ->
	obj = {}
	data = {}
	event = new hook.Event {
		eventName: "event"
	}
	
	hook.event.add obj, event, (e, passedData) ->
		equal e, event, "event gets passed correctly"
		equal data, passedData, "data gets passed correctly"
	
	
	hook.event.trigger obj, event, [data]

