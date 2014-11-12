Feature: Retrieve character list
	
	For the game client to determine what characters should be shown, a listing of all available character IDs and basic
	information should be available.

	Retrieving the character list with a player ID will only
	provide the characters currently available to the player.

	Scenario: List all characters
		Given the system knows about the following characters
		|	char_id	|	name		|	age		|	description					|
		|	EDV0	|	Claire		|	26		|	An unusually happy woman.	|
		|	EDV1	|	Otis		|	23		|	A grumpy young man.			|

		When the client requests a list of characters
		Then the response is a list containing 2 characters
		And 1 character has the following attributes:
		|	attribute 	|	type	|	value						|
		|	char_id		|	String	|	EDV0						|
		|	name		|	String	|	Claire						|
		|	age			|	Integer	|	26							|
		|	description	|	String	|	An unusually happy woman.	|
		And 1 character has the following attributes:
		|	attribute 	|	type	|	value						|
		|	char_id		|	String	|	EDV1						|
		|	name		|	String	|	Otis						|
		|	age			|	Integer	|	23							|
		|	description	|	String	|	A grumpy young man.			|

	Scenario: List player's available characters
