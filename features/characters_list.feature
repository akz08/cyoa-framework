Feature: Retrieve character list
	
	For the game client to determine what characters should be shown, 
	a listing of all of the available character IDs and information 
	that a player owns should be accessible.

	All additional DLC characters which the player *does not yet own* 
	should also be accessible separately.

	Background:
		Given the client has a valid player application token
		And the system knows about the following characters
		|	id		|	name		|	age		|	description					|	picture									|
		|	EDV0	|	Claire		|	26		|	An unusually happy woman.	|	https://scontent.example.com/edv0.jpg	|
		|	EDV1	|	Otis		|	23		|	A grumpy young man.			|	https://scontent.example.com/edv1.jpg	|
		|	EDV2	|	Bob			|	21		|	A cool yuppie.				|	https://scontent.example.com/edv2.jpg	|
		And the player owns the following characters
		|	id		|	name		|	age		|	description					|	picture									|
		|	EDV0	|	Claire		|	26		|	An unusually happy woman.	|	https://scontent.example.com/edv0.jpg	|

	Scenario: List player's available characters
		When the client requests a list of characters
		Then the response is a list containing 1 character
		And 1 character has the following attributes:
		|	attribute 	|	type	|	value									|
		|	char		|	String	|	EDV0									|
		|	name		|	String	|	Claire									|
		|	age			|	Integer	|	26										|
		|	description	|	String	|	An unusually happy woman.				|
		|	picture		|	String	|	https://scontent.example.com/edv0.jpg	|

	Scenario: List additional DLC characters
		When the client requests a list of DLC characters
		Then the response is a list containing 2 characters
		And 1 character has the following attributes:
		|	attribute 	|	type	|	value									|
		|	id			|	String	|	EDV1									|
		|	name		|	String	|	Otis									|
		|	age			|	Integer	|	23										|
		|	description	|	String	|	A grumpy young man.						|
		|	picture		|	String	|	https://scontent.example.com/edv1.jpg	|
		And 1 character has the following attributes:
		|	attribute 	|	type	|	value									|
		|	id			|	String	|	EDV2									|
		|	name		|	String	|	Bob										|
		|	age			|	Integer	|	21										|
		|	description	|	String	|	A cool yuppie.							|
		|	picture		|	String	|	https://scontent.example.com/edv2.jpg	|
