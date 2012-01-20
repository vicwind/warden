Feature: Ensure that page objects work

		@ui @new_user @blocked @page_object
		Scenario: English Landing page has correct active tab and basic layout
      Given user is using page objects to access the default test target environment for the test application
      Then ensure that the user is presented with a pageobject search box 
			And ensure that pageobject Legal link exists
			And ensure that pageobject start link exists
			And ensure that pageobject email link exists
			And ensure that pageobject Find My New tab exists and is active
			And ensure that pageobject Dealzone tab exists and not active
			And ensure that pageobject Top Rated exists and not active
			
    @ui @new_user @blocked @page_object
    Scenario: English Landing page has correct active tab and basic layout
      Given user is using page objects to access the default test target environment for the test application
      When the user clicks on the deal zone tab
      Then ensure that the user is presented with View All Deals button
      And ensure that the user can click the View All Deals button
