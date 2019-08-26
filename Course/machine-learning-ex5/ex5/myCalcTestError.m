function myCalcTestError(X, y, Xtest, ytest)

    theta = trainLinearReg(X, y, 3);
    mt = size(Xtest, 1);
    error_test = 1/(2*mt) * sum((Xtest * theta - ytest) .^ 2);
    error_test

end
