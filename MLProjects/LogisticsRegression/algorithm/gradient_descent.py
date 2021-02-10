from matplotlib.pyplot import axis
import numpy as np

class GradientDescent:

    @classmethod
    def calculate_params(cls, x1, x2, y):

        learning_rate = 10
        num_iterations = 5000

        w = np.array([[0], [0]])
        b = 0

        X = np.row_stack((x1, x2))
        Y = np.reshape(y, (1, -1))

        m = X.shape[1]

        mu = X.sum(axis=1, keepdims=True)/m
        X = X - mu

        X_norm = np.linalg.norm(X, axis=1, keepdims=True)
        X = X / X_norm

        w, b, dw, db, cost = cls.optimize(w, b, X, Y, learning_rate, num_iterations)

        print("\nResult:\n")
        print(f'w = {w}')
        print(f'b = {b}')
        print(f'cost = {cost}')
        print(f'learning_rate = {learning_rate}')
        print(f'num_iterations = {num_iterations}')

        return w, b, mu, X_norm


    @classmethod
    def optimize(cls, w, b, X, Y, learning_rate, num_iterations):

        dw, db, cost = 0, 0, 0
        for i in range(num_iterations):
            dw, db, cost = cls.propagate(w, b, X, Y)
            w = w - learning_rate * dw
            b = b - learning_rate * db

            if (i % 1000 == 0):
                print(f'cost = {cost}')

        return w, b, dw, db, cost

    @classmethod
    def propagate(cls, w, b, X, Y):

            m = X.shape[1]

            # Forward propagation
            Z = np.dot(w.T, X) + b
            A = cls.sigmoid(Z)

            # Backward propagation
            dZ = A - Y
            dw = 1/m * np.dot(X, dZ.T)
            db = 1/m * np.sum(dZ)

            cost = -1/m * np.sum(Y*np.log(A) + (1-Y)*np.log(1-A))

            return dw, db, cost

    @staticmethod
    def sigmoid(x):
        return 1/(1 + np.exp(-x))
