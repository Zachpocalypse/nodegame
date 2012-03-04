function Monitor_Ultimatum () {
	
	this.name = 'Monitor screen for Ultimatum Game';
	this.description = 'No Description';
	this.version = '0.3';
	
	this.minPlayers = 2;
	this.maxPlayers = 10;
	
	this.automatic_step = false;
	
	this.init = function() {
		node.window.setup('MONITOR');
	};
	
	function printGameState () {
		var name = node.game.gameLoop.getName(node.game.gameState);
		console.log(name);
	};
	
	// Creating the Game Loop	
	this.loops = {
			
			1: {state:	printGameState,
				name:	'Game will start soon'
			},
			
			2: {state: 	printGameState,
				name: 	'Instructions'
			},
				
			3: {rounds:	10, 
				state: 	printGameState,
				name: 	'Game'
			},
			
			4: {state:	printGameState,
				name: 	'Questionnaire'
			},
				
			5: {state:	printGameState,
				name: 	'Thank you'
			}
	};	
}