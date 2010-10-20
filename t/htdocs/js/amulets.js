function sizeAmulets() {

	var bottom = YAHOO.util.Dom.getXY('find_bottom')[1];
		
	var el = new YAHOO.util.Element('left-column');
	var images = el.getElementsByClassName('amulet_image', 'img');
	var depth = 0;
	for(var i = 0; i < images.length; i++) {
		var image_id = 'amulet_'+(i+1);
		var new_depth = YAHOO.util.Dom.getXY(image_id)[1];
		var image = new YAHOO.util.Element(image_id);
		if (!new_depth && depth <= bottom) {
			image.removeClass('hide');
			new_depth = YAHOO.util.Dom.getXY(image_id)[1];
		}
		if (new_depth && depth <= bottom) {
			depth = new_depth;
		}
		/* alert(depth); */
		if (depth > bottom) {
			image.addClass('hide');
		}
	}
}


YAHOO.util.Event.onContentReady('yui-main', sizeAmulets); 

