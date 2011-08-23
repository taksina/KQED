public class ProductExportExt {
	public Id productId;
	
	public ProductExportExt(ApexPages.StandardController c) {
		this.productId = c.getId();
	}
	
	public Decimal StandardPrice {
		get {
			try {
				PricebookEntry pbe = [Select Id, UnitPrice From PricebookEntry Where Product2Id =: productId And Pricebook2.isStandard = true];
				Decimal standard_price = pbe.UnitPrice;
				return standard_price;
			} catch (System.QueryException e) {
				return 0;
			}
		}
	}
	
	private static testMethod void test_extension() {
		Product2 p = TestUtil.Products[0];
		ProductExportExt pext = new ProductExportExt(new ApexPages.StandardController(p));
		System.assert(pext.StandardPrice != null);
	}

/*


VF:

<apex:page standardController="Product2" extensions="ProductExportExt">
	{!StandardPrice}
</apex:page>
*/


}