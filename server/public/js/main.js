var slideUpSpeed = 400;
var items = '';
var errorTime;
var hasError;
var checkTimeInterval;
var tester;
var storedItems = [];
var getItemsRaw;

$(function() {
	$('a[href="' + window.location.pathname + '"]').parents('.nav li').addClass('active');
	
	switch(window.location.pathname) {
		case '/live-manage':
			loadLiveManage();
		break;
		
		case '/shown':
			loadShown();
		break;
		
		case '/all':
			loadAll();
		break;
	}
});







function loadAll() {
	checkAllItems(-1);
	
	$('#shown-list li').live('mouseenter', function() {
		$(this).children('.remove:not(.gone)').show();
	});
	$('#shown-list li').live('mouseleave', function() {
		$(this).children('.remove:not(.gone)').hide();
	});
	$('li[data-item-id] .btn-danger').live('click', function() {
		var main = $(this).parents('li[data-item-id]');
		console.log(main);
		$('li[data-item-id="' + $(main).data('itemId') + '"]').find('.remove').addClass('gone').html('');
		removeItem($(main).data('itemId'));
		$.ajax({
			'url': '/remove-items',
			'type': 'POST',
			'data': {
				'items': $(main).data('itemId')
			},
			'success': function(data) {
				//console.log(data);
			}
		});
	});
}

function checkAllItems(lastid) {
	$.ajax({
		url: '/get-items?lastid=' + lastid + '&app=manage',
		'success': function(data) {
			//data = $.parseJSON(data.replace(/[\n\r\t]+/g, ' '));
			for (var i in data.items) {
				//storedItems.reverse();
				if (lastid==-1) {
					storedItems.push(data.items[i]);	
				} else {
					storedItems = [data.items[i]].concat(storedItems);
				}
				//storedItems.reverse();
			}
			resetShownThumbs();
			checkAllItems(data.lastid);
		},
		error: function(data) {
			errorTime = new Date();
			setTimeout(function(){checkAllItems(lastid)}, 1000);
			if (!hasError) {
				alertError();
				checkTimeInterval = setInterval(checkIfError, 1000);
			}
		}
	})
}















function loadShown() {
	checkShownItems(-1);
	
	$('#shown-list li').live('mouseenter', function() {
		$(this).children('.remove:not(.gone)').show();
	});
	$('#shown-list li').live('mouseleave', function() {
		$(this).children('.remove:not(.gone)').hide();
	});
	$('li[data-item-id] .btn-danger').live('click', function() {
		var main = $(this).parents('li[data-item-id]');
		$('li[data-item-id="' + $(main).data('itemId') + '"]').find('.remove').addClass('gone').html('');
		removeItem($(main).data('itemId'));
		$.ajax({
			'url': '/remove-items',
			'type': 'POST',
			'data': {
				'items': $(main).data('itemId')
			},
			'success': function(data) {
				//console.log(data);
			}
		});
	});
}

function checkShownItems(lastid) {
	$.ajax({
		'url': '/get-shown?lastid=' + lastid + '&app=shown',
		'success': function(data) {
			//data = $.parseJSON(data.replace(/[\n\r\t]+/g, ' '));
			for (var i in data.items) {
				//storedItems.reverse();
				if (lastid==-1) {
					storedItems.push(data.items[i]);	
				} else {
					storedItems = [data.items[i]].concat(storedItems);
				}
				//storedItems.reverse();
			}
			resetShownThumbs();
			checkShownItems(data.lastid);
		},
		'error': function(data) {
			errorTime = new Date();
			setTimeout(function(){checkShownItems(lastid)}, 1000);
			if (!hasError) {
				alertError();
				checkTimeInterval = setInterval(checkIfError, 1000);
			}
		}
	});
}

function resetShownThumbs() {
	var row;
	$('#shown-list').html('');
	for (var i in storedItems) {
		if (i%5==0) {
			row = $('#shown-list').append('<ul class="row"></ul>');
		}
		var html;
		if (storedItems[i].image) {
			html = '<img src="' + storedItems[i].image + '" />';
		} else {
			html = '<p>' + storedItems[i].text + '</p>';
		}
		var remove;
		if (storedItems[i].approved == '1') {
			remove = '<div class="remove"><div class="btn btn-danger">Remove</div></div>';
		} else {
			remove = '<div class="remove gone">&nbsp;</div>';
		}
		$(row).append('<li class="span2" data-item-id="' + storedItems[i].id + '">' + remove + html + '</li>');
	}
}










function loadLiveManage() {
	checkNewItems(-1, -1);
	var a = setInterval(checkTime, 1000);
	
	$('li[data-item-id] .btn-danger').live('click', function() {
		var main = $(this).parents('li[data-item-id]');
		$(main).addClass('remove').slideUp(slideUpSpeed);
		$(main).find('.progress').addClass('progress-danger');
		$(main).find('.bar').width($(this).parents('li[data-item-id]').find('.bar').width());
		removeItem($(main).data('itemId'));
	});
	
	$('li[data-item-id] .btn-success').live('click', function() {
		$(this).parents('li[data-item-id]').find('.progress').addClass('progress-success');
		$(this).parents('li[data-item-id]').addClass('remove').slideUp(slideUpSpeed);
	});
}


function removeItem(id) {
	for (i in storedItems) {
	  if (storedItems[i].id == id) {
	    storedItems[i].approved = -1;
	  }
	}
	$.ajax({
		'url': '/remove-items',
		'type': 'POST',
		'data': {
			'items': id
		},
		'success': function(data) {
			//console.log(data);
		}
	});
}











function checkTime() {
  $('li[data-item-id]').each(function() {
    if (!$(this).hasClass('remove')) {
	    var perc = ((new Date().getTime() - $(this).data('add-time'))/1000)*10;
	    $(this).find('.bar').width(perc + '%');
	    if (perc >= 101) {
	      $(this).find('.progress').addClass('progress-success');
	      //$(this).find('.btn').removeClass('btn-danger').addClass('btn-success').html('Approved');
	      $(this).slideUp(slideUpSpeed);
	    }
	}
  });
}

function checkNewItems(lastid) {
	$.ajax({
		url: '/live-manage-longpoll?lastid=' + lastid + '&app=manage',
		success: function(data) {
			//data = $.parseJSON(data.replace(/[\n\r\t]+/g, ' '));
			if (data.items) {
				for (item in data.items) {
					var img = '';
					if (data.items[item].image) {
						img = '<div class="span4"><img src="' + data.items[item].image + '" class="img-rounded"></div>';
					} else {
						img = '<div class="span4">&nbsp;</div>';
					}
					var text = data.items[item].text;
					if (!text) {
						text = '&nbsp';
					}
					$('.item-list').append('<li data-item-id="' + data.items[item].id + '" data-add-time="' + new Date().getTime() + '">\
				      <div class="row">\
						  ' + img + '\
						  <div class="span6 content">' + text + '</div>\
						  <div class="span2"><a href="#" class="btn btn-success">Approve</a><a href="#" class="btn btn-danger">Remove</a></div>\
						</div>\
						<div class="row countdown-progress-bar">\
							<div class="span12 progress progress-striped active">\
							  <div class="bar" style="width: 0%;"></div>\
							</div>\
						</div>\
				      </li>');
				    
				 };
			 }
			 lastid = data.lastid;
			 checkNewItems(data.lastid)
		},
		error: function(data) {
			errorTime = new Date();
			setTimeout(function(){checkNewItems(lastid)}, 1000);
			if (!hasError) {
				alertError();
				checkTimeInterval = setInterval(checkIfError, 1000);
			}
		}
	})
}

function checkLiveItems(lastid) {
	$.ajax({
		url: '/get-items?lastid=' + lastid + '&app=manage',
		success: function(data) {
			getItemsRaw = data;
			//data = $.parseJSON(data.replace(/[\n\r\t]+/g, ' '));
			if (data.items) {
				for (item in data.items) {
					console.log(data.items[item].text);
				 };
			 }
			 lastid = data.lastid;
			 checkLiveItems(data.lastid)
		},
		error: function(data) {
			errorTime = new Date();
			setTimeout(function(){checkLiveItems(lastid)}, 1000);
			if (!hasError) {
				alertError();
				checkTimeInterval = setInterval(checkIfError, 1000);
			}
		}
	})
}

function alertSuccess() {
	hasError = false;
	if ($('#alert-holder .alert-error').length) {
		$('#alert-holder .alert-error').remove();
	}
	if (!$('#alert-holder .alert-success').length) {
		$('#alert-holder').append('<div class="alert alert-success">\
			  <button type="button" class="close" data-dismiss="alert">x</button>\
			  <h4>And we\'re back!</h4>\
			  Things have a way of working themselves out.\
			</div>');
	}
}

function checkIfError() {
	if (new Date() - errorTime > 3000) {
		alertSuccess();
		errorTime = '';
		clearInterval(checkTimeInterval);
	}
}

function alertError() {
	hasError = true;
	if ($('#alert-holder .alert-success').length) {
		$('#alert-holder .alert-success').remove();
	}
	if (!$('#alert-holder .alert-error').length) {
		$('#alert-holder').append('<div class="alert alert-error">\
			  <h4>Yikes!</h4>\
			  Seems like something is wrong with the system. Wait a sec, or refresh the page.\
			</div>');
	}
}