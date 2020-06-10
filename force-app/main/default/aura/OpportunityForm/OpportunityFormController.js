({
	onInit: function(cmp, event, helper) {
		var actions = [
			{ label: "Show details", name: "show_details" },
			{ label: "Delete", name: "delete" },
			{ label: "ProductShow", name: "products" },
			{ label: "Create Product", name: "createproduct" }
		];
		cmp.set("v.mycolumns", [
			{
				label: "Opportunity Name",
				fieldName: "Name",
				type: "text",
				sortable: true,
				cellAttributes: { alignment: "left" }
			},
			{
				label: "StageName",
				fieldName: "StageName",
				type: "text",
				sortable: true,
				cellAttributes: { alignment: "left" }
			},
			{
				label: "Amount",
				fieldName: "Amount",
				type: "currency",
				sortable: true,
				cellAttributes: { alignment: "left" }
			},
			{
				label: "Expected Revenue",
				fieldName: "ExpectedRevenue",
				type: "currency",
				sortable: true,
				cellAttributes: { alignment: "left" }
			},
			{
				label: "Close Date",
				fieldName: "CloseDate",
				type: "date",
				sortable: true,
				typeAttributes: {
					weekday: "long",
					year: "numeric",
					month: "long",
					day: "2-digit"
				},
				cellAttributes: { alignment: "left" }
			},
			{
				label: "Type",
				fieldName: "Type",
				type: "text",
				sortable: true,
				cellAttributes: { alignment: "left" }
			},
			// Other column data here
			{
				type: "action",
				typeAttributes: { rowActions: actions, menuAlignment: "left" }
			}
		]),
			cmp.set("v.mycolumnsoppline", [
				{
					label: "Product Name",
					fieldName: "Name",
					type: "text",
					sortable: true,
					cellAttributes: { alignment: "left" }
				},
				{
					label: "Product Code",
					fieldName: "ProductCode",
					type: "text",
					sortable: true,
					cellAttributes: { alignment: "left" }
				},
				{
					label: "Quantity",
					fieldName: "Quantity",
					type: "currency",
					sortable: true,
					cellAttributes: { alignment: "left" }
				},
				{
					label: "ListPrice",
					fieldName: "ListPrice",
					type: "currency",
					sortable: true,
					cellAttributes: { alignment: "left" }
				}
			]),
			//calling helper function
			helper.getData(cmp);
	},
	//Method gets called by onsort action,
	handleSort: function(component, event, helper) {
		var sortBy = event.getParam("fieldName");
		var sortDirection = event.getParam("sortDirection");
		component.set("v.sortBy", sortBy);
		component.set("v.sortDirection", sortDirection);
		helper.sortData(component, sortBy, sortDirection);
	},
	handleResize: function(cmp, event, helper) {
		var sizes = event.getParam("columnWidths");
		var userAction = event.getParam("isUserTriggered");
	},
	handleRowAction: function(cmp, event, helper) {
		var action = event.getParam("action");
		var row = event.getParam("row");
		console.log(row);
		switch (action.name) {
			case "show_details":
				alert("Showing Details: " + JSON.stringify(row));
				break;
			case "delete":
				helper.deleteRow(cmp, row);
				break;
			case "products":
				helper.getProductData(cmp, row);
				break;
           case "createproduct":
                var evt = cmp.getEvent("passoppid");
                evt.setParams("opprecord",row.Id);
                evt.fire();
				helper.getProductFormPage(cmp,row);
				break;
		}
	}
});