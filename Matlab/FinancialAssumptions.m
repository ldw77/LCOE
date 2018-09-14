function [WACC,CPI_Rev,CPI_cost] = FinancialAssumptions(WACC_Components)
Debt = WACC_Components(1);                 % Debt
Equity = WACC_Components(2);               % Equity
RFRoR = WACC_Components(3);                % Risk free Rate of return (RoR)
MarketRisk = WACC_Components(4);           % Market RoR
CorpTac = WACC_Components(5);              % Corporate Tax Rate (Currently 30% in Australia)
EffTax = CorpTac * 0.75;                   % Effective Tax Rate (After dividends etc)
DebtPremium = WACC_Components(6);          % Debt Basis Point Premium
Gamma = WACC_Components(7);                % Gamma
BetaAsset = WACC_Components(8);            % Asset Beta
BetaDebt = WACC_Components(9);             % Debt Beta
BetaEquity = WACC_Components(10);          % Equity Beta
Inflation = WACC_Components(11);           % CPI Consumer Price Index
Liabilities = Debt + Equity;               % Total Enterprise Value
RoR = RFRoR + MarketRisk;                  % Risk free Rate of return (RoR)
DebtCost=DebtPremium + RFRoR;              % Cost of Debt
RoE = RFRoR + (BetaEquity*(RoR-RFRoR));    % Required return on equity CAPM

WACCPostTaxnom=(Equity)* RoE *((1-EffTax)/(1-EffTax*(1-Gamma)))+((Debt)*DebtCost*(1-EffTax)); % Weighted Average Cost of Capital, nominal (Officer equation)

WACCPostTaxReal = ((1+WACCPostTaxnom)/(1+Inflation))-1; % Weighted Average Cost of Capital, nominal (Officer equation)
WACC=WACCPostTaxReal; % Switch for WACC method


%%% CPI Pass Through
Passthrough_rev=WACC_Components(12);       % CPI Pass through rate for Revenue streams
Passthrough_cost=WACC_Components(13);      % CPI Pass through rate for Costs
CPI_Rev_multi=Passthrough_rev*Inflation;   % CPI for Revenue streams
CPI_Cost_multi=Passthrough_cost*Inflation; % CPI for Cost streams

%Vector of CPI values with respect to Revenue
for t=[1:100]
    CPI_Rev(t)=((1+CPI_Rev_multi).^(t));
end
%Vector of CPI values with respect to Costs
for t=[1:100]
    CPI_cost(t)=((1+CPI_Cost_multi).^(t));
end

end
