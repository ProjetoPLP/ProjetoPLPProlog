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
    printMatrix("../Menus/StartMenu/startMenu.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsStartMenu(UserChoice).

read_line(Line) :-
    read_line([], Line).

read_line(Chars, Line) :-
    get_char(Char),
    (Char = '\n' ->
        reverse(Chars, Line)
    ;   read_line([Char|Chars], Line)
    ).

optionsStartMenu(UserChoice) :-
    (   memberchk('L', UserChoice); memberchk('l', UserChoice) ) ->
        fazerLoginMenu
    ;   (memberchk('U', UserChoice); memberchk('u', UserChoice)) ->
        cadastraUsuarioMenu
    ;   (memberchk('E', UserChoice); memberchk('e', UserChoice)) ->
        cadastraEmpresaMenu
    ;   (memberchk('S', UserChoice); memberchk('s', UserChoice)) ->
        halt
    ;   writeln("Opção Inválida!"),
        startMenu.


fazerLoginMenu :-
    printMatrix("../Menus/StartMenu/loginMenu.txt"),
    write("Deseja fazer login? (S/N): "),
    flush_output,
    read_line(UserChoice),
    (querContinuarAOperacao(UserChoice) ->
        fazerLogin(ResultadoLogin),
        (
            ResultadoLogin ->
            getLoggedUserID(IdUser),
            mainMenu(IdUser)
        ;   
            startMenu
        )
    ;   startMenu
    ).

cadastraUsuarioMenu :-
    printMatrix("../Menus/StartMenu/cadastroUsuario.txt"),
    write("Deseja cadastrar um novo usuário? (S/N): "),
    flush_output,
    read_line(UserChoice),
    (   querContinuarAOperacao(UserChoice) ->
        cadastrarCliente,
        menuCadastroRealizado(true)
    ;   startMenu
    ).

cadastraEmpresaMenu :-
    printMatrix("../Menus/StartMenu/cadastroEmpresa.txt"),
    write("Deseja cadastrar uma nova empresa? (S/N): "),
    flush_output,
    read_line(UserChoice),
    (   querContinuarAOperacao(UserChoice) ->
        getCompanyJSON(CompaniesJson),
        length(CompaniesJson, NumCompanies),
        cadastrarCompany(NumCompanies, Cadastrou),
        menuCadastroRealizado(Cadastrou)
    ;   startMenu
    ).

querContinuarAOperacao(UserChoice) :-
    ( memberchk('S', UserChoice); memberchk('s', UserChoice) ) ->
        true
    ;  false.

menuCadastroRealizado(true) :-
    printMatrix("../Menus/StartMenu/cadastroRealizado.txt"),
    sleep(2),
    startMenu.

menuCadastroRealizado(false) :-
    writeln("Aviso: limite máximo de empresas cadastradas atingido."),
    startMenu.

mainMenu(IdUser) :-
    updateMainMenu(IdUser),
    printMatrix("../Menus/MainMenu/mainMenu.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsMainMenu(IdUser, UserChoice).

optionsMainMenu(IdUser, UserChoice) :-
   (   memberchk('W', UserChoice); memberchk('w', UserChoice) ) ->
        walletMenu(IdUser)
    ;   str(UserChoice, X), validate_input(X, ChoiceInt) ->
        homeBrokerMenu(IdUser, ChoiceInt)
    ;   (   memberchk('A', UserChoice); memberchk('a', UserChoice) ) ->
        homeBrokerMenu(IdUser, 10)
    ;  (   memberchk('B', UserChoice); memberchk('b', UserChoice) ) ->
        homeBrokerMenu(IdUser, 11)
    ;   (   memberchk('C', UserChoice); memberchk('c', UserChoice) ) ->
        homeBrokerMenu(IdUser, 12)
    ;  (   memberchk('S', UserChoice); memberchk('s', UserChoice) ) ->
        startMenu
    ;   writeln("Opção inválida"),
        mainMenu(IdUser).
str([H|_], H).

validate_input(UserChoice, ChoiceInt) :-
    atom_number(UserChoice, ChoiceInt),
    ChoiceInt >= 1,
    ChoiceInt =< 12.

homeBrokerMenu(IdUser, IdComp) :-
(   existCompany(IdComp) ->
    updateHomeBroker(IdUser, IdComp),
    atom_concat('../Models/Company/HomeBrokers/homebroker', IdComp, File),
    atom_concat(File, '.txt', FilePath),
    printMatrix(FilePath),
    write("Digite por quantos segundos a ação deve variar: "),
    flush_output,
    read_line(UserChoice),
    optionsHomeBrokerMenu(IdUser, IdComp, UserChoice)
;   mainMenu(IdUser)
).

optionsHomeBrokerMenu(IdUser, IdComp, UserChoice) :-
    (   memberchk('B', UserChoice); memberchk('b', UserChoice) ) ->
        buyMenu(IdUser, IdComp)
    ;   (   memberchk('S', UserChoice); memberchk('s', UserChoice) ) ->
        sellMenu(IdUser, IdComp)
    ;   (   memberchk('P', UserChoice); memberchk('p', UserChoice) ) ->
        companyProfileMenu(IdUser, IdComp)
    ;   (   memberchk('V', UserChoice); memberchk('v', UserChoice) ) ->
        mainMenu(IdUser)
    ;   number_string(ChoiceInt, UserChoice),
        attGraphs(IdUser, IdComp, ChoiceInt)
    ;   writeln("Opção inválida"),
        homeBrokerMenu(IdUser, IdComp).

attGraphs(IdUser, IdComp, UserChoice) :-
    callLoop(IdComp, UserChoice, IsCurrentCompanyDown),
    menuAfterLoop(IdUser, IdComp, IsCurrentCompanyDown).

menuAfterLoop(IdUser, IdComp, true) :-
    companyDownMenu(IdUser, IdComp).

menuAfterLoop(IdUser, IdComp, false) :-
    getClock("./Data/Clock.json", Clock),
    (   Clock >= 720 ->
        trendingCloseMenu(IdUser)
    ;   homeBrokerMenu(IdUser, IdComp)
    ).
    
companyProfileMenu(IdUser, IdComp) :-
    updateCompanyProfile(IdUser, IdComp),
    printMatrix("../Menus/HomeBroker/CompanyProfile/companyProfile.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsCompanyProfileMenu(IdUser, IdComp, UserChoice).

optionsCompanyProfileMenu(IdUser, IdComp, UserChoice) :-
    (   memberchk('V', UserChoice); memberchk('v', UserChoice) ) ->
        homeBrokerMenu(IdUser, IdComp)
    ;   writeln("Opção Inválida!"),
        companyProfileMenu(IdUser, IdComp).

buyMenu(IdUser, IdComp) :-
    updateHomeBrokerBuy(IdUser, IdComp),
    printMatrix("../Menus/HomeBroker/BuySell/homebrokerBuy.txt"),
    write("Digite quantas ações deseja comprar: "),
    flush_output,
    read_line(UserChoice),
    optionsBuyMenu(IdUser, IdComp, UserChoice).

optionsBuyMenu(IdUser, IdComp, UserChoice) :-
    number_string(Quantity, UserChoice) ->
        buy(IdUser, IdComp, Quantity),
        buyMenu(IdUser, IdComp)
    ;   (   memberchk('V', UserChoice); memberchk('v', UserChoice);
            memberchk('C', UserChoice);memberchk('c', UserChoice)) ->
        homeBrokerMenu(IdUser, IdComp)
    ;   writeln("Opção inválida"),
        buyMenu(IdUser, IdComp).

sellMenu(IdUser, IdComp) :-
    updateHomeBrokerSell(IdUser, IdComp),
    printMatrix("../Menus/HomeBroker/BuySell/homebrokerSell.txt"),
    write("Digite quantas ações deseja vender: "),
    flush_output,
    read_line(UserChoice),
    optionsSellMenu(IdUser, IdComp, UserChoice).

optionsSellMenu(IdUser, IdComp, UserChoice) :-
    number_string(Quantity, UserChoice) ->
        sell(IdUser, IdComp, Quantity),
        sellMenu(IdUser, IdComp)
    ;  (   memberchk('V', UserChoice); memberchk('v', UserChoice);
           memberchk('C', UserChoice);memberchk('c', UserChoice)) ->
        homeBrokerMenu(IdUser, IdComp)
    ;   writeln("Opção inválida"),
        sellMenu(IdUser, IdComp).

walletMenu(IdUser) :-
    updateClientWallet(IdUser),
    atom_concat('../Models/Client/Wallets/wallet', IdUser, FilePath),
    atom_concat(FilePath, '.txt', File),
    printMatrix(File),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsWalletMenu(IdUser, UserChoice).

optionsWalletMenu(IdUser, UserChoice) :-
    (   memberchk('S', UserChoice); memberchk('s', UserChoice) ) ->
        saqueMenu(IdUser)
    ;   (   memberchk('D', UserChoice); memberchk('d', UserChoice) ) ->
        depositoMenu(IdUser)
    ; (   memberchk('V', UserChoice); memberchk('v', UserChoice) ) ->
        mainMenu(IdUser)
    ;   writeln("Opção inválida"),
        walletMenu(IdUser).

saqueMenu(IdUser) :-
    updateWalletSaque(IdUser),
    printMatrix("../Menus/Wallet/DepositoSaque/walletSaque.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsSaqueMenu(IdUser, UserChoice).

optionsSaqueMenu(IdUser, UserChoice) :-
    (   memberchk('2', UserChoice) ) ->
        sacar200(IdUser),
        saqueMenu(IdUser)
    ;   (   memberchk('5', UserChoice) ) ->
        sacar500(IdUser),
        saqueMenu(IdUser)
    ;  (   memberchk('T', UserChoice); memberchk('t', UserChoice) ) ->
        sacarTudo(IdUser),
        saqueMenu(IdUser)
    ;   (   memberchk('V', UserChoice); memberchk('v', UserChoice) ) ->
        walletMenu(IdUser)
    ;   writeln("Opção inválida"),
        saqueMenu(IdUser).

depositoMenu(IdUser) :-
    updateWalletDeposito(IdUser),
    printMatrix("../Menus/Wallet/DepositoSaque/walletDeposito.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsDepositoMenu(IdUser, UserChoice).

optionsDepositoMenu(IdUser, UserChoice) :-
    (   memberchk('S', UserChoice); memberchk('s', UserChoice) ) ->
        depositar(IdUser, CanDeposit),
        depositoMenu(IdUser)
    ;   (   memberchk('V', UserChoice); memberchk('v', UserChoice);
            memberchk('N', UserChoice);memberchk('n', UserChoice)) ->
        walletMenu(IdUser)
    ;   writeln("Opção inválida"),
        depositoMenu(IdUser).


trendingCloseMenu(IdUser) :-
    updateTrendingClose(IdUser),
    setClock(420),
    printMatrix("./Menus/HomeBroker/TrendingClose/trendingClose.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(_),
    mainMenu(IdUser).

companyDownMenu(IdUser, IdComp) :-
    updateCompanyDown(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/CompanyDown/companyDown.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(_),
    mainMenu(IdUser).

formatInputToSeconds(Segundos, FormattedSegundos) :-
    (   number_string(SecondsInt, Segundos),
        SecondsInt > 30 ->
        FormattedSegundos = 30
    ;   number_string(FormattedSegundos, Segundos)
    ).