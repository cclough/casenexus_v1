Feature: Signing in

Scenario: Unsuccessful signin
	Given a user visits the signin page
	When he submit invalid signin information
	Then he should see an error message

Scenario: Successful signin
	Given a user visits the signin page
	And the user has an account
	And the user submits valid signin information