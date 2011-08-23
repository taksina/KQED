public with sharing class ConvioDAO {

	private static final Integer DONATION_QUERY_BATCH_SIZE = 200;
	private static final String CONVIO_DATE_FMT = 'yyyy-MM-dd\'T\'HH:mm:ssZ'; //2009-10-21T01:10:16Z
	private WSConfig__c wsEndpoint = WSConfig__c.getAll().get('Convio');

	private ConvioWS.Soap getConnection() {
		System.debug('----- wsEndpoint:' + wsEndpoint);
		ConvioWS.Soap convio = new ConvioWS.Soap();
		if ( wsEndpoint.Endpoint__c != null && wsEndpoint.Endpoint__c != '' ) {
			convio.endpoint_x = wsEndpoint.Endpoint__c;
		}
		if ( wsEndpoint.Timeout__c != null && wsEndpoint.Timeout__c > 0) {
			convio.timeout_x = wsEndpoint.Timeout__c.intValue();
		}
		ConvioWS.LoginResult login = new ConvioWS.LoginResult();
		if(!Test.isRunningTest()) {
			login = convio.Login(wsEndpoint.Username__c, wsEndpoint.Password__c);
		}
		System.debug('login: ' + login);

		convio.Session = new ConvioWS.Session_element();
		convio.Session.SessionId = login.SessionId;
		return convio;
	}

	public List<ConvioObject.Donation> getDonationsByQuery(String query, Integer numberOfRecords) {
		List<ConvioObject.Donation> donations;
		if(Test.isRunningTest()) {
			donations = new List<ConvioObject.Donation>();
			donations.add(new ConvioObject.Donation(true));
		} else { 
			ConvioWS.Soap convio = getConnection();
			donations = (List<ConvioObject.Donation>) convio.Query(query, 1, numberOfRecords, 'Donation');
		}
		System.debug('donations: ' + donations);
		return donations;
	}

	public List<ConvioObject.Donation> getDonationsByModifiedDate(DateTime modifiedDate) {
		return getDonationsByModifiedDateRange(modifiedDate, null);
	}

	public List<ConvioObject.Donation> getDonationsByModifiedDateRange(DateTime startDate, DateTime endDate) {

		String query = 
			'select TransactionId, AdditionalAmount, FrequentFlyerMiles, FrequentFlyerAccountName, ' + 
				'Payment.Amount, Payment.PaymentDate, Payment.ModifyDate, Payment.BillingAddress, ' +
				'Donor.ConsId, Donor.ConsName, Donor.PrimaryEmail, Donor.HomePhone, ' +
				'InteractionSource.CodeType, InteractionSource.Code, InteractionSource.CodeText, ' +
				'Recognition.IsAnonymous, Recognition.TributeFirstName, Recognition.TributeLastName, ' +
				'Recognition.SenderName, Recognition.SenderAddress, ' +
				'RecurringPayment.Type, RecurringPayment.OriginalTransactionId, ' +
				'RecurringPayment.Frequency, RecurringPayment.Duration ' +
			'from Donation ';
		String queryWhere = '';
		if ( startDate != null ) {
			queryWhere += 'Payment.Modifydate >= ' + startDate.format(CONVIO_DATE_FMT);
		}
		
		if ( endDate != null ) {
			if ( queryWhere != '' ) {
				queryWhere += ' and ';
			}
			queryWhere += 'Payment.Modifydate <= ' + endDate.format(CONVIO_DATE_FMT);
		}
		if ( queryWhere != '' ) {
			query += 'where ' + queryWhere;
		}
		System.debug('query: ' + query);
		
		ConvioWS.Soap convio = getConnection();
		
		List<ConvioObject.Donation> donations = new List<ConvioObject.Donation>{}; 
		Boolean doCall = true;
		for ( Integer i = 1; doCall && i < 10; i++ ) {
			List<ConvioObject.Donation> donz;
			if(Test.isRunningTest()) {
				donz = new List<ConvioObject.Donation>();
				donz.add(new ConvioObject.Donation(true));
			} else {
				donz = (List<ConvioObject.Donation>) convio.Query(query, i, DONATION_QUERY_BATCH_SIZE, 'Donation');
			}
			
			//System.debug('donz: ' + donz);
			if ( doCall = (donz != null) ) {
				System.debug('iteration ' + i + ': ' + donz.size());
				donations.addAll(donz);
				doCall = donz.size() == DONATION_QUERY_BATCH_SIZE;
			}
		}
		System.debug('donations size: ' + donations.size());
		/*
		for ( ConvioObject.Donation d : donations ) {
			System.debug('Transaction ID: ' + d.TransactionId + ' - PaymentDate: ' + d.Payment.PaymentDate + ' - ModifyDate: ' + d.Payment.ModifyDate);
		}
		*/
		//System.debug('donations: ' + donations);
		return donations;
	}

	public List<ConvioObject.ProductOrder> getProductOrdersByModifiedDate(DateTime modifiedDate) {
		return getProductOrdersByModifiedDateRange(modifiedDate, null);
	}

	public List<ConvioObject.ProductOrder> getProductOrdersByModifiedDateRange(DateTime startDate, DateTime endDate) {

		/* FrequentFlyerMiles, FrequentFlyerAccountName, ' + 
				'Payment.Amount, Payment.PaymentDate, Payment.ModifyDate, Payment.BillingAddress, ' +
				'Donor.ConsId, Donor.ConsName, Donor.HomePhone, Donor.PrimaryEmail, ' +
				'InteractionSource.CodeText,
				*/
		String query = 
			'select OrderId, TransactionId, PurchaseAmount, Purchaser.ConsId, Purchaser.ConsName, ' +
				'ShipTo.Title, ShipTo.FirstName, ShipTo.LastName, ShipTo.Street1, ShipTo.Street2, ' +
				'ShipTo.City, ShipTo.Stateprov, ShipTo.Zip, ShipTo.Country, ' +
				'ShipTo.Item.ProductId, ShipTo.Item.ExternalIdentifier, ShipTo.Item.Config.Value, ShipTo.Item.Config.ConfigId ' +
			'from ProductOrder ';
		String queryWhere = '';
		if ( startDate != null ) {
			queryWhere += 'CreationDate >= ' + startDate.format(CONVIO_DATE_FMT);
		}
		if ( endDate != null ) {
			if ( queryWhere != '' ) {
				queryWhere += ' and ';
			}
			queryWhere += 'CreationDate <= ' + endDate.format(CONVIO_DATE_FMT);
		}
		if ( queryWhere != '' ) {
			query += 'where ' + queryWhere;
		}
		System.debug('query: ' + query);

		ConvioWS.Soap convio = getConnection();
		
		List<ConvioObject.ProductOrder> productOrders = new List<ConvioObject.ProductOrder>{};
		Boolean doCall = true;
		for ( Integer i = 1; doCall && i < 10; i++ ) {
			
			List<ConvioObject.ProductOrder> prodOrders;
			if(Test.isRunningTest()) {
				prodOrders = new List<ConvioObject.ProductOrder>();
				prodOrders.add(new ConvioObject.ProductOrder(true));
			} else {
				prodOrders = (List<ConvioObject.ProductOrder>) convio.Query(query, i, DONATION_QUERY_BATCH_SIZE, 'ProductOrder');
			}

			//System.debug('donz: ' + donz);
			if ( doCall = (prodOrders != null) ) {
				System.debug('iteration ' + i + ': ' + prodOrders.size());
				productOrders.addAll(prodOrders);
				doCall = prodOrders.size() == DONATION_QUERY_BATCH_SIZE;
			}
		}
		System.debug('productOrders size: ' + productOrders.size());
		//System.debug('productOrders: ' + productOrders);
		return productOrders;
	}
	
	public List<ConvioObject.Product> getProductsByProductIds(List<Integer> productIds) {
		List<ConvioObject.Product> products;
		if ( productIds != null && productIds.size() > 0) {
			String query = 
			'select ProductId, Title ' +
			'from Product ';
			
			String queryWhere = '';
			
			for (Integer pId : productIds) {
				if(queryWhere != '') queryWhere += ' or ';
				
				queryWhere += 'ProductId = ' + String.valueOf(pId);
			}
				
			if ( queryWhere != '' ) {
				query += 'where ' + queryWhere;
			}
			
			System.debug('query: ' + query); 
			
			ConvioWS.Soap convio = getConnection();
			
			products = new List<ConvioObject.Product>();
			Boolean doCall = true;
			for ( Integer i = 1; doCall && i < 10; i++ ) {
				List<ConvioObject.Product> prods;
				if(Test.isRunningTest()) {
					prods = new List<ConvioObject.Product>();
					prods.add(new ConvioObject.Product(true));
				} else {
					prods = (List<ConvioObject.Product>) convio.Query(query, i, DONATION_QUERY_BATCH_SIZE, 'Product');
				}

				//System.debug('donz: ' + donz);
				if ( doCall = (prods != null) ) {
					System.debug('iteration ' + i + ': ' + prods.size());
					products.addAll(prods);
					doCall = prods.size() == DONATION_QUERY_BATCH_SIZE;
				}
			}
			
		} else {
			products = new List<ConvioObject.Product>();
		}
		
		System.debug('products size: ' + products.size());
		return products;
	}

}