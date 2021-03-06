function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m, 1) X];

Z2t = Theta1 * X';
Z2 = Z2t';
A2t = sigmoid(Z2t);
A2t = [ones(1, m); A2t];      % This is transposed A matrix on level 2 (t suffix means transposed)
A2 = A2t';
Z3t = Theta2 * A2t;           % Transposed Z matrix at level 3 (t suffix means transposed)
A3t = sigmoid(Z3t);
A3 = A3t';

for i = 1:m

    yb = zeros(num_labels, 1);  % yb   -  vector y with binary values
    yb(y(i)) = 1;

    h = A3(i, :)';

    J += sum(-yb.*(log(h)) - (1 - yb).*(log(1-h)))/m;
end

J += lambda/(2*m) * ((sum(sum(Theta1(:, 2:end).^2)) + sum(sum(Theta2(:, 2:end).^2))));


deltaSum1 = zeros(size(Theta1, 1), size(Theta1, 2) - 1);
deltaSum2 = zeros(size(Theta2, 1), size(Theta2, 2) - 1);

for i = 1:m

    yb = zeros(num_labels, 1);
    yb(y(i)) = 1;
    
    a3 = A3(i, :)';

    delta3 = a3 - yb;

    temp2 = Theta2' * delta3;
    delta2 = temp2(2:end) .* sigmoidGradient(Z2(i, :)');

    Theta1_grad += delta2 * X(i, :);
    Theta2_grad += delta3 * A2(i, :);

end    

Theta1_grad /= m;
Theta2_grad /= m;

ThetaReg1 = Theta1;
ThetaReg1(:, 1) = 0;
ThetaReg2 = Theta2;
ThetaReg2(:, 1) = 0;

Theta1_grad += lambda / m * ThetaReg1;
Theta2_grad += lambda / m * ThetaReg2;


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
