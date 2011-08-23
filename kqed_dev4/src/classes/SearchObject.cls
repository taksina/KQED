/* -------------------------------------------------------------------------------------
* searchObject: Product Search Results Wrapper Class
* - Used by the SelectProductController and SelectProductOppExtension Classes
* - Main purpose is to return a LIST of Products along with a custom checkbox that can 
*   be used to let the user select which rows to be added.
*  ------------------------------------------------------------------------------------- */

public with sharing class SearchObject {
	
	public String id 						  	{get; set;}
	public String mode 				  		  	{get; set;}
	public boolean selected 				  	{get; set;}	
	public boolean renderCheckbox				{get; set;}
	public Product2 prod						{get; set;}
	public Purchase_Order_Product__c POProduct 	{get; set;}		
	
	// Constructors
	public searchObject() { }
	public searchObject(Product2 p) {
		renderCheckbox = true;
		init(p);
	}
	public searchObject(Product2 p, boolean isSelected) {
		renderCheckbox = true;
		init(p);
		selected = isSelected;
	}
	public searchObject(Product2 p, Purchase_Order_Product__c pop) {
		renderCheckbox = true;
		prod = p;
		POProduct = pop;
		if (pop != null) id = pop.Id;
	}
		
	private void init(Product2 p) {
		renderCheckbox = true;
		prod = p;
		if (POProduct == null) POProduct = new Purchase_Order_Product__c();
	}
	
	public searchObject(SObject so, String m) {
		mode = m;
		renderCheckbox = true;
		if (mode == 'po') {
			prod = (Product2)so;
			init(prod);			
		}
	}
	
	public searchObject(SObject so, String m, boolean isSelected) {		
		renderCheckbox = true;
		if (mode == 'po') {
			prod = (Product2)so;
			init(prod);
		}		
		selected = isSelected;
	}
}