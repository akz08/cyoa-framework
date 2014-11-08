Feature: Retrieve character list
	
	For the game client to determine what characters should be shown, a listing of all available character IDs and basic
	information should be available.

	Retrieving the character list with a player ID will only
	provide the characters currently available to the player.

	Scenario: List all characters
		Given the system knows about the following characters
		|	id		|	name		|	description				|
		|	EDV0	|	Claire		|	A 26 year old womman.	|
		|	EDV1	|	Otis		|	A 23 year old man.		|

		When the client requests a list of characters
		Then the response is a list containing 2 characters
		And one character has the following attributes:
		|	attribute 	|	type	|	value					|
		|	id			|	String	|	EDV0					|
		|	name		|	String	|	Claire					|
		|	description	|	String	|	A 26 year old woman.	|

	Scenario: List player's available characters
