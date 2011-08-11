	    window.onkeypress = handleKeyPress;
	    function handleKeyPress(e) {
		    var eventInstance = window.event ? event : e;	      
		    var keyCode = eventInstance.charCode ? eventInstance.charCode : eventInstance.keyCode;    
		    if (keyCode == 13){
		    	searchOpp();
		        return false;
		    }
	    }



	    function searchOpp() {
  	    	//debugger;  	    	
  	    	intSelectedItemsCount = 0;
  	    	selectunSelectHeaderCheckbox(false);  	    	
  	    	
			afSearchOpp();
    	}                            

    	
    	function cancel() {
    		selectunSelectHeaderCheckbox(false);
    		afCancel();
    	}    	
    	    	
    	function getShipmentsSize() {
    		//debugger;
    		var shipmentsSize = parseFloat(document.getElementById("selectedItemsId").getElementsByTagName('label')[0].innerHTML);
    		return shipmentsSize;
    	}
    	
    	function selectAllOrNoneByCheckbox(control) {
    		//debugger;
            idString = 'pageId:formId:pbOrders:pgblkSearchResult:';
            var shipmentSize = getShipmentsSize();
            for(i=0;i < shipmentSize;i++) {
                if(document.getElementById(idString + i + ':selected') != null && document.getElementById(idString + i + ':selected').disabled == false)
                	document.getElementById(idString + i + ':selected').checked = control.checked;
            }
            
            if (control.checked == true)
            	intSelectedItemsCount = shipmentSize;
            else
            	intSelectedItemsCount = 0;	
    	}
    	    	
    	function CheckUncheckFacet(control) {
	        if(!control.checked) {
	        	intSelectedItemsCount = intSelectedItemsCount - 1;	        	
	        	selectunSelectHeaderCheckbox(false);
	        } else {
	        	intSelectedItemsCount = intSelectedItemsCount + 1;
	        	setHeaderCheckBox(0);
	        }
    	}
    	
    	function selectunSelectHeaderCheckbox(value) {
    		var control = document.getElementById("pageId:formId:pbOrders:pgblkSearchResult:selectall");
    		if(control != null) 
    			control.checked = value;
    	}
    	
	    function setHeaderCheckBox(setCurrentPageCount) {
	    	//debugger;
	    	var shipmentSize = getShipmentsSize();
	    	
	    	if (shipmentSize == intSelectedItemsCount)
	    		selectunSelectHeaderCheckbox(true);
	    	else
	    		selectunSelectHeaderCheckbox(false);	    			    	
	    }