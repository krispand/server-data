var DragTable = function () {
    return {
        //main function to initiate the module
        init: function () {
			$('.dragtable-sample tbody').sortable({
				items:'tr',
				axis: 'y',
				start: function(){
				},
				stop: function (event, ui) {
					order = [];
					i = 0;
					strtype = '';
					$(this).children('tr').each(function(idx, elm) {
					  i++;
					  order.push(elm.id.split('_')[1]+'|'+i);
					  strtype = elm.id.split('_')[0];
					});  
					
					// GET to server using $.ajax
					$.ajax({
						type: 'GET',
						url: 'reorder.php?order='+order.join(',')+'&type='+ strtype 
					});
				}
			});	
        }
    };
}();