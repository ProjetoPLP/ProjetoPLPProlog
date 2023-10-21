:- consult('../Utils/MatrixUtils.pl').
:- consult('../Utils/VerificationUtils.pl').
:- consult('../Models/Client/RealizarLogin.pl').
:- consult('../Models/Client/CadastrarCliente.pl').
:- consult('../Models/Client/GetSetAttrsClient.pl').
:- consult('../Models/Client/LoginClient.pl').
:- consult('../Models/Company/CadastrarCompany.pl').
:- consult('../Models/Company/SaveCompany.pl').
:- consult('./Wallet/DepositoSaque/WalletDepSaqLogic.pl').
:- consult('./Wallet/WalletUpdate.pl').
:- consult('./HomeBroker/HomeBrokerUpdate.pl').
:- consult('./HomeBroker/BuySell/HomeBrokerBuySellLogic.pl').
:- consult('./HomeBroker/HomeBrokerLoopLogic.pl').
:- consult('./HomeBroker/CompanyProfile/CompanyProfileUpdate.pl').
:- consult('./HomeBroker/TrendingClose/TrendingCloseUpdate.pl').
:- consult('./HomeBroker/CompanyDown/CompanyDownUpdate.pl').
:- consult('./MainMenu/MainMenuUpdate.pl').
:- consult('../Models/Clock/GetSetClock.pl').


startMenu :-
    logoutClient,
    printMatrix("./Menus/StartMenu/startMenu.txt"),
    write("Digite uma opção: "),
    flush_output,                                                       %%%% FOR WHAT?
    read_line_to_string(user_input, UserChoice),
    optionsStartMenu(UserChoice).


optionsStartMenu(UserChoice) :-
    (UserChoice == "L" ; UserChoice ==  "l") -> fazerLoginMenu ;   
    (UserChoice == "U" ; UserChoice ==  "u") -> cadastraUsuarioMenu ;
    (UserChoice == "E" ; UserChoice ==  "e") -> cadastraEmpresaMenu ;
    (UserChoice == "S" ; UserChoice ==  "s") -> halt ;
    writeln("Opção Inválida!"), startMenu.


fazerLoginMenu :-
    printMatrix("./Menus/StartMenu/loginMenu.txt"),
    write("Deseja fazer login? (S/N): "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    (querContinuarAOperacao(UserChoice) ->
        fazerLogin(ResultadoLogin),
        (ResultadoLogin ->
            getLoggedUserID(IdUser),
            mainMenu(IdUser)
        ;   
            startMenu
        )
    ;
        startMenu
    ).


cadastraUsuarioMenu :-
    printMatrix("./Menus/StartMenu/cadastroUsuario.txt"),
    write("Deseja cadastrar um novo usuário? (S/N): "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    (querContinuarAOperacao(UserChoice) ->
        cadastrarCliente,
        menuCadastroRealizado(true)
    ;   
        startMenu
    ).


cadastraEmpresaMenu :-
    printMatrix("./Menus/StartMenu/cadastroEmpresa.txt"),
    write("Deseja cadastrar uma nova empresa? (S/N): "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    (querContinuarAOperacao(UserChoice) ->
        getCompanyJSON(CompaniesJson),
        length(CompaniesJson, NumCompanies),
        cadastrarCompany(NumCompanies, Cadastrou),
        menuCadastroRealizado(Cadastrou)
    ;   
        startMenu
    ).


querContinuarAOperacao(UserChoice) :-
    (UserChoice == "S" ; UserChoice == "s") -> true ; !, false.


menuCadastroRealizado(true) :-
    printMatrix("./Menus/StartMenu/cadastroRealizado.txt"),
    sleep(2),
    startMenu.

menuCadastroRealizado(false) :-
    writeln("Aviso: limite máximo de empresas cadastradas atingido."),
    startMenu.


mainMenu(IdUser) :-
    updateMainMenu(IdUser),
    printMatrix("./Menus/MainMenu/mainMenu.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsMainMenu(IdUser, UserChoice).


optionsMainMenu(IdUser, UserChoice) :-
    (UserChoice == "W" ; UserChoice ==  "w") -> walletMenu(IdUser) ;
    (UserChoice == "1") -> homeBrokerMenu(IdUser, 1) ;
    (UserChoice == "2") -> homeBrokerMenu(IdUser, 2) ;
    (UserChoice == "3") -> homeBrokerMenu(IdUser, 3) ;
    (UserChoice == "4") -> homeBrokerMenu(IdUser, 4) ;
    (UserChoice == "5") -> homeBrokerMenu(IdUser, 5) ;
    (UserChoice == "6") -> homeBrokerMenu(IdUser, 6) ;
    (UserChoice == "7") -> homeBrokerMenu(IdUser, 7) ;
    (UserChoice == "8") -> homeBrokerMenu(IdUser, 8) ;
    (UserChoice == "9") -> homeBrokerMenu(IdUser, 9) ;
    (UserChoice == "A" ; UserChoice ==  "a") -> homeBrokerMenu(IdUser, 10) ;
    (UserChoice == "B" ; UserChoice ==  "b") -> homeBrokerMenu(IdUser, 11) ;
    (UserChoice == "C" ; UserChoice ==  "c") -> homeBrokerMenu(IdUser, 12) ;
    (UserChoice == "S" ; UserChoice ==  "s") -> startMenu ;
    writeln("Opção inválida"), mainMenu(IdUser).


homeBrokerMenu(IdUser, IdComp) :-
    (existCompany(IdComp)) -> 
        updateHomeBroker(IdUser, IdComp),
        homeBrokerFilePath(IdComp, FilePath),
        printMatrix(FilePath),
        write("Digite por quantos segundos a ação deve variar: "),
        flush_output,
        read_line_to_string(user_input, UserChoice),
        optionsHomeBrokerMenu(IdUser, IdComp, UserChoice)
    ;   
        mainMenu(IdUser).
    

optionsHomeBrokerMenu(IdUser, IdComp, UserChoice) :-
    (UserChoice == "B" ; UserChoice ==  "b") -> buyMenu(IdUser, IdComp) ;
    (UserChoice == "S" ; UserChoice ==  "s") -> sellMenu(IdUser, IdComp) ;
    (UserChoice == "P" ; UserChoice ==  "p") -> companyProfileMenu(IdUser, IdComp) ;
    (UserChoice == "V" ; UserChoice ==  "v") -> mainMenu(IdUser) ;
    (isNumber(UserChoice)) -> attGraphs(IdUser, IdComp, UserChoice) ;
    writeln("Opção inválida"), homeBrokerMenu(IdUser, IdComp).


attGraphs(IdUser, IdComp, UserChoice) :-
    formatInputToSeconds(UserChoice, Seconds),
    (callLoop(IdComp, Seconds)) -> 
    menuAfterLoop(IdUser, IdComp, true) ;
    menuAfterLoop(IdUser, IdComp, false).


menuAfterLoop(IdUser, IdComp, IsCurrentCompanyDown) :-
    (IsCurrentCompanyDown) -> 
        companyDownMenu(IdUser, IdComp)
    ;
    getClock(Minutes),
    (Minutes >= 720) -> 
        trendingCloseMenu(IdUser)
    ;
        homeBrokerMenu(IdUser, IdComp).
    

companyProfileMenu(IdUser, IdComp) :-
    updateCompanyProfile(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/CompanyProfile/companyProfile.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsCompanyProfileMenu(IdUser, IdComp, UserChoice).


optionsCompanyProfileMenu(IdUser, IdComp, UserChoice) :-
    (UserChoice == "V" ; UserChoice ==  "v") -> homeBrokerMenu(IdUser, IdComp) ;
    writeln("Opção Inválida!"),
    companyProfileMenu(IdUser, IdComp).


buyMenu(IdUser, IdComp) :-
    updateHomeBrokerBuy(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/BuySell/homebrokerBuy.txt"),
    write("Digite quantas ações deseja comprar: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsBuyMenu(IdUser, IdComp, UserChoice).


optionsBuyMenu(IdUser, IdComp, UserChoice) :-
    (isNumber(UserChoice)) -> 
        atom_number(UserChoice, Qtd),
        buy(IdUser, IdComp, Qtd),
        buyMenu(IdUser, IdComp)
    ;
    (member(UserChoice, ["V", "v", "C", "c"])) -> 
        homeBrokerMenu(IdUser, IdComp)
    ;
        writeln("Opção Inválida!"),
        buyMenu(IdUser, IdComp).


sellMenu(IdUser, IdComp) :-
    updateHomeBrokerSell(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/BuySell/homebrokerSell.txt"),
    write("Digite quantas ações deseja vender: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsSellMenu(IdUser, IdComp, UserChoice).


optionsSellMenu(IdUser, IdComp, UserChoice) :-
    (isNumber(UserChoice)) -> 
        atom_number(UserChoice, Qtd),
        sell(IdUser, IdComp, Qtd),
        sellMenu(IdUser, IdComp)
    ;
    (member(UserChoice, ["V", "v", "C", "c"])) -> 
        homeBrokerMenu(IdUser, IdComp)
    ;
        writeln("Opção Inválida!"),
        sellMenu(IdUser, IdComp).


walletMenu(IdUser) :-
    updateClientWallet(IdUser),
    walletFilePath(IdUser, FilePath),
    printMatrix(FilePath),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsWalletMenu(IdUser, UserChoice).


optionsWalletMenu(IdUser, UserChoice) :-
    (UserChoice == "S" ; UserChoice ==  "s") -> saqueMenu(IdUser) ;
    (UserChoice == "D" ; UserChoice ==  "d") -> depositoMenu(IdUser) ;
    (UserChoice == "V" ; UserChoice ==  "v") -> mainMenu(IdUser) ;
    writeln("Opção inválida"), walletMenu(IdUser).


saqueMenu(IdUser) :-
    updateWalletSaque(IdUser),
    printMatrix("./Menus/Wallet/DepositoSaque/walletSaque.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsSaqueMenu(IdUser, UserChoice).


optionsSaqueMenu(IdUser, UserChoice) :-
    (UserChoice == "2") -> sacar200(IdUser), saqueMenu(IdUser) ;
    (UserChoice == "5") -> sacar500(IdUser), saqueMenu(IdUser) ;
    (UserChoice == "T" ; UserChoice ==  "t") -> sacarTudo(IdUser), saqueMenu(IdUser) ;
    (UserChoice == "V" ; UserChoice ==  "v") -> walletMenu(IdUser) ;
    writeln("Opção inválida"), saqueMenu(IdUser).


depositoMenu(IdUser) :-
    updateWalletDeposito(IdUser),
    printMatrix("./Menus/Wallet/DepositoSaque/walletDeposito.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    optionsDepositoMenu(IdUser, UserChoice).


optionsDepositoMenu(IdUser, UserChoice) :-
    (UserChoice == "S" ; UserChoice ==  "s") ->
        getCanDeposit(IdUser, CanDeposit),
        depositar(IdUser, CanDeposit),
        depositoMenu(IdUser)
    ;
    (member(UserChoice, ["V", "v", "N", "n"])) ->
        walletMenu(IdUser)
    ;
        writeln("Opção inválida"), depositoMenu(IdUser).


trendingCloseMenu(IdUser) :-
    updateTrendingClose(IdUser),
    setClock(420),
    printMatrix("./Menus/HomeBroker/TrendingClose/trendingClose.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, _),
    mainMenu(IdUser).


companyDownMenu(IdUser, IdComp) :-
    updateCompanyDown(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/CompanyDown/companyDown.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, _),
    mainMenu(IdUser).


formatInputToSeconds(UserChoice, Seconds) :-
    atom_number(UserChoice, FormatedSeconds),
    (FormatedSeconds > 30 -> Seconds is 30 ; Seconds is FormatedSeconds).