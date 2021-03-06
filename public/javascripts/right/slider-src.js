/**
 * RightJS UI Slider unit
 * http://rightjs.org/ui/slider
 *
 * Copyright (C) 2009-2010 Nikolay Nemshilov
 */
var Slider = RightJS.Slider = (function(document, Math, RightJS) {
/**
 * This module defines the basic widgets constructor
 * it creates an abstract proxy with the common functionality
 * which then we reuse and override in the actual widgets
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */

/**
 * The filenames to include
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */
var R       = RightJS,
    $       = RightJS.$,
    $$      = RightJS.$$,
    $w      = RightJS.$w,
    $E      = RightJS.$E,
    $A      = RightJS.$A,
    isHash  = RightJS.isHash,
    Element = RightJS.Element;






/**
 * The widget units constructor
 *
 * @param String tag-name or Object methods
 * @param Object methods
 * @return Widget wrapper
 */
function Widget(tag_name, methods) {
  if (!methods) {
    methods = tag_name;
    tag_name = 'DIV';
  }

  /**
   * An Abstract Widget Unit
   *
   * Copyright (C) 2010 Nikolay Nemshilov
   */
  var AbstractWidget = new RightJS.Wrapper(RightJS.Element.Wrappers[tag_name] || RightJS.Element, {
    /**
     * The common constructor
     *
     * @param Object options
     * @param String optional tag name
     * @return void
     */
    initialize: function(key, options) {
      this.key = key;
      var args = [{'class': 'rui-' + key}];

      // those two have different constructors
      if (!(this instanceof RightJS.Input || this instanceof RightJS.Form)) {
        args.unshift(tag_name);
      }
      this.$super.apply(this, args);

      if (RightJS.isString(options)) {
        options = RightJS.$(options);
      }

      // if the options is another element then
      // try to dynamically rewrap it with our widget
      if (options instanceof RightJS.Element) {
        this._ = options._;
        if ('$listeners' in options) {
          options.$listeners = options.$listeners;
        }
        options = {};
      }
      this.setOptions(options, this);
      return this;
    },

  // protected

    /**
     * Catches the options
     *
     * @param Object user-options
     * @param Element element with contextual options
     * @return void
     */
    setOptions: function(options, element) {
      element = element || this;
      RightJS.Options.setOptions.call(this,
        RightJS.Object.merge(options, eval("("+(
          element.get('data-'+ this.key) || '{}'
        )+")"))
      );
      return this;
    }
  });

  /**
   * Creating the actual widget class
   *
   */
  var Klass = new RightJS.Wrapper(AbstractWidget, methods);

  // creating the widget related shortcuts
  RightJS.Observer.createShortcuts(Klass.prototype, Klass.EVENTS || []);

  return Klass;
}


/**
 * Same as the assignable, only it doesn't work with popups
 * instead it simply updates the assigned unit value/content
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */
var Updater = {

  /**
   * Assigns the unit to work with an input element
   *
   * @param mixed element reference
   * @return Rater this
   */
  assignTo: function(element) {
    var assign  = R(function(element, event) {
      if ((element = $(element))) {
        element[element.setValue ? 'setValue' : 'update'](event.target.getValue());
      }
    }).curry(element);

    var connect = R(function(element, object) {
      element = $(element);
      if (element && element.onChange) {
        element.onChange(R(function() {
          this.setValue(element.value());
        }).bind(object));
      }
    }).curry(element);

    if ($(element)) {
      assign({target: this});
      connect(this);
    } else {
      $(document).onReady(R(function() {
        assign({target: this});
        connect(this);
      }.bind(this)));
    }

    return this.onChange(assign);
  }
};


/**
 * RightJS UI Slider unit
 *
 * Copyright (C) 2009-2010 Nikolay Nemshilov
 */
var Slider = new Widget({
  include: Updater,

  extend: {
    version: '2.0.0',

    EVENTS: $w('change'),

    Options: {
      min:       0,     // the min value
      max:       100,   // the max value
      snap:      0,     // the values threshold
      value:     null,  // start value, if null then the min value will be used
      direction: 'x',   // slider direction 'x', 'y'
      update:    null,  // reference to an element to update
      round:     0      // the number of symbols after the decimal pointer
    },

    current: false
  },

  /**
   * basic constructor
   * USAGE:
   *   new Slider('element-id'[, {options}]);
   *   new Slider({options});
   *
   * @param mixed slider element reference or options
   * @param Object options
   */
  initialize: function() {
    var args = $A(arguments).compact(), options = args.pop(), element = args.pop();

    // figuring out the arguments
    if (!isHash(options) || options instanceof Element) {
      element = $(element || options);
      options = {};
    }

    this.$super('slider', element).setOptions(options)
      .on('selectstart', 'stopEvent'); // disable select under IE

    this.level  = this.first('.level')  || $E('div', {'class': 'level'}).insertTo(this);
    this.handle = this.first('.handle') || $E('div', {'class': 'handle'}).insertTo(this);

    options = this.options;
    this.value = options.value === null ? options.min : options.value;

    if (options.update) { this.assignTo(options.update); }
    if (options.direction === 'y') { this.addClass('rui-slider-vertical'); }
    else if (this.hasClass('rui-slider-vertical')) { options.direction = 'y'; }

    this.setValue(this.value);
  },

  /**
   * The value setter
   *
   * NOTE: will get snapped according to the options
   *
   * @param mixed string or number value
   * @return Slider this
   */
  setValue: function(value) {
    return this.precalc().shiftTo(value);
  },

  /**
   * Returns the value
   *
   * @return Float number
   */
  getValue: function() {
    return this.value;
  },

  /**
   * Inserts the widget into the element
   *
   * @param mixed element reference
   * @param String optional position
   * @return Slider this
   */
  insertTo: function(element, position) {
    return this.$super(element, position).setValue(this.value);
  },

// protected

  // precalculates dimensions, direction and offset for further use
  precalc: function() {
    var horizontal  = this.options.direction === 'x',
        handle      = this.handle.setStyle(horizontal ? {left: 0} : {bottom: 0}).dimensions(),
        handle_size = this.hSize = horizontal ? handle.width : handle.height,
        dims        = this.dims  = this.dimensions();

    this.offset = horizontal ? handle.left - dims.left : dims.top + dims.height - handle.top - handle_size;
    this.space  = (horizontal ? dims.width - handle_size - this.offset * 2 : dims.height - handle_size) - this.offset * 2;

    return this;
  },

  // initializes the slider drag
  start: function(event) {
    return this.precalc().e2val(event);
  },

  // processes the slider-drag
  move: function(event) {
    return this.e2val(event);
  },

  // shifts the slider to the value
  shiftTo: function(value) {
    var options = this.options, base = Math.pow(10, options.round), horizontal = options.direction === 'x';

    // rounding the value up
    value = Math.round(value * base) / base;

    // checking the value constraings
    if (value < options.min) { value = options.min; }
    if (value > options.max) { value = options.max; }
    if (options.snap) {
      var snap = options.snap;
      var diff = value % snap;
      value = diff < snap/2 ? value - diff : value - diff + snap;
    }

    // calculating and setting the actual position
    var position = this.space / (options.max - options.min) * (value - options.min);

    this.handle._.style[horizontal ? 'left' : 'bottom'] = position + 'px';
    this.level._.style[horizontal  ? 'width': 'height'] = ((position > 0 ? position : 0) + 2) + 'px';

    // checking the change status
    if (value !== this.value) {
      this.value = value;
      this.fire('change', {value: value});
    }

    return this;
  },

  // converts the event position into the actual value in terms of the slider measures
  e2val: function(event) {
    var options = this.options, horizontal = options.direction === 'x',
        dims    = this.dims, offset = this.offset, space = this.space,
        cur_pos = event.position()[horizontal ? 'x' : 'y'] - offset - this.hSize/2,
        min_pos = horizontal ? dims.left + offset : dims.top + offset,
        value   = (options.max - options.min) / space * (cur_pos - min_pos);

    return this.shiftTo(horizontal ? options.min + value : options.max - value);
  }
});


/**
 * Document onReady hook for sliders
 *
 * Copyright (C) 2009-2010 Nikolay Nemshilov
 */
$(document).on({
  // preinitializing the sliders
  ready: function() {
    $$('.rui-slider').each(function(element) {
      if (!(element instanceof Slider)) {
        element = new Slider(element);
      }
    });
  },

  // initiates the slider move
  mousedown: function(event) {
    var slider = event.find('.rui-slider');
    if (slider) {
      event.stop();
      if (!(slider instanceof Slider)) {
        slider = new Slider(slider);
      }
      Slider.current = slider.start(event);
    }
  },

  // handles the slider move
  mousemove: function(event) {
    if (Slider.current) {
      Slider.current.move(event);
    }
  },

  // handles the slider release
  mouseup: function(event) {
    if (Slider.current) {
      Slider.current = false;
    }
  }
});

$(window).onBlur(function() {
  if (Slider.current) {
    Slider.current = false;
  }
});


document.write("<style type=\"text/css\">div.rui-slider,div.rui-slider .handle div.rui-slider .level{margin:0;padding:0;border:none;background:none}div.rui-slider{height:0.4em;width:20em;border:1px solid #bbb;background:#F8F8F8;border-radius:.2em;-moz-border-radius:.2em;-webkit-border-radius:.2em;position:relative;margin:.6em 0;display:inline-block; *display:inline; *zoom:1;vertical-align:middle;user-select:none;-moz-user-select:none;-webkit-user-select:none;cursor:pointer}div.rui-slider .handle{font-size:25%;position:absolute;left:0;top:0;width:4pt;height:4em;margin-top:-1.6em;margin-left:0.4em;background:#BBB;border:1px solid #999;border-radius:.8em;-moz-border-radius:.8em;-webkit-border-radius:.8em;z-index:20}div.rui-slider .level{font-size:25%;position:absolute;top:0;left:0;width:0;height:100%;background:#ddd;z-index:1}div.rui-slider-vertical{height:10em;width:0.4em;margin:0 .3em}div.rui-slider-vertical .handle{top:auto;bottom:0;margin:0;margin-left:-1.6em;margin-bottom:0.4em;height:4pt;width:4em}div.rui-slider-vertical .level{height:0;width:100%;top:auto;bottom:0}</style>");

return Slider;
})(document, Math, RightJS);
