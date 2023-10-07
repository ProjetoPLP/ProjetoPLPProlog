:- consult('ModelCompany.pl').
:- consult('SaveCompany.pl').

main :-
    %createCompany(1, 'EmpresaQuarenta', '2023', '12345678912345', 'atuacao', 'declaracao', 'EP10', 100.0, 'll', 100.0, 100.0, 100, Company),
    %Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    %ok%saveCompany('../../Data/Companies.json', Company), 
    
    %listarCompanies(Out),
    %buscarCompanyPorId(1, Out, Result),
    %write(Result), halt.

    %getCompany(1, Result),
    %write(Result),
    %ok%editarCompany(Company), halt.
    halt.
