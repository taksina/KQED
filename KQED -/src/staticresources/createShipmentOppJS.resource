
      window.onkeypress = handleKeyPress;

      function handleKeyPress(e) {
	       var eventInstance = window.event ? event : e;
	       //alert('entering key enter');
	       var keyCode = eventInstance.charCode ? eventInstance.charCode : eventInstance.keyCode;    
	       if (keyCode == 13) {
	           afcreateShipment();
	           return false;
	       }
      }


	    function checkQuantity(control, row) {
	    	debugger;
	    	
	    	var number = parseFloat(control.value);
	    	if ( isNaN(number) || number < 0) {
	    		alert('Ship Qty must be greater than zero.');
	    		control.value = 0;	    		
	    	} else if (number > 0) {	    		
	    		if (row.cells[0].getElementsByTagName("input")[0].checked == false) {
	    			row.cells[0].getElementsByTagName("input")[0].checked = true;
	    			CheckUncheckFacet(row.cells[0].getElementsByTagName("input")[0]);
	    		}
	    	}
	    }
    	
    	function getShipmentsSize(control) {
    		debugger;
    		
    		idStringCount = control.name;
    		position = idStringCount.indexOf('repeatId:');
    		positionNew = idStringCount.indexOf(':',position+9+1);
    		idStringCount = idStringCount.substr(0,positionNew)+':selectedItemsId';

			var shipmentsSize = parseFloat(document.getElementById(idStringCount).innerHTML);
    		//var shipmentsSize = 200;
    		return shipmentsSize;
    	}
    	
    	function getSelectedItemsCountControl(control) {
    		debugger;    		
    		idStringCount = control.name;
    		position = idStringCount.indexOf('repeatId:');
    		positionNew = idStringCount.indexOf(':',position+9+1);
    		
    		idStringCount = idStringCount.substr(0,positionNew)+':selectedItemsCount';

			return document.getElementById(idStringCount);			
    	}
    	
    	function getSelectedItemsCountValue(control) {
			return parseFloat(getSelectedItemsCountControl(control).value);
    	}
    	
    	function setSelectedItemsCountValue(control, value) {
			getSelectedItemsCountControl(control).value = value;
    	}
    	
    	function incrementSelectedItemsCountValue(control, increment) {
    		c = getSelectedItemsCountControl(control);
    		c.value = parseFloat(c.value) + increment;
    	}    	
    	
    	function selectAllOrNoneByCheckbox(control) {
    		debugger;    		

    		idString = control.name;
    		position = idString.indexOf('pgblkSearchResult:');
    		idString = idString.substr(0,position+18);
            
            var shipmentSize = getShipmentsSize(control);
            for(i=0;i < shipmentSize;i++) {
                if(document.getElementById(idString + i + ':selected') != null && document.getElementById(idString + i + ':selected').disabled == false)
                	document.getElementById(idString + i + ':selected').checked = control.checked;
            }
            
            if (control.checked == true)            	
            	setSelectedItemsCountValue(control, shipmentSize); 
            else            	
            	setSelectedItemsCountValue(control, 0);
    	}
    	    	
    	function CheckUncheckFacet(control) {
    		debugger;
	        if(!control.checked) {	        	
	        	incrementSelectedItemsCountValue(control, -1);
	        	selectunSelectHeaderCheckbox(control, false);
	        } else {	        	
	        	incrementSelectedItemsCountValue(control, 1);
	        	setHeaderCheckBox(control, 0);
	        }
    	}    	    
    	
    	function selectunSelectHeaderCheckbox(control, value) {    		
    		debugger;
    		idString = control.name;
    		position = idString.indexOf('pgblkSearchResult:');
    		idString = idString.substr(0,position+18)+'selectAll';
    		
    		var control = document.getElementById(idString);
    		if(control != null) {
    			control.checked = value;
    		}
    	}
    	
	    function setHeaderCheckBox(control,setCurrentPageCount) {	    	
	    	var shipmentSize = getShipmentsSize(control);
	    		    	
	    	if (shipmentSize == getSelectedItemsCountValue(control))
	    		selectunSelectHeaderCheckbox(control,true);
	    	else
	    		selectunSelectHeaderCheckbox(control,false);
	    }
