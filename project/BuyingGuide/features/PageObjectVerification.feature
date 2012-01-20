Feature: Ensure that page objects work

		@ui @new_user @blocked @page_object
		Scenario: English Landing page has correct active tab and basic layout
      Given user is using page objects to access the default test target environment for the test application
      Then ensure that the user is presented with a pageobject search box 
			And ensure that pageobject Legal link exists
			And ensure that pageobject start link exists
			And ensure that pageobject email link exists
			And ensure that pageobject tab_one exists and is active
			And ensure that pageobject tab_two exists and not active
			And ensure that pageobject tab_three exists and not active