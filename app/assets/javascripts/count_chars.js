$(function() {
	$.fn.addCharCounter = function(options) {
		options = $.extend({
	    counterDisplay: '#counter',
	    countType: 'characters',
	    maxCount: 140,
	    strictMax: false,
	    countDirection: 'down',
	    safeClass: 'safe',
	    overClass: 'over',
	    thousandSeparator: ',',
	    onOverCount: function(){},
	    onSafeCount: function(){},
	    onMaxCount: function(){}
	  }, options);

	 // console.log("IN fn.addCharCounter. counterDisplay = " + options.counterDisplay);

	  var navKeys = [33,34,35,36,37,38,39,40];

	  return this.each( function() {
	    var $this = $(this);
	    var counterDisplay = $(options.counterDisplay);
	    
	    var checkCount = function() {
	    	var count;
	    	var revCount;

	    	//console.log("IN checkcount!!!")

	    	var reverseCount = function(lCount) {
	    		return lCount - (lCount*2) + options.maxCount;
	    	}

	    	var getCount = function() {
	    		return (options.countDirection === 'up') ? revCount : count;
	    	}

	    	var changeValue = function(val) {
	    		$this.val(val).trigger('change');
	    	}

	    	count = options.maxCount - $this.val().length;
	    	revCount = reverseCount(count);

	    	//console.log("Count = " + count);
	    	//console.log("recCount = " + revCount);

	    	/* If strictMax set restrict further characters */
	    	if (options.strictMax && count <= 0) {
	    		var content = $this.val();
	    		if (count < 0) {
	    			options.onMaxCount(getCount(), $this, counterDisplay);
	    		}
	    		if (options.countType === 'words'){
	    			var allowedText = content.match( new RegExp('\\s?(\\S+\\s+){'+ options.maxCount +'}') );
	    			if (allowedText) {
	    				changeValue(allowedText[0]);
	    			}
	    		}
	    		else { 
	    			changeValue(content.substring(0, options.maxCount)); 
	    		}
	    		count = 0, revCount = options.maxCount;
	    	}
        
        //console.log("About to update counderDisplay to: " + getCount());
        counterDisplay.text(getCount());

        /* set CSS classes and callbacks */
        if (!counterDisplay.hasClass(options.safeClass) && !counterDisplay.hasClass(options.overClass)) {
        	if (count < 0) {
        		counterDisplay.addClass(options.overClass);
        	}
        	else {
        		counterDisplay.addClass(options.safeClass);
        	}
        }
        else if (count < 0 && counterDisplay.hasClass(options.safeClass)) {
        	counterDisplay.removeClass(options.safeClass).addClass(options.overClass);
        	options.onOverCount(getCount(), $this, counterDisplay);
        }
        else if (count >= 0 && counterDisplay.hasClass(options.overClass)) {
        	counterDisplay.removeClass(options.overClass).addClass(options.safeClass);
        	options.onSafeCount(getCount(), $this, counterDisplay);
        }
      }; /* end checkCount */
	    
	    checkCount();

	    $this.on('keyup blur past', function(ev) {
	    	//console.log("In EVENT: " + ev.type);
	    	switch(ev.type) {
	    		case 'keyup':
	    		//skip over navigation keys
	    		if ($.inArray(ev.which, navKeys) < 0) {
	    			//console.log("About to checkCount");
	    			checkCount();
	    		}
	    		break;
	    		case 'paste':
	    		//Add small wait for paste
	    		setTimout(checkCount, (ev.type === 'paste' ? 5 : 0));
	    		break;
	    		default:
	    		checkCount();
	    		break;
	    	}
	    });

	});
    };

}(jQuery));