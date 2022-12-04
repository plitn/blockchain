pragma solidity >=0.7.0 <0.9.0;

/*
Little bit inspired by
https://github.com/ojroques/ethereum-rockpaperscissors/blob/master/rockpaperscissors.sol
*/
contract RockPaperScissors {

    enum Stage {
        Waiting,
        Player1,
        AllPlayers,
        Comm1,
        AllCom,
        Showed1,
        AllShowed
    }
    enum Choice {
        None,
        Rock,
        Paper,
        Scissors
    }
    struct Player {
        address adr;
        bytes32 hash;
        Choice choice;
    }
    struct Game {
        Player player1;
        Player player2;
    }
    event StageChanged(Stage newStage);
    event Winner(address winner);

    
    Game public game;
    Stage public stage;


    /*
    Меняем стадию игры на ту, которую передаем в функцию
    */
    function changeStage(Stage newStage) private {
        stage = newStage;
        emit StageChanged(newStage);
    }

    /*
    Откат до момета когда игра не началась
    */
    function reset() private {
        changeStage(Stage.Waiting);
        game.player1.choice = Choice.None;
        game.player2.choice = Choice.None;
    }

    /*
    Функция для подключения игроков, меняем статус стадии,
    когда они подключаются
    */
    function join() public {
        if(stage == Stage.Waiting) {
            game.player1.adr = msg.sender;
            changeStage(Stage.Player1);
        } else if(stage == Stage.Player1) {
            game.player2.adr = msg.sender;
            changeStage(Stage.AllPlayers);
        } else {
            revert("game error");
        }
    }

    /*
    Коммитим действия игроков, меняем статус стадии
    */
    function commit(bytes32 hash) external {
        if(game.player1.adr == msg.sender) {
            game.player1.hash = hash;
            changeStage(Stage.Comm1);
        } else if(game.player2.adr == msg.sender) {
            game.player2.hash = hash;
            changeStage(Stage.AllCom);
        } else {
            revert("adr error");
        }
    }
    bytes32 public hash;
    /*
    "показываем" фигуры, меняем стадии
    */
    function show(string memory s, uint256 id) external {
        hash = sha256(abi.encodePacked(id, s));
        if(game.player1.adr == msg.sender) {
            require(game.player1.hash == hash, "hash error");
            game.player1.choice = Choice(id);
            changeStage(Stage.Showed1);
        } else if(game.player2.adr == msg.sender) {
            require(game.player2.hash == hash, "hash error");
            game.player2.choice = Choice(id);
            changeStage(Stage.AllShowed);
        } else {
            revert("adr error");
        }
    }

    /*
    находим победителя, сравниваем действия игроков,
    в конце обновляем все параметры до изначальных 
    (как будто игра не началась)
    */
    function getWinner() external {
        require(game.player1.choice == Choice.None 
        || game.player2.choice == Choice.None, 
        "game error");
        if(game.player1.choice == game.player2.choice) {
            emit Winner(address(0x0));
        } else if((game.player1.choice == Choice.Rock 
        && game.player1.choice == Choice.Scissors) ||
        (game.player1.choice == Choice.Paper 
        && game.player1.choice == Choice.Rock) ||
        (game.player1.choice == Choice.Scissors 
        && game.player1.choice == Choice.Paper)) {
            emit Winner(game.player1.adr);
        } else {
            emit Winner(game.player2.adr);
        }
        reset();
    }
}