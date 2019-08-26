function myLerningCurvesWithRandExamples(X, y, Xval, yval)

    m = size(X, 1);
    mv = size(Xval, 1);
    n = size(X, 2);
    
    
    mMax = 0;
    
    if (m < mv)
        mMax = m;
    else
        mMax = mv;
    endif
 
    lambda = 0.01;
    
    error_train = zeros(mMax, 1);
    error_val = zeros(mMax, 1);
    iter = 50;
    
    for k = 1:iter
        for i = 1:mMax
            Xrt = zeros(i, n);
            yrt = zeros(i, 1);
            Xr = zeros(i, n);
            yr = zeros(i, 1);
            Xrv = zeros(i, n);
            yrv = zeros(i, 1);
        
            for j = 1:i
                
                rit = floor(rand() * m) + 1;

                Xrt(j, :) = X(rit, :);
                yrt(j) = y(rit);
            
                ri = floor(rand() * m) + 1;
                rvi = floor(rand() * mv) + 1;
                
                Xr(j, :) = X(ri, :);
                yr(j) = y(ri);
            
                Xrv(j, :) = Xval(rvi, :);
                yrv(j) = yval(rvi);
                
            end
            
        
            theta = trainLinearReg(Xrt, yrt, lambda);
        
            error_train(i) += 1/(2*i) * sum((Xr * theta - yr) .^ 2);
        
            error_val(i) += 1/(2*i) * sum((Xrv * theta - yrv) .^ 2);
            
        end
    end
    
    error_train /= iter;
    error_val /= iter;
    
    tvec = [1:mMax]';
    plot(tvec, error_train, tvec, error_val);
    legend('Train', 'Cross Validation');
  
end
