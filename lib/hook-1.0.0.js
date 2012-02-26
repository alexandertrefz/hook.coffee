
/*
 * Hookjs JavaScript Event Library 1.0.0
 *
 * Copyright (c) 2011, Alexander Trefz
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
*/

(function() {
  var Event, Handle, NamespacedHandler, hook;

  Event = (function() {

    function Event(options) {
      if (options == null) options = {};
      this.eventName = options.eventName, this.isDefaultPrevented = options.isDefaultPrevented, this.isCancelled = options.isCancelled, this.isPropagationStopped = options.isPropagationStopped;
      if (this.eventName == null) this.eventName = "";
      if (this.isDefaultPrevented == null) this.isDefaultPrevented = false;
      if (this.isCancelled == null) this.isCancelled = false;
      if (this.isPropagationStopped == null) this.isPropagationStopped = false;
      if (typeof options === "string") this.eventName = options;
    }

    Event.prototype.preventDefault = function() {
      return this.isDefaultPrevented = true;
    };

    Event.prototype.cancel = function() {
      return this.isCancelled = true;
    };

    Event.prototype.stopPropagation = function() {
      return this.isPropagationStopped = true;
    };

    Event.prototype.hasNamespaces = function() {
      return !!~this.eventName.indexOf(".");
    };

    Event.prototype.getNamespaces = function() {
      var event, events, namespaces, results, _i, _len;
      events = this.eventName.split(" ");
      results = [];
      for (_i = 0, _len = events.length; _i < _len; _i++) {
        event = events[_i];
        namespaces = event.split(".");
        namespaces.shift();
        results = results.concat(namespaces);
      }
      return results;
    };

    Event.prototype.hasEventName = function() {
      if (this.getEventName() === "") {
        return false;
      } else {
        return true;
      }
    };

    Event.prototype.getEventName = function() {
      return this.eventName.split(".")[0];
    };

    return Event;

  })();

  NamespacedHandler = (function() {

    function NamespacedHandler(event, handler) {
      this.handler = handler;
      this.namespaces = event.getNamespaces();
      this.eventName = event.getEventName();
    }

    NamespacedHandler.prototype.matches = function(event) {
      var eventName, namespace, _i, _len, _ref;
      eventName = event.getEventName();
      if (!(eventName === this.eventName || eventName === "")) return false;
      _ref = event.getNamespaces();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        namespace = _ref[_i];
        if (!~_.indexOf(this.namespaces, namespace)) return false;
      }
      return true;
    };

    return NamespacedHandler;

  })();

  Handle = (function() {

    function Handle() {
      this.events = {};
      this.namespacedHandlers = [];
      this.namespacedEvents = [];
    }

    Handle.prototype._getEventsArr = function(event) {
      return this.events[event.eventName];
    };

    Handle.prototype._splitEvent = function(event, origArgs, methodName) {
      var args, eventName, _i, _len, _ref, _results;
      _ref = event.eventName.split(" ");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        eventName = _ref[_i];
        args = Array.prototype.slice.call(origArgs, 0);
        args[0] = new hook.Event(args[0]);
        args[0].eventName = eventName;
        _results.push(this[methodName].apply(this, args));
      }
      return _results;
    };

    Handle.prototype.addHandler = function(event, handler) {
      var eventArr, namespaces;
      if (~_.indexOf(event.eventName.split(""), " ")) {
        this._splitEvent(event, arguments, "addHandler");
        return;
      }
      if (!event.hasNamespaces()) {
        eventArr = this._getEventsArr(event);
        if (eventArr) {
          return eventArr.push(handler);
        } else {
          this.events[event.eventName] = [];
          return this.addHandler.apply(this, arguments);
        }
      } else {
        namespaces = event.getNamespaces();
        if (event.hasEventName()) this.namespacedEvents.push(event.getEventName());
        handler = new hook.NamespacedHandler(event, handler);
        return this.namespacedHandlers.push(handler);
      }
    };

    Handle.prototype.removeHandler = function(event, handler) {
      var eventArr, eventName, i, _results, _results2;
      if ((event != null) && ~_.indexOf(event.eventName.split(""), " ")) {
        this._splitEvent(event, arguments, "removeHandler");
        return;
      }
      if (!(event != null) && !(handler != null)) {
        this.namespacedHandlers = [];
        for (eventName in this.events) {
          this.events[eventName] = [];
        }
        return;
      }
      if (!event.hasNamespaces()) {
        if ((event != null) && (handler != null) && typeof handler === "function") {
          eventArr = this._getEventsArr(event);
          return eventArr != null ? eventArr.splice(_.indexOf(eventArr, handler), 1) : void 0;
        } else if ((event != null) && !(handler != null)) {
          return this.events[event.eventName] = [];
        }
      } else {
        if ((event != null) && (handler != null) && typeof handler === "function") {
          i = 0;
          _results = [];
          while (true) {
            if (this.namespacedHandlers[i].handler === handler) {
              this.namespacedHandlers.splice(i, 1);
            }
            i++;
            if (i >= this.namespacedHandlers.length) {
              break;
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        } else if ((event != null) && !(handler != null)) {
          i = 0;
          _results2 = [];
          while (true) {
            if (this.namespacedHandlers[i].matches(event)) {
              this.namespacedHandlers.splice(i, 1);
            }
            i++;
            if (i >= this.namespacedHandlers.length) {
              break;
            } else {
              _results2.push(void 0);
            }
          }
          return _results2;
        }
      }
    };

    Handle.prototype.triggerHandlers = function(obj, event, data) {
      var eventArr, handler, handlerArgs, _i, _j, _len, _len2, _ref, _results;
      if (data == null) data = [];
      if (~_.indexOf(event.eventName.split(""), " ")) {
        this._splitEvent(event, arguments, "triggerHandlers");
        return;
      }
      event.data = data;
      if (!_.isArray(data)) data = [data];
      handlerArgs = [event].concat(data);
      if (!event.hasNamespaces()) {
        eventArr = this._getEventsArr(event);
        if (eventArr != null) {
          for (_i = 0, _len = eventArr.length; _i < _len; _i++) {
            handler = eventArr[_i];
            handler.apply(obj, handlerArgs);
          }
        }
      }
      if (!event.hasEventName() || ~_.indexOf(this.namespacedEvents, event.getEventName())) {
        _ref = this.namespacedHandlers;
        _results = [];
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          handler = _ref[_j];
          if (handler.matches(event)) {
            _results.push(handler.handler.apply(obj, handlerArgs));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };

    return Handle;

  })();

  window.hook = hook = {
    Event: Event,
    NamespacedHandler: NamespacedHandler,
    Handle: Handle,
    _handles: [],
    _objects: [],
    _getHandleObject: function(obj) {
      var objectIndex;
      objectIndex = _.indexOf(hook._objects, obj);
      if (~objectIndex) {
        return hook._handles[objectIndex];
      } else {
        hook._objects.push(obj);
        return hook._getHandleObject(obj);
      }
    },
    event: {
      _checkEvent: function(event) {
        if (typeof event === "string") {
          event = new hook.Event({
            eventName: event
          });
        }
        return event;
      },
      add: function(obj, event, handler) {
        var handleObject;
        event = hook.event._checkEvent(event);
        handleObject = hook._getHandleObject(obj);
        if (handleObject != null) {
          return handleObject.addHandler(event, handler);
        } else {
          hook._handles[_.indexOf(hook._objects, obj)] = new hook.Handle();
          return hook.event.add.apply(hook, arguments);
        }
      },
      remove: function(obj, event, handler) {
        var handleObject;
        event = hook.event._checkEvent(event);
        handleObject = hook._getHandleObject(obj);
        if (handleObject != null) {
          return handleObject.removeHandler(event, handler);
        }
      },
      trigger: function(obj, event, data) {
        var handleObject;
        event = hook.event._checkEvent(event);
        handleObject = hook._getHandleObject(obj);
        if (handleObject != null) {
          return handleObject.triggerHandlers(obj, event, data);
        }
      }
    }
  };

}).call(this);
