	    window.onkeypress = handleKeyPress;
	    function handleKeyPress(e) {
		    var eventInstance = window.event ? event : e;	      
		    var keyCode = eventInstance.charCode ? eventInstance.charCode : eventInstance.keyCode;    
		    if (keyCode == 13){
		    	registerCampaign();
		        return false;
		    }
	    }



		function registerCampaign() {
			
			debugger;
			
			var foundError = false;
			_errorMember = document.getElementById("errorMember");
			_errorFName = document.getElementById("errorFName");
			_errorLName = document.getElementById("errorLName");
			_errorEmail = document.getElementById("errorEmail");
			_errorGuests = document.getElementById("errorGuests");
			
			if (document.getElementById("pageId:formId:pbId:memberId").value == "") { _errorMember.innerHTML = "Error: You must enter a value"; foundError = true;} else _errorMember.innerHTML = "";
			if (document.getElementById("pageId:formId:pbId:FirstNameId").value == "") { _errorFName.innerHTML = "Error: You must enter a value"; foundError = true;} else _errorFName.innerHTML = "";
			if (document.getElementById("pageId:formId:pbId:LastNameId").value == "") { _errorLName.innerHTML = "Error: You must enter a value"; foundError = true;} else _errorLName.innerHTML = "";
			
			if (document.getElementById("pageId:formId:pbId:EmailId").value == "") { 
				_errorEmail.innerHTML = "Error: You must enter a value"; 
				foundError = true;
			} else {
				_errorEmail.innerHTML = "";
				
				if (!isValidEmail(document.getElementById("pageId:formId:pbId:EmailId").value)) {
					_errorEmail.innerHTML = "You must enter a valid Email Address";
					foundError = true;
				}
			}	
			
			var noofGuests = parseFloat(document.getElementById("pageId:formId:pbId:noOfGuestsId").value);
			if (isNaN(noofGuests)) {
				_errorGuests.innerHTML = "Error: You must enter a valid number"; 
				foundError = true;
			} else {
				_errorGuests.innerHTML = "";				
				if (noofGuests <=0 || noofGuests > 2) {
					_errorGuests.innerHTML = "Error: You must enter either one or two Guests"; 
					foundError = true;
				}
			}			
			
			if (!foundError) {
				afRegister();
			}
		}
		
		function isValidEmail(emailAddress) {
			var atpos = emailAddress.indexOf("@");
			var dotpos = emailAddress.lastIndexOf(".");
			if (atpos<1 || dotpos<atpos+2 || dotpos+2>=emailAddress.length) {
			  return false;
			}
			return true;
		}